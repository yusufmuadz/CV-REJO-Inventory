import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final isLoading = false.obs;
  TokenStorage get _tokenStorage => Get.find<TokenStorage>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (!isLoading.value) {
      _checkAuth();
    }
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = false;
  }

  Future<void> _checkAuth() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));

      final token = await _tokenStorage.getAccessToken();
      if (token != null) {
        // await Get.forceAppUpdate();
        Get.offAllNamed(Routes.HOME);
      } else {
        _removeStorage();
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      _removeStorage();
      Get.offAndToNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  void _removeStorage() {
    GetStorage().remove('noInvoice');
    GetStorage().remove('user');
    GetStorage().remove('city');
    GetStorage().remove('colorRit');
    GetStorage().remove('tanggalRit');
  }
}
