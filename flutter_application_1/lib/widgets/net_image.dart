// =====================================================================
// FILE   : lib/widgets/net_image.dart
// FUNGSI : Widget gambar dari internet yang AMAN: jika URL kosong / gagal
//          dimuat, tampil ikon pengganti (tidak merah-merah error).
// [REF]  dipakai di item_card.dart, detail_page.dart, cart_page.dart
// =====================================================================

import 'package:flutter/material.dart';

class NetImage extends StatelessWidget {
  final String url; // alamat gambar
  final double size; // lebar = tinggi gambar
  const NetImage({super.key, required this.url, this.size = 56});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return Icon(Icons.image_not_supported, size: size); // tidak ada URL
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover, // gambar dipotong agar memenuhi kotak
      errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: size), // jika gagal load
    );
  }
}
