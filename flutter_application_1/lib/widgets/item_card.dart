// =====================================================================
// FILE   : lib/widgets/item_card.dart
// FUNGSI : Satu baris item pada list di Home (gambar, judul, subtitle, harga).
// [REF]  dipakai di pages/home_page.dart
// =====================================================================

import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/item_model.dart';
import 'net_image.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item; // data yang ditampilkan
  final VoidCallback onTap; // fungsi yang dijalankan saat kartu ditekan
  const ItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), // jarak luar kartu
      child: ListTile(
        onTap: onTap, // saat ditekan -> pindah ke Detail (diatur di home_page.dart)
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8), // sudut gambar membulat
          child: NetImage(url: item.imageUrl),
        ),
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis), // judul, dipotong "..." jika panjang
        subtitle: Text(AppConfig.showPrice
            ? '${item.subtitle} | ${AppConfig.currency}${item.price.toStringAsFixed(2)}'
            : item.subtitle), // harga disembunyikan jika showPrice = false
        // toStringAsFixed(2) = tampilkan 2 angka di belakang koma
        trailing: const Icon(Icons.chevron_right), // panah kecil di kanan
      ),
    );
  }
}
