import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_info.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../modules/domain/usecases/app/app_usecase.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/enum/load_state_enum.dart';

class SplashController extends GetxController {
  final AppUseCase appUseCase;

  SplashController({required this.appUseCase});

  final isLoading = false.obs;
  final loadStateEnum = LoadStateEnum.initial.obs;
  TokenStorage get _tokenStorage => Get.find<TokenStorage>();
  final dialogService = Get.find<DialogService>();

  @override
  void onReady() {
    super.onReady();
    if (!isLoading.value) {
      checkVersion();
    }
  }

  @override
  void onClose() {
    isLoading.value = false;
    super.onClose();
  }

  Future<void> _checkAuth() async {
    loadStateEnum.value = LoadStateEnum.initial;
    try {
      await Future.delayed(const Duration(seconds: 2));
      // _checkResetDate();

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
      loadStateEnum.value = LoadStateEnum.error;
    } finally {
      loadStateEnum.value = LoadStateEnum.success;
    }
  }

  Future<void> checkVersion({bool? isRefreshing}) async {
    try {
      if (loadStateEnum.value == LoadStateEnum.refreshing) {
        return;
      }

      if (isRefreshing == true) {
        loadStateEnum.value = LoadStateEnum.refreshing;
      }

      final result = await appUseCase.callVersionApp();

      switch (result) {
        case Success(:final data):
          loadStateEnum.value = LoadStateEnum.success;
          debugPrint('Data API ${data.version}');
          debugPrint('Data Aplikasi ${AppInfo.versionLabel}');
          if (data.version != AppInfo.versionLabel.replaceAll('v', '')) {
            dialogService.showSuccessDefaultDialog(
              title: 'GAGAL!',
              message: 'Versi Aplikasi Tidak Sesuai',
              actions: [],
            );
          } else {
            _checkAuth();
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError(
            'Failed',
            message,
            titleButton1: 'Ulangi',
            onPressed1: () {
              checkVersion(isRefreshing: true);
              Get.back();
            },
          );
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      loadStateEnum.value = LoadStateEnum.error;
      dialogService.showError('Failed', 'Error Get Version\n$e');
    }
  }

  void _removeStorage({bool removeUser = true}) {
    GetStorage().remove('noInvoice');
    if (removeUser) GetStorage().remove('user');
    GetStorage().remove('noInvoice');
    GetStorage().remove('user');
    GetStorage().remove('city');
    GetStorage().remove('colorRit');
    GetStorage().remove('tanggalRit');
    GetStorage().remove('isRitToday');
    GetStorage().remove('isAcceptRIT');
    GetStorage().remove('isTakeToTheRoad');
    GetStorage().remove('status_driver');
    GetStorage().remove('status_checker2');
    GetStorage().remove('buttonRIT');
    GetStorage().remove('buttonEndingDriver');
    GetStorage().remove('resetDate');
    GetStorage().remove('routeRit');
    AppRole.logout();
    _tokenStorage.clear();
  }

  void _checkResetDate() {
    final resetDate = GetStorage().read('resetDate');
    final dateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());

    debugPrint('RESET DATE : $resetDate');
    debugPrint('DATE NOW : $dateTime');

    if (resetDate != dateTime) {
      debugPrint('RESET DATE');
      _removeStorage(removeUser: false);
      GetStorage().write('resetDate', dateTime);
    }
  }
}
