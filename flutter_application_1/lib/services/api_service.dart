// Semua kode untuk mengambil data dari API ada di file ini.
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

const String baseUrl = 'https://fakestoreapi.com/products';

class ApiService {
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  static Future<Product> getProductDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal memuat detail produk');
    }
  }
}
