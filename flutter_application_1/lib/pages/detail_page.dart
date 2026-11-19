import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'cart_page.dart';

class DetailPage extends StatefulWidget {
  final int productId; // yang dikirim hanya id, datanya diambil dari API detail

  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Product> _futureProduct;

  @override
  void initState() {
    super.initState();
    // widget.productId = mengambil nilai dari class DetailPage di atas
    _futureProduct = ApiService.getProductDetail(widget.productId);
  }

  Future<void> _addToCart(Product product) async {
    await StorageService.addToCart(product);
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk ditambahkan ke keranjang')),
    );
  }

  Future<void> _removeFromCart(Product product) async {
    await StorageService.removeFromCart(product.id);
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Produk dihapus dari keranjang')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () async {
              // await = tunggu sampai user kembali dari Cart,
              // lalu setState agar status tombol keranjang diperbarui.
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<Product>(
        future: _futureProduct,
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat detail produk.'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        _futureProduct =
                            ApiService.getProductDetail(widget.productId);
                      });
                    },
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          final product = snapshot.data!;
          final inCart = StorageService.isInCart(product.id);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero image: paling atas dan besar
                      Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.white,
                        padding: const EdgeInsets.all(24),
                        child:
                            Image.network(product.image, fit: BoxFit.contain),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Harga
                            Text('\$${product.price}',
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                            const SizedBox(height: 8),
                            // Nama produk
                            Text(product.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            // Rating dan jumlah review
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 18, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                    '${product.rate}  (${product.count} ulasan)'),
                              ],
                            ),
                            const Divider(height: 32),
                            // Deskripsi
                            const Text('Deskripsi',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text(product.description),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: inCart
                        ? OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            onPressed: () => _removeFromCart(product),
                            icon: const Icon(Icons.remove_shopping_cart),
                            label: const Text('Hapus dari Keranjang'),
                          )
                        : FilledButton.icon(
                            onPressed: () => _addToCart(product),
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Tambah ke Keranjang'),
                          ),
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
