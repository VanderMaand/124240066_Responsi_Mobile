import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/storage_service.dart';

// Fungsi pertama yang dijalankan Flutter.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.initHive();

  final email = await StorageService.getEmail();

  runApp(MyApp(email: email));
}

class MyApp extends StatelessWidget {
  final String? email;

  const MyApp({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green, // warna utama aplikasi
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      // Sudah login -> langsung ke halaman utama. Belum -> halaman login.
      home: email == null ? const LoginPage() : MainPage(email: email!),
    );
  }
}
