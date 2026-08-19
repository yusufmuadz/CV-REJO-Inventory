// lib/core/utils/maps_utils.dart

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../core/network/api_endpoints.dart';
import '../core/services/dialog_service.dart';

class MapsUtils {
  MapsUtils._();

  static Future<void> openMaps({
    String? latitude,
    String? longitude,
    String? address,
    String? dropAddress,
    required DialogService dialogService,
  }) async {
    final lat = latitude ?? '-';
    final lng = longitude ?? '-';
    final addr = address ?? '';
    final dropAddr = dropAddress ?? '';

    debugPrint('Latitude: $lat, Longitude: $lng');
    debugPrint('Address: $addr');
    debugPrint('Drop Alamat: $dropAddress');

    if ((lat == '-' || lng == '-') && (dropAddr.isEmpty || dropAddr == '-')) {
      dialogService.showErrorSnackbar(
        title: 'Gagal!',
        'Koordinat/Alamat Kosong',
      );
      return;
    }

    String url;

    if (lat == '-' || lng == '-') {
      final encodedQuery = Uri.encodeComponent(dropAddr);
      url = ApiEndpoints.maps(encodedQuery);
    } else {
      url = ApiEndpoints.maps('$lat, $lng');
    }

    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      dialogService.showErrorSnackbar(
        title: 'Gagal!',
        'Tidak dapat membuka Maps',
      );
      debugPrint("Can't open Maps");
    }
  }
}
