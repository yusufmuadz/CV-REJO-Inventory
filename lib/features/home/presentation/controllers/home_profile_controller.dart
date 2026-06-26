import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_pages.dart';
import 'home_controller.dart';

class HomeProfileController extends GetxController {
  
  HomeController get masterController => Get.find<HomeController>();
  final TokenStorage _tokenStorage = Get.find<TokenStorage>();

  final versionApp = '4.0.0'.obs;
  final updateVersionApp = '26 Jun 2026'.obs;

  Future<void> versionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionApp.value = packageInfo.version;
  }

  void onTapPrivacyPolicy() async {
    await canLaunchUrlString(ApiEndpoints.privacyPolicy)
        ? launchUrlString(ApiEndpoints.privacyPolicy)
        : debugPrint("Can't open Privacy Policy");
  }

  void onTapTermsAndCondition() async {
    await canLaunchUrlString(ApiEndpoints.termsAndCondition)
        ? launchUrlString(ApiEndpoints.termsAndCondition)
        : debugPrint("Can't open Terms and Conditions");
  }

  void onTapLogout() {
    GetStorage().remove('noInvoice');
    GetStorage().remove('user');
    GetStorage().remove('city');
    GetStorage().remove('colorRit');
    GetStorage().remove('tanggalRit');
    GetStorage().remove('isRitToday');
    GetStorage().remove('isAcceptRIT');
    AppRole.logout();
    _tokenStorage.clear();
    masterController.tabIndex.value = 0;
    Get.offAllNamed(Routes.LOGIN);
  }
}
