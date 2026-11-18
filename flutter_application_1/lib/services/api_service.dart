// =====================================================================
// FILE   : lib/services/api_service.dart
// FUNGSI : Semua urusan HTTP Request (Materi Pt 6).
// [REF]  dipanggil di pages/home_page.dart
// =====================================================================

import 'dart:convert'; // untuk jsonDecode (teks JSON -> Map/List)
import 'package:http/http.dart' as http; // "as http" = semua fungsi dipanggil lewat http.xxx
import '../config/app_config.dart';
import '../models/item_model.dart'; // berisi ItemModel dan fungsi pick

class ApiService {
  // -------------------------------------------------------------------
  // [FUNGSI] fetchItems : mengambil SEMUA data dari API lalu mengubahnya
  //   menjadi List<ItemModel>.
  //   "Future" = hasilnya datang nanti (menunggu internet), jadi pakai async/await.
  // -------------------------------------------------------------------
  Future<List<ItemModel>> fetchItems() async {
    // 1) Kirim permintaan GET ke URL. "await" = tunggu sampai server membalas.
    final response = await http.get(Uri.parse(AppConfig.apiUrl)); // [REF] URL dari app_config.dart

    // 2) Status 200 = sukses. Selain itu kita lempar error agar tampil di UI.
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat data (kode ${response.statusCode})');
    }

    // 3) Ubah teks JSON menjadi objek Dart (Map atau List).
    final decoded = jsonDecode(response.body);

    // 4) Ambil list-nya.
    //    - listKey kosong  : JSON langsung berupa list  [ ... ]
    //    - listKey terisi  : list ada di dalam key tersebut { "products": [ ... ] }
    final dynamic rawList =
        AppConfig.listKey.isEmpty ? decoded : pick(decoded, AppConfig.listKey);

    if (rawList is! List) {
      // Jika bukan list berarti listKey salah -> beri pesan jelas
      throw Exception('listKey "${AppConfig.listKey}" tidak ditemukan / bukan list. Cek app_config.dart');
    }

    // 5) Ubah setiap elemen list menjadi ItemModel.
    //    .map(...) = proses tiap elemen, .toList() = jadikan List lagi.
    return rawList
        .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -------------------------------------------------------------------
  // [FUNGSI] fetchDetail : (OPSIONAL, belum dipakai) ambil 1 item berdasarkan id.
  //   Pakai jika soal mewajibkan detail diambil dari endpoint terpisah,
  //   misal https://dummyjson.com/products/1
  //   Cara pakai: lihat PANDUAN_KUSTOMISASI.md bagian "Detail dari endpoint".
  // -------------------------------------------------------------------
  Future<ItemModel> fetchDetail(String id) async {
    final response = await http.get(Uri.parse('${AppConfig.apiUrl}/$id')); // [HARDCODE] bentuk URL detail
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail (kode ${response.statusCode})');
    }
    return ItemModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    // Catatan: sebagian API membungkus detail, misal { "meals": [ {...} ] }.
    // Kalau begitu, ambil dulu bagian dalamnya sebelum fromJson.
  }
}
