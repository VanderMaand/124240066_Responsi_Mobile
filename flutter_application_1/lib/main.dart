// =====================================================================
// FILE   : lib/main.dart
// FUNGSI : Titik awal aplikasi. Yang pertama kali dijalankan Flutter.
// ALUR   : siapkan Hive -> (siapkan notifikasi) -> cek session ->
//          sudah login ? MainPage : LoginPage
// =====================================================================

import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'services/session_service.dart';

// [FUNGSI] main : fungsi pertama. "async" karena ada proses yang perlu ditunggu.
Future<void> main() async {
  // Wajib dipanggil jika ada "await" sebelum runApp.
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init(); // [REF] services/hive_service.dart

  if (AppConfig.enableNotification) {
    // try-catch = kalau notifikasi gagal disiapkan, aplikasi TETAP jalan.
    try {
      await NotificationService.init(); // [REF] services/notification_service.dart
    } catch (e) {
      debugPrint('Notifikasi gagal init: $e');
    }
  }

  // Baca session. null = belum login.
  final username = await SessionService.getUsername(); // [REF] services/session_service.dart

  runApp(MyApp(username: username)); // jalankan aplikasi
}

// [FUNGSI] MyApp : widget paling atas (root) berisi pengaturan global.
class MyApp extends StatelessWidget {
  final String? username; // tanda "?" = boleh null
  const MyApp({super.key, this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName, // [REF] config/app_config.dart
      debugShowCheckedModeBanner: false, // hilangkan pita "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConfig.themeColor),
        useMaterial3: true,
      ),
      // Inti fitur "tidak perlu login lagi": tentukan halaman awal dari session.
      home: username == null
          ? const LoginPage() // belum login
          : MainPage(username: username!), // sudah login ("!" = pasti tidak null)
    );
  }
}
