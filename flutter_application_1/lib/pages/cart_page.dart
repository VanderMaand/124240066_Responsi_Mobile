// =====================================================================
// FILE   : lib/pages/cart_page.dart
// FUNGSI : Halaman Cart: list item milik USER YANG LOGIN saja, tombol hapus,
//          dan total harga.
// [REF]  data dari services/hive_service.dart (itemsOf & remove)
//        item masuk dari detail_page.dart
// =====================================================================

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // untuk Box & .listenable()
import '../config/app_config.dart';
import '../models/cart_item.dart';
import '../services/hive_service.dart';
import '../widgets/net_image.dart';

// StatelessWidget = tampilan tidak menyimpan state sendiri; pembaruan diurus
// oleh ValueListenableBuilder yang "mendengarkan" perubahan Hive.
class CartPage extends StatelessWidget {
  final String username;
  const CartPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppConfig.cartLabel)),
      // ValueListenableBuilder: tiap ada perubahan isi box (tambah/hapus),
      // bagian builder di bawah dijalankan ulang -> UI otomatis ter-update.
      body: ValueListenableBuilder<Box<CartItem>>(
        valueListenable: HiveService.box.listenable(),
        builder: (context, _, __) {
          // Ambil hanya item milik user ini (inilah pemisah cart antar user).
          final items = HiveService.itemsOf(username);

          if (items.isEmpty) {
            return Center(child: Text('${AppConfig.cartLabel} masih kosong'));
          }

          // Hitung total: mulai dari 0, tambahkan subtotal tiap item.
          final total = items.fold<double>(0, (sum, e) => sum + e.subtotal);

          return Column(
            children: [
              Expanded(
                // Expanded = list mengisi sisa ruang, total tetap di bawah
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: NetImage(url: item.imageUrl),
                        ),
                        title: Text(item.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(AppConfig.showPrice
                            ? 'Qty: ${item.qty}  |  ${AppConfig.currency}${item.subtotal.toStringAsFixed(2)}'
                            : 'Qty: ${item.qty}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => HiveService.remove(item), // hapus dari Hive
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bar total di bawah (hanya jika showPrice = true)
              if (AppConfig.showPrice)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${AppConfig.currency}${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green)),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
