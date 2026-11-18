// =====================================================================
// FILE   : lib/pages/detail_page.dart
// FUNGSI : Halaman Detail: semua info item, pengatur qty (0 < qty <= stok),
//          dan tombol Add to Cart yang menyimpan ke Hive.
// [REF]  data masuk dari home_page.dart | simpan lewat services/hive_service.dart
//        notifikasi lewat services/notification_service.dart
// =====================================================================

import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/cart_item.dart';
import '../models/item_model.dart';
import '../services/hive_service.dart';
import '../services/notification_service.dart';
import '../widgets/net_image.dart';

class DetailPage extends StatefulWidget {
  final ItemModel item; // item yang dipilih di Home
  final String username; // user yang sedang login (untuk disimpan bersama cart)
  const DetailPage({super.key, required this.item, required this.username});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = AppConfig.minQty; // qty awal = qty minimal

  // [FUNGSI] _addToCart : dijalankan saat tombol Add to Cart ditekan.
  Future<void> _addToCart() async {
    final item = widget.item; // "widget." = mengakses data milik StatefulWidget di atas

    // 1) Simpan ke Hive: produk + user + qty.
    await HiveService.addToCart(CartItem(
      username: widget.username,
      itemId: item.id,
      title: item.title,
      imageUrl: item.imageUrl,
      price: item.price,
      qty: _qty,
    ));

    // 2) (Opsional) tampilkan notifikasi. try-catch agar tidak crash jika gagal.
    if (AppConfig.enableNotification) {
      try {
        await NotificationService.show(
          title: '${AppConfig.itemLabel} ditambahkan', // [HARDCODE] judul notifikasi
          body: '${item.title} x$_qty masuk ${AppConfig.cartLabel}', // [HARDCODE] isi notifikasi
        );
      } catch (e) {
        debugPrint('Notifikasi gagal: $e');
      }
    }

    // 3) Beri tahu user lewat SnackBar (pesan kecil di bawah layar).
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} x$_qty ditambahkan')), // [HARDCODE] pesan sukses
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final maxQty = item.stock; // batas atas qty = stok
    final canAdd = maxQty >= AppConfig.minQty; // jika stok 0, tombol dimatikan

    return Scaffold(
      appBar: AppBar(title: Text('Detail ${AppConfig.itemLabel}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
          children: [
            Center(child: NetImage(url: item.imageUrl, size: 220)),
            const SizedBox(height: 16),
            Text(item.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(item.subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            if (AppConfig.showPrice) // "if" di dalam list: tampil hanya jika showPrice = true
              Text('${AppConfig.currency}${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text(' ${item.rating}  |  Stok: ${item.stock}'),
              ],
            ),
            const Divider(height: 28), // garis pemisah
            // Info tambahan dari AppConfig.extraFields. "..." = sebarkan isi list ke sini.
            ...item.extras.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${e.key}: ${e.value}'),
                )),
            const SizedBox(height: 12),
            const Text('Deskripsi',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(item.description),
            const SizedBox(height: 24),
          ],
        ),
      ),
      // Baris bawah: pengatur qty + tombol Add to Cart
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Tombol kurang: aktif hanya jika qty > minQty
              IconButton(
                onPressed: _qty > AppConfig.minQty
                    ? () => setState(() => _qty--)
                    : null, // null = tombol nonaktif (abu-abu)
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_qty',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              // Tombol tambah: aktif hanya jika qty < stok
              IconButton(
                onPressed:
                    _qty < maxQty ? () => setState(() => _qty++) : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
              const Spacer(), // dorong tombol ke kanan
              FilledButton.icon(
                onPressed: canAdd ? _addToCart : null,
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(AppConfig.addButtonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
