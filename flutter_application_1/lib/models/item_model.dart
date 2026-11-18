// =====================================================================
// FILE   : lib/models/item_model.dart
// FUNGSI : Cetakan (class) untuk SATU data dari API (satu produk/resep/film).
//          Materi Pt 1 (OOP): class, constructor, factory.
// [REF]  dibuat di services/api_service.dart, ditampilkan di home_page,
//        item_card, dan detail_page.
// =====================================================================

import '../config/app_config.dart'; // supaya bisa membaca nama key JSON dari config

// ---------------------------------------------------------------------
// [FUNGSI] pick : mengambil nilai dari JSON berdasarkan "path".
//   Contoh : pick(json, 'title')           -> json['title']
//            pick(json, 'dimensions.width') -> json['dimensions']['width']
//   Jika key tidak ada -> mengembalikan null (TIDAK error).
// [REF] juga dipakai di services/api_service.dart untuk membuka listKey.
// ---------------------------------------------------------------------
dynamic pick(dynamic root, String path) {
  if (path.isEmpty) return null; // path kosong = fitur ini tidak dipakai
  dynamic current = root; // posisi sekarang di dalam JSON, mulai dari paling luar
  for (final part in path.split('.')) {
    // pecah path berdasarkan titik, lalu masuk satu per satu
    if (current is Map && current.containsKey(part)) {
      current = current[part]; // masuk ke level berikutnya
    } else {
      return null; // key tidak ditemukan
    }
  }
  return current; // hasil akhir
}

// [FUNGSI] _toText : mengubah nilai apapun jadi String yang aman ditampilkan.
String _toText(dynamic v) {
  if (v == null) return '-'; // data kosong ditulis tanda strip
  if (v is List) return v.map((e) => e.toString()).join(', '); // list digabung koma
  return v.toString(); // selain itu langsung diubah ke teks
}

// [FUNGSI] _toImage : mengambil URL gambar. Kalau datanya List, ambil elemen pertama.
String _toImage(dynamic v) {
  if (v == null) return '';
  if (v is List) return v.isNotEmpty ? v.first.toString() : '';
  return v.toString();
}

class ItemModel {
  // "final" = nilainya diisi sekali saat objek dibuat, tidak boleh diubah lagi.
  final String id; // id unik (String supaya aman untuk API yang idnya teks)
  final String title; // judul
  final String subtitle; // teks kecil (kategori dsb)
  final String imageUrl; // alamat gambar
  final String description; // deskripsi panjang
  final double price; // harga
  final int stock; // stok = batas maksimal qty
  final double rating; // rating
  final Map<String, String> extras; // info tambahan: label -> isi

  // Constructor : cara membuat objek ItemModel. "required" = wajib diisi.
  ItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.stock,
    required this.rating,
    required this.extras,
  });

  // -------------------------------------------------------------------
  // [FUNGSI] fromJson : mengubah satu Map JSON menjadi objek ItemModel.
  //   "factory" = constructor khusus yang bisa menghitung dulu sebelum membuat objek.
  //   Semua nama key diambil dari AppConfig -> jadi TIDAK perlu diedit di sini.
  // [REF] dipanggil di services/api_service.dart (fetchItems)
  // -------------------------------------------------------------------
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    // 1) Siapkan info tambahan sesuai AppConfig.extraFields
    final extras = <String, String>{};
    AppConfig.extraFields.forEach((label, key) {
      extras[label] = _toText(pick(json, key)); // simpan: label -> isi JSON
    });

    // 2) Ambil stok. Kalau stockKey kosong / datanya tidak ada -> pakai defaultMaxQty
    final stockValue = int.tryParse(pick(json, AppConfig.stockKey).toString());
    // tryParse mengembalikan null kalau gagal diubah jadi angka (tidak error)

    // 3) Rakit objek ItemModel
    return ItemModel(
      id: _toText(pick(json, AppConfig.idKey)),
      title: _toText(pick(json, AppConfig.titleKey)),
      subtitle: _toText(pick(json, AppConfig.subtitleKey)),
      imageUrl: _toImage(pick(json, AppConfig.imageKey)),
      description: _toText(pick(json, AppConfig.descriptionKey)),
      price: double.tryParse(pick(json, AppConfig.priceKey).toString()) ?? 0,
      // "?? 0" artinya: kalau hasilnya null pakai 0
      stock: stockValue ?? AppConfig.defaultMaxQty,
      rating: double.tryParse(pick(json, AppConfig.ratingKey).toString()) ?? 0,
      extras: extras,
    );
  }
}
