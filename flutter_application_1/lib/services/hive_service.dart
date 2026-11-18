// =====================================================================
// FILE   : lib/services/hive_service.dart
// FUNGSI : Semua operasi database Hive untuk Cart (Materi Pt 7).
//          Konsep: Box = "tabel", key = "id baris", value = objek CartItem.
// [REF]  init dipanggil di main.dart; add dipanggil di detail_page.dart;
//        itemsOf/remove dipakai di cart_page.dart; itemsOf juga di profile_page.dart.
// =====================================================================

import 'package:hive_flutter/hive_flutter.dart';
import '../models/cart_item.dart';

class HiveService {
  static const String _boxName = 'cart_box'; // [HARDCODE] nama box (tabel) Hive

  // [FUNGSI] init : siapkan Hive. WAJIB dipanggil sebelum runApp (lihat main.dart).
  static Future<void> init() async {
    await Hive.initFlutter(); // tentukan folder penyimpanan di HP
    Hive.registerAdapter(CartItemAdapter()); // daftarkan penerjemah CartItem
    await Hive.openBox<CartItem>(_boxName); // buka box agar siap dipakai
  }

  // [FUNGSI] box : jalan pintas untuk mengakses box yang sudah dibuka.
  //   Dipakai juga oleh UI lewat ValueListenableBuilder agar tampilan
  //   OTOMATIS berubah saat isi box berubah.
  static Box<CartItem> get box => Hive.box<CartItem>(_boxName);

  // [FUNGSI] addToCart : simpan / timpa item. Key sama (user+produk sama) => qty diperbarui.
  static Future<void> addToCart(CartItem item) => box.put(item.key, item);

  // [FUNGSI] remove : hapus satu item dari cart.
  static Future<void> remove(CartItem item) => box.delete(item.key);

  // [FUNGSI] itemsOf : ambil item milik SATU user saja.
  //   Inilah yang membuat cart user A berbeda dari cart user B.
  static List<CartItem> itemsOf(String username) =>
      box.values.where((e) => e.username == username).toList();
  // .where(...) = saring; hanya yang username-nya sama yang lolos.
}
