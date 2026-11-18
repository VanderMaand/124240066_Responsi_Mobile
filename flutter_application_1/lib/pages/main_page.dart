// =====================================================================
// FILE   : lib/pages/main_page.dart
// FUNGSI : Kerangka halaman utama dengan Bottom Navigation Bar (Home, Profile).
//          Materi Pt 4 (Navigation).
// [REF]  menampilkan HomePage (home_page.dart) dan ProfilePage (profile_page.dart)
// =====================================================================

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends StatefulWidget {
  final String username; // username yang login, diteruskan ke halaman-halaman anak
  const MainPage({super.key, required this.username});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0; // tab aktif: 0 = Home, 1 = Profile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack = semua halaman "hidup" tapi hanya satu yang terlihat.
      // Keuntungan: saat pindah tab, list Home TIDAK dimuat ulang dari API.
      body: IndexedStack(
        index: _index,
        children: [
          HomePage(username: widget.username), // tab 0
          ProfilePage(username: widget.username), // tab 1
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index, // tab yang sedang ditandai
        onTap: (i) => setState(() => _index = i), // saat diketuk, ganti tab
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
