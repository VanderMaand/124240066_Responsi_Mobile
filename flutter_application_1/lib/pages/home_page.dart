// =====================================================================
// FILE   : lib/pages/home_page.dart
// FUNGSI : Halaman Home: info username, tombol ke Cart, dan list data dari API.
//          Materi Pt 3 (State), Pt 4 (Navigation), Pt 6 (HTTP).
// [REF]  data: services/api_service.dart | kartu: widgets/item_card.dart
//        tujuan: detail_page.dart dan cart_page.dart
// =====================================================================

import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/item_model.dart';
import '../services/api_service.dart';
import '../widgets/item_card.dart';
import 'cart_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService(); // objek untuk memanggil API
  late Future<List<ItemModel>> _future; // "wadah" hasil request yang akan datang
  // "late" = nilainya diisi nanti (di initState), bukan saat deklarasi.

  // [FUNGSI] initState : dijalankan SEKALI saat halaman pertama dibuat.
  @override
  void initState() {
    super.initState();
    _future = _api.fetchItems(); // mulai ambil data dari API
  }

  // [FUNGSI] _reload : ambil ulang data (dipakai tarik-untuk-refresh & tombol "Coba lagi").
  Future<void> _reload() async {
    setState(() => _future = _api.fetchItems());
    await _future.catchError((_) => <ItemModel>[]); // tunggu selesai, error ditangani FutureBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppConfig.greeting}, ${widget.username}'), // info username login
        actions: [
          // Tombol cart di pojok kanan atas
          IconButton(
            tooltip: AppConfig.cartLabel,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
              // push = buka halaman baru di atas halaman ini (tombol back tersedia)
              context,
              MaterialPageRoute(
                  builder: (_) => CartPage(username: widget.username)),
            ),
          ),
        ],
      ),
      // FutureBuilder = widget yang menggambar UI berdasarkan status Future:
      // menunggu / error / sukses.
      body: FutureBuilder<List<ItemModel>>(
        future: _future,
        builder: (context, snapshot) {
          // 1) Sedang loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2) Error (internet mati, URL salah, listKey salah, dsb)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Terjadi kesalahan:\n${snapshot.error}',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                        onPressed: _reload, child: const Text('Coba lagi')),
                  ],
                ),
              ),
            );
          }
          // 3) Sukses
          final items = snapshot.data ?? []; // kalau null pakai list kosong
          if (items.isEmpty) {
            return const Center(child: Text('Data kosong'));
          }
          return RefreshIndicator(
            onRefresh: _reload, // tarik layar ke bawah untuk refresh
            child: ListView.builder(
              // builder = hanya membuat item yang terlihat (hemat memori)
              itemCount: items.length, // jumlah item
              itemBuilder: (context, index) {
                final item = items[index]; // item ke-"index"
                return ItemCard(
                  item: item,
                  onTap: () => Navigator.push(
                    // Saat item ditekan -> ke halaman Detail, bawa data item
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailPage(item: item, username: widget.username),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
