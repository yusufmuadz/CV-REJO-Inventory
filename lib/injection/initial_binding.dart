import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../core/middlewares/session_manager.dart';
// import '../core/network/connectivity_network.dart';
import '../core/network/dio_client.dart';
import '../core/network/koneksi_check.dart';
import '../core/services/camera_service.dart';
import '../core/services/contact_service.dart';
import '../core/services/dialog_service.dart';
import '../core/services/storage_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<KoneksiCheck>(KoneksiCheck(), permanent: true);
    Get.lazyPut<FlutterSecureStorage>(() {
      debugPrint('✅ FlutterSecureStorage created');
      return FlutterSecureStorage();
    }, fenix: true);
    Get.lazyPut<TokenStorage>(() {
      debugPrint('✅ TokenStorage created');
      return TokenStorage(Get.find<FlutterSecureStorage>());
    }, fenix: true);

    // Jika pakai DIO
    Get.lazyPut<DioClient>(
      () => DioClient(Get.find<TokenStorage>()),
      fenix: true,
    );

    // // Register NavigationService (permanent agar navigatorKey tetap hidup)
    // Get.lazyPut<NavigationService>(
    //   () => NavigationService(),
    //   fenix: true, // ✅ Agar tidak terhapus saat rebuild
    // );

    // Register DialogService
    Get.lazyPut<DialogService>(() => DialogService(), fenix: true);
    Get.lazyPut<ContactService>(() => ContactService(), fenix: true);
    Get.lazyPut<SessionManager>(() => SessionManager(), fenix: true);

    Get.lazyPut<CameraControllerService>(
      () => CameraControllerService(),
      fenix: true,
    );
  }
}
