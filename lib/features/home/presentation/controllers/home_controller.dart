import 'package:cv_rejo/core/middlewares/app_role.dart';
import 'package:cv_rejo/features/home/domain/usecases/get_home_usecase.dart';
import 'package:cv_rejo/features/list_order/presentation/controllers/list_order_controller.dart';
import 'package:cv_rejo/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/services/cache_service.dart';
import '../../../../core/services/dialog_service.dart';
import 'home_page_controller.dart';
import 'home_profile_controller.dart';
import 'home_rit_controller.dart';
import 'home_transactions_controller.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final GetHomeUseCase homeUseCase;

  HomeController({required this.homeUseCase});

  final isLoading = false.obs;

  final dialogService = Get.find<DialogService>();
  final cacheService = Get.find<CacheService>();
  final pageController = PageController(initialPage: 0);
  final indexPage = 0.obs;

  final searchController = TextEditingController();

  final rit = ''.obs;
  final colorRit = ''.obs;
  final tanggalRit = ''.obs;
  final isRitToday = false.obs;

  final tabIndex = 0.obs;

  final cacheSize = '0 B'.obs;

  late final ListOrderController listOrderController;

  final isKeyboardOpen = false.obs;

  late final HomeTransactionsController homeTransactionsController;
  late final HomeRITController homeRITController;
  late final HomePageController homePageController;
  late final HomeProfileController homeProfileController;

  @override
  void onInit() {
    super.onInit();
    homeTransactionsController = Get.find<HomeTransactionsController>();
    homeRITController = Get.find<HomeRITController>();
    homePageController = Get.find<HomePageController>();
    homeProfileController = Get.find<HomeProfileController>();
  }

  @override
  void onReady() {
    super.onReady();
    if (!isLoading.value) _initializeAllData();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding
        .instance
        .platformDispatcher
        .views
        .first
        .viewInsets
        .bottom;

    isKeyboardOpen.value = bottomInset > 0;
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    isLoading.value = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  void onRefreshTransaction() {
    if (isLoading.value) return;
    _initializeAllData();
  }

  void _initializeAllData() {
    homeTransactionsController.getHomeData();
    // homeTransactionsController.getOrder(isRefresh: true);
  }

  getLocalRit() {
    rit.value = GetStorage().read('city') ?? '';
    colorRit.value = GetStorage().read('colorRit') ?? '';
    tanggalRit.value = GetStorage().read('tanggalRit') ?? '';
    isRitToday.value = GetStorage().read('isRitToday') ?? false;
  }

  void getCacheSize(int index) async {
    if ((AppRole.isDriver && index < 2) || (!AppRole.isDriver && index != 1)) {
      return;
    }
    // Di dalam State management (misal: GetX atau Provider)
    int currentSize = await cacheService.getCacheSize();
    cacheSize.value = cacheService.formatSize(currentSize);
  }

  void clearCache() async {
    await cacheService.clearAllCache();
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Beri jeda 0.5 detik
    getCacheSize(tabIndex.value);
    Get.back();
    dialogService.showSuccessSnackbar('Berhasil Menghapus Cache');
  }

  void routeTo({bool ritToday = true}) {
    final invoice = GetStorage().read('noInvoice') ?? '';
    getLocalRit();

    if (AppRole.isDriver && rit.value.isNotEmpty && invoice.isNotEmpty) {
      final statusDriver = GetStorage().read('status_driver') ?? '';

      Get.toNamed(
        Routes.DETAIL_ORDER,
        arguments: {
          'invoice': invoice,
          'routeFrom': 'home',
          'status_driver': statusDriver,
        },
      );
      return;
    }

    if ((ritToday != isRitToday.value) || rit.value.isEmpty) {
      // GetStorage().remove('noInvoice');
      GetStorage().remove('city');
      GetStorage().remove('colorRit');
      GetStorage().remove('tanggalRit');
      GetStorage().remove('isAcceptRIT');

      GetStorage().write('isRitToday', ritToday);

      rit.value = '';
      colorRit.value = '';
      tanggalRit.value = '';
      isRitToday.value = ritToday;

      debugPrint('CHANGE IS RIT TODAY : ${isRitToday.value}');
    }

    GetStorage().remove('noInvoice');

    if (AppRole.isDriver && rit.value.isNotEmpty) {
      if (invoice.isNotEmpty) {}

      Get.toNamed(
        Routes.RIT_INFORMATION,
        arguments: {
          'invoice': invoice,
          'city': rit.value,
          'colorRit': colorRit.value,
          'tanggalRit': tanggalRit.value,
          'routeFrom': 'home',
          'isRitToday': ritToday,
        },
      );
    } else {
      ///// ========== KE HALAMAN LIST RIT/PESANAN =========== /////
      ///// ================== JIKA ADA RIT =================== /////

      Get.toNamed(
        Routes.LIST_ORDER,
        arguments: {
          'routeFrom': 'home',
          'city': rit.value,
          'colorRit': colorRit.value,
          'tanggalRit': tanggalRit.value,
          'isRitToday': ritToday,
        },
      );
    }
  }
}
