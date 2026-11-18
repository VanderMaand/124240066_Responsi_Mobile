// =====================================================================
// FILE   : lib/services/notification_service.dart
// FUNGSI : Notifikasi lokal (Materi Pt 8). OPSIONAL - matikan lewat
//          AppConfig.enableNotification = false.
// [REF]  init dipanggil di main.dart; show dipanggil di detail_page.dart.
// =====================================================================

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/app_config.dart';

class NotificationService {
  // Objek utama plugin (satu saja untuk seluruh aplikasi).
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // [FUNGSI] init : siapkan plugin + minta izin notifikasi (Android 13+).
  static Future<void> init() async {
    const androidSetting =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // [HARDCODE] ikon kecil notifikasi (pakai ikon app)
    const settings = InitializationSettings(android: androidSetting);
    await _plugin.initialize(settings);

    // Minta izin tampil notifikasi (muncul dialog "Allow notifications")
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
  }

  // [FUNGSI] show : menampilkan notifikasi sekarang juga.
  static Future<void> show({required String title, required String body}) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        AppConfig.notifChannelId, // id channel
        AppConfig.notifChannelName, // nama channel
        importance: Importance.max, // tingkat penting (muncul heads-up)
        priority: Priority.high,
      ),
    );
    // id notifikasi dibuat dari waktu agar tiap notifikasi berbeda
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _plugin.show(id, title, body, details);
  }
}
