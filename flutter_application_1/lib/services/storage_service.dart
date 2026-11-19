import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

const String emailKey = 'email'; // nama "laci" untuk email
const String cartBoxName = 'cart'; // nama box Hive untuk keranjang

class StorageService {
  // ---------- Hive ----------

  // Dipanggil sekali di main().
  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(cartBoxName);
  }

  static Box get _cart => Hive.box(cartBoxName);

  // ---------- Login (SharedPreferences) ----------

  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(emailKey, email);
  }

  // Hasil null artinya belum login.
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(emailKey);
  }

  // Ambil semua produk di keranjang.
  static List<Product> getCart() {
    return _cart.values.map((item) => Product.fromMap(item)).toList();
  }

  // id ini sudah ada di keranjang?
  static bool isInCart(int id) => _cart.containsKey(id);

  // Jumlah produk di keranjang.
  static int cartCount() => _cart.length;

  // Tambah produk ke keranjang.
  static Future<void> addToCart(Product product) async {
    await _cart.put(product.id, product.toMap());
  }

  // Hapus produk dari keranjang.
  static Future<void> removeFromCart(int id) async {
    await _cart.delete(id);
  }
}
