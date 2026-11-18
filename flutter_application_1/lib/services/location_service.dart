// =====================================================================
// FILE   : lib/services/location_service.dart
// FUNGSI : Mengambil lokasi (LBS, Materi Pt 8). OPSIONAL - matikan lewat
//          AppConfig.enableLocation = false.
// [REF]  dipanggil di pages/profile_page.dart
// =====================================================================

import 'package:geolocator/geolocator.dart';

class LocationService {
  // [FUNGSI] getCurrentPosition : minta izin lalu ambil koordinat sekarang.
  //   Mengembalikan Position (latitude, longitude) atau null jika gagal.
  static Future<Position?> getCurrentPosition() async {
    // 1) Apakah GPS/Location di HP menyala?
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return null;

    // 2) Cek izin aplikasi; kalau belum diberikan, minta ke user.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 3) Jika tetap ditolak -> berhenti.
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    // 4) Ambil posisi.
    return Geolocator.getCurrentPosition();
  }
}
