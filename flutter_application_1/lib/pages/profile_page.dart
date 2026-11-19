import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  final String email; // email dari SharedPreferences

  const ProfilePage({super.key, required this.email});

  Future<void> _logout(BuildContext context) async {
    await StorageService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Jumlah produk di keranjang, dibaca dari Hive.
    final cartCount = StorageService.cartCount();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          // Avatar: huruf pertama email
          Center(
            child: CircleAvatar(
              radius: 40,
              child: Text(email[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(height: 24),

          // Kartu informasi
          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(email),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: const Text('Produk di keranjang'),
                  subtitle: Text('$cartCount'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Tombol logout
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
            ),
          ),
        ],
      ),
    );
  }
}
