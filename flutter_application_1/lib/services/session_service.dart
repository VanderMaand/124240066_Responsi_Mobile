// =====================================================================
// FILE   : lib/services/session_service.dart
// FUNGSI : Menyimpan "status login" (username) memakai Shared Preferences.
//          Materi Pt 7. Cocok untuk data kecil berbentuk key-value.
// [REF]  dipakai di main.dart (cek login), login_page.dart (simpan),
//        profile_page.dart (hapus saat logout).
// =====================================================================

import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUsername = 'username'; // [HARDCODE] nama "laci" penyimpanan session

  // [FUNGSI] saveUsername : simpan username = tanda user sudah login.
  static Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance(); // buka penyimpanan
    await prefs.setString(_keyUsername, username); // tulis
  }

  // [FUNGSI] getUsername : baca username. Hasil null = belum login.
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  // [FUNGSI] clear : hapus session (dipakai saat LOGOUT).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
  }
}
