import 'package:cv_rejo/core/middlewares/app_role.dart';
import 'package:cv_rejo/features/home/domain/usecases/get_home_usecase.dart';
import 'package:cv_rejo/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../core/services/storage_service.dart';

class HomeController extends GetxController {
  final GetHomeUseCase homeUseCase;

  HomeController({required this.homeUseCase});

  final isLoading = false.obs;

  late TokenStorage _tokenStorage;
  final dialogService = Get.find<DialogService>();
  final pageController = PageController(initialPage: 0);
  final indexPage = 0.obs;

  final totalOrder = 0.obs;
  final totalOrderHistory = 0.obs;
  final versionApp = '1.0.0'.obs;

  @override
  void onReady() {
    super.onReady();
    _tokenStorage = Get.find<TokenStorage>();
    if (!isLoading.value) {
      _getHomeData();
      // _getTransaction();
    }
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    isLoading.value = false;
  }

  void onRefreshTransaction() {
    if (isLoading.value) return;
    _getHomeData();
    // _getTransaction();
  }

  void routeTo() {
    final invoice = GetStorage().read('noInvoice') ?? '';

    /// ==== AWAL SEMENTARA ==== ///

    if (AppRole.isDriver) {
      Get.toNamed(
        Routes.DETAIL_ORDER,
        arguments: {'invoice': '01SL20260400016', 'routeFrom': 'home'},
      );
      return;
    }

    /// ==== AKHIR SEMENTARA ==== ///

    if (invoice.isNotEmpty) {
      Get.toNamed(
        Routes.DETAIL_ORDER,
        arguments: {'invoice': invoice, 'routeFrom': 'home'},
      );
    } else {
      GetStorage().remove('noInvoice');
      Get.toNamed(Routes.LIST_ORDER);
    }
  }

  ///// HOME

  Future<void> _getHomeData() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await homeUseCase.callHomeData();

      switch (result) {
        case Success(:final data):
          totalOrder.value = data.totalRowTransaction;
          totalOrderHistory.value = data.totalRowTransactionHistory;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
    }
  }

  ///// PROFILE

  Future<void> versionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    versionApp.value = packageInfo.version;
  }

  void onTapHubungiAdmin() async {
    await canLaunchUrl(Uri.parse(ApiEndpoints.hubungiAdmin))
        ? launchUrl(
            Uri.parse(ApiEndpoints.hubungiAdmin),
            mode: LaunchMode.externalApplication,
          )
        : debugPrint("Can't open WhatsApp");
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
    AppRole.logout();
    _tokenStorage.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  ///// PAGE VIEW

  void changePage(int index) {
    indexPage.value = index;
    _changeStatusBar(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _changeStatusBar(int index) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Untuk Android
        statusBarIconBrightness: index == 0
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: index == 0
            ? Brightness.light
            : Brightness.dark, // Untuk iOS
      ),
    );
  }
}
