// lib/services/location_service.dart
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Mengambil lokasi TERBARU dengan akurasi RENDAH (Cepat & Hemat Baterai)
  Future<Position> getLatestLocationLightweight() async {
    // 1. Cek GPS & Permission (Sama seperti sebelumnya)
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception("GPS_MATI");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("PERMISSION_DITOLAK");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("PERMISSION_PERMANEN");
    }

    // 2. PAKSA AMBIL LOKASI BARU (Tidak pakai cache)
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          // PILIH SALAH SATU:
          // 'low' = Hanya WiFi/Cell Tower (Paling cepat, akurasi ~100m-1km)
          // 'medium' = WiFi/Cell + GPS (Sedikit lebih lambat, akurasi ~30-100m) -> REKOMENDASI
          // 'reduced' = Mengikuti setting privasi user (Android 12+/iOS 14+)
          accuracy: LocationAccuracy.medium,

          // Karena akurasi rendah, 5 detik sudah lebih dari cukup.
          // Ini mencegah aplikasi hang jika network buruk.
          timeLimit: Duration(seconds: 5),
        ),
      );
      return position;
    } catch (e) {
      // Jika timeLimit tercapai atau error lain
      throw Exception("WAKTU_HABIS_ATAU_ERROR: $e");
    }
  }
}
