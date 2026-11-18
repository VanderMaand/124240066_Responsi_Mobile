// =====================================================================
// FILE   : lib/models/cart_item.dart
// FUNGSI : Data yang disimpan ke Hive saat user menekan "Add to Cart":
//          produk + USER yang menekan + JUMLAH (qty).
//          Materi Pt 7 (Local Storage - Hive).
// [REF]  dibuat di pages/detail_page.dart, disimpan oleh services/hive_service.dart,
//        ditampilkan di pages/cart_page.dart.
// =====================================================================

import 'package:hive/hive.dart';

class CartItem {
  final String username; // siapa yang menambahkan (supaya cart tiap user berbeda)
  final String itemId; // id produk
  final String title; // nama produk (disimpan agar cart bisa tampil tanpa internet)
  final String imageUrl; // gambar produk
  final double price; // harga satuan
  final int qty; // jumlah yang dibeli

  CartItem({
    required this.username,
    required this.itemId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.qty,
  });

  // [FUNGSI] key : "nama laci" unik di Hive = username + id produk.
  //   Akibatnya: user A & B bisa punya produk sama tanpa bentrok,
  //   dan menambah produk yang sama dua kali hanya MENIMPA (update qty).
  String get key => '$username|$itemId';

  // [FUNGSI] subtotal : harga x jumlah.
  double get subtotal => price * qty;
}

// ---------------------------------------------------------------------
// [FUNGSI] CartItemAdapter : "penerjemah" supaya Hive bisa menyimpan CartItem.
//   Hive hanya paham tipe dasar (String, int, double). Adapter inilah yang
//   mengubah objek <-> byte. Kita tulis MANUAL agar tidak perlu build_runner.
//   !!! URUTAN write() HARUS SAMA PERSIS dengan URUTAN read() !!!
// [REF] didaftarkan di services/hive_service.dart (fungsi init)
// ---------------------------------------------------------------------
class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 0; // [HARDCODE] nomor unik adapter. Jika punya adapter lain, pakai 1, 2, dst.

  @override
  CartItem read(BinaryReader reader) {
    // Membaca data dari penyimpanan, urutan sama dengan write()
    return CartItem(
      username: reader.readString(), // 1
      itemId: reader.readString(), // 2
      title: reader.readString(), // 3
      imageUrl: reader.readString(), // 4
      price: reader.readDouble(), // 5
      qty: reader.readInt(), // 6
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    // Menulis data ke penyimpanan, urutan sama dengan read()
    writer
      ..writeString(obj.username) // 1
      ..writeString(obj.itemId) // 2
      ..writeString(obj.title) // 3
      ..writeString(obj.imageUrl) // 4
      ..writeDouble(obj.price) // 5
      ..writeInt(obj.qty); // 6
  }
}
