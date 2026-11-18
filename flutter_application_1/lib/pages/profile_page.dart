// =====================================================================
// FILE   : lib/pages/profile_page.dart
// FUNGSI : Halaman Profile: username, deskripsi, (opsional) lokasi, dan Logout.
// [REF]  teks diambil dari config/app_config.dart | logout memakai
//        services/session_service.dart | lokasi: services/location_service.dart
// =====================================================================

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';
import '../models/cart_item.dart';
import '../services/hive_service.dart';
import '../services/location_service.dart';
import '../services/session_service.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _locationText = 'Lokasi belum diambil'; // teks hasil LBS
  bool _loadingLocation = false; // true saat sedang mengambil lokasi

  // [FUNGSI] _logout : hapus session lalu kembali ke Login.
  //   Data cart di Hive TIDAK dihapus (jadi saat user login lagi, cart-nya masih ada).
  Future<void> _logout() async {
    await SessionService.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      // pushAndRemoveUntil = buka Login lalu HAPUS semua halaman sebelumnya
      // (return false = hapus semua), jadi tombol back tidak bisa kembali.
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // [FUNGSI] _getLocation : ambil koordinat lalu tampilkan.
  Future<void> _getLocation() async {
    setState(() => _loadingLocation = true); // tampilkan loading
    final pos = await LocationService.getCurrentPosition(); // [REF] services/location_service.dart
    setState(() {
      _loadingLocation = false;
      _locationText = pos == null
          ? 'Gagal: izin ditolak / GPS mati' // [HARDCODE] pesan gagal
          : 'Lat: ${pos.latitude}\nLng: ${pos.longitude}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            Text(widget.username, // username yang sedang login
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            // Jumlah item di cart user ini (otomatis update berkat listenable)
            ValueListenableBuilder<Box<CartItem>>(
              valueListenable: HiveService.box.listenable(),
              builder: (_, __, ___) => Text(
                  '${HiveService.itemsOf(widget.username).length} item di ${AppConfig.cartLabel}'),
            ),
            const Divider(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Kesan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(AppConfig.profileDescription),
            ),
            const SizedBox(height: 12),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Pesan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(AppConfig.profileMessage),
            ),
            // "if" di dalam list: bagian ini hanya muncul jika fitur lokasi aktif.
            if (AppConfig.enableLocation) ...[
              const Divider(height: 32),
              Text(_locationText, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _loadingLocation ? null : _getLocation,
                icon: const Icon(Icons.my_location),
                label: Text(_loadingLocation ? 'Mengambil...' : 'Lihat Lokasi'),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
