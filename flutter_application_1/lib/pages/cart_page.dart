import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';
import 'detail_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> _items = []; // isi keranjang

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    setState(() {
      _items = StorageService.getCart();
    });
  }

  Future<void> _delete(Product product) async {
    await StorageService.removeFromCart(product.id);
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    for (final item in _items) {
      total += item.price;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: _items.isEmpty
          // Keranjang kosong
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 72, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Keranjang masih kosong',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('Yuk, cari produk favoritmu di Home'),
                ],
              ),
            )
          // Keranjang ada isi
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final product = _items[index];

                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(productId: product.id),
                              ),
                            );

                            _loadCart();
                          },
                          // Gambar
                          leading: SizedBox(
                            width: 56,
                            height: 56,
                            child: Image.network(product.image,
                                fit: BoxFit.contain),
                          ),
                          // Nama
                          title: Text(product.title,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          // Harga dan rating
                          subtitle: Row(
                            children: [
                              Text('\$${product.price}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 12),
                              const Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                              Text(' ${product.rate}'),
                            ],
                          ),
                          // Tombol hapus
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _delete(product),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Total di bawah
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total (${_items.length} produk)'),
                        Text('\$${total.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
