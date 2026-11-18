// =====================================================================
// FILE   : lib/config/app_config.dart
// FUNGSI : SATU-SATUNYA tempat untuk mengubah hal-hal yang "di-hardcode".
//          Besok kalau API/datanya beda, 90% perubahan cukup di file INI.
//
// LEGENDA KOMENTAR (bisa kamu cari pakai Ctrl+Shift+F):
//   [HARDCODE] = nilai yang BOLEH/PERLU kamu ganti sesuai soal
//   [FUNGSI]   = penjelasan sebuah fungsi / method
//   [REF]      = menunjuk file lain yang memakai / dipakai bagian ini
// =====================================================================

import 'package:flutter/material.dart'; // dibutuhkan karena ada tipe Color

class AppConfig {
  // "static const" = nilai tetap yang bisa dipanggil tanpa membuat objek,
  // contoh pemanggilan di file lain:  AppConfig.appName

  // ------------------------------------------------------------------
  // 1. IDENTITAS APLIKASI
  // ------------------------------------------------------------------
  static const String appName = 'Toko Dasco Hina'; // [HARDCODE] judul aplikasi
  // [REF] dipakai di main.dart (title) dan login_page.dart (judul besar)

  static const Color themeColor =
      Colors.blue; // [HARDCODE] warna utama aplikasi
  // [REF] dipakai di main.dart (ThemeData)

  // ------------------------------------------------------------------
  // 2. LOGIN
  // ------------------------------------------------------------------
  static const String loginPassword =
      '124240066'; // [HARDCODE] GANTI DENGAN NIM KAMU
  // [REF] dibandingkan dengan input user di login_page.dart (fungsi _login)

  // ------------------------------------------------------------------
  // 3. API EKSTERNAL
  // ------------------------------------------------------------------
  static const String apiUrl =
      "https://fakestoreapi.com/products/"; // [HARDCODE] URL endpoint daftar data
  // [REF] dipakai di services/api_service.dart (fungsi fetchItems)

  // Nama "kunci" yang membungkus list di JSON.
  // Contoh JSON dummyjson: { "products": [ {...}, {...} ], "total": 100 }
  //                                ^^^^^^^^ inilah listKey
  // Kalau JSON-nya langsung list  [ {...}, {...} ]  -> isi dengan '' (kosong).
  // Contoh API lain: meals -> 'meals', recipes -> 'recipes', results -> 'results'
  static const String listKey = 'products'; // [HARDCODE]

  // ------------------------------------------------------------------
  // 4. PEMETAAN FIELD JSON  ->  FIELD APLIKASI
  //    Isi dengan NAMA KEY di JSON milik API kamu.
  //    Boleh nested pakai titik, contoh 'dimensions.width'.
  // ------------------------------------------------------------------
  static const String idKey = 'id'; // [HARDCODE] id unik tiap item
  static const String titleKey = 'title'; // [HARDCODE] judul/nama utama
  static const String subtitleKey =
      'category'; // [HARDCODE] teks kecil di bawah judul
  static const String imageKey =
      'thumbnail'; // [HARDCODE] URL gambar (kalau berupa list, diambil yg pertama)
  static const String descriptionKey =
      'description'; // [HARDCODE] deskripsi panjang
  static const String priceKey =
      'price'; // [HARDCODE] harga (angka). Kosongkan '' jika tidak ada
  static const String stockKey =
      'stock'; // [HARDCODE] stok/batas qty. Kosongkan '' jika tidak ada
  static const String ratingKey =
      'rating'; // [HARDCODE] rating. Kosongkan '' jika tidak ada
  static const imagekey = 'image';
  // [REF] semua key di atas dibaca di models/item_model.dart (factory fromJson)

  // Info tambahan yang ingin ditampilkan di halaman Detail.
  // Format:  'Label yang tampil' : 'key di JSON'
  static const Map<String, String> extraFields = {
    // [HARDCODE] tambah / hapus baris sesuai data API
    'Brand': 'brand',
    'Kategori': 'category',
    'Garansi': 'warrantyInformation',
  };
  // [REF] ditampilkan di pages/detail_page.dart

  // ------------------------------------------------------------------
  // 5. KUANTITAS (QTY)
  // ------------------------------------------------------------------
  static const int minQty = 1; // [HARDCODE] qty minimal (soal: 0 < qty)
  static const int defaultMaxQty =
      10; // [HARDCODE] batas qty jika API TIDAK punya stok
  // [REF] dipakai di pages/detail_page.dart (tombol + dan -)

  // ------------------------------------------------------------------
  // 6. FITUR OPSIONAL (true = aktif, false = mati)
  // ------------------------------------------------------------------
  static const bool enableNotification =
      true; // [HARDCODE] notifikasi saat Add to Cart
  static const bool enableLocation =
      true; // [HARDCODE] tombol "Lihat Lokasi" di Profile
  // [REF] enableNotification dipakai main.dart & detail_page.dart,
  //       enableLocation dipakai profile_page.dart

  static const String notifChannelId =
      'cart_channel'; // [HARDCODE] id channel notifikasi Android
  static const String notifChannelName =
      'Keranjang'; // [HARDCODE] nama channel (muncul di pengaturan HP)

  // ------------------------------------------------------------------
  // 7. TEKS TAMPILAN (label yang dilihat user)
  // ------------------------------------------------------------------
  static const bool showPrice =
      true; // [HARDCODE] false jika data TIDAK punya harga (sembunyikan harga & total)
  // [REF] dipakai di item_card.dart, detail_page.dart, cart_page.dart
  static const String currency =
      '\$'; // [HARDCODE] simbol mata uang (\$ = tanda dollar). Contoh lain: 'Rp '
  static const String itemLabel =
      'Produk'; // [HARDCODE] sebutan item: Produk / Resep / Film / Buku
  static const String cartLabel =
      'Keranjang'; // [HARDCODE] sebutan keranjang: Keranjang / Favorit / Watchlist
  static const String greeting = 'Halo'; // [HARDCODE] sapaan di halaman Home
  static const String addButtonText =
      'Add to Cart'; // [HARDCODE] teks tombol tambah
  static const String
      profileDescription = // [HARDCODE] deskripsi di halaman Profile (bebas)
      'Mahasiswa yang sedang belajar Flutter. Terus semangat belajar ngoding!';
  static const String
      profileMessage = // [HARDCODE] "pesan" tambahan di Profile (bebas)
      'Error adalah guru terbaik kita.';
}
