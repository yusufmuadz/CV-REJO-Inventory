import 'package:cv_rejo/core/middlewares/app_role.dart';
import 'package:cv_rejo/features/home/domain/usecases/get_home_usecase.dart';
import 'package:cv_rejo/features/list_order/presentation/controllers/list_order_controller.dart';
import 'package:cv_rejo/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/entities/rit_constraint_entity.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  final GetHomeUseCase homeUseCase;

  HomeController({required this.homeUseCase});

  final isLoading = false.obs;
  final loadState = LoadState.initial.obs;

  late TokenStorage _tokenStorage;
  final dialogService = Get.find<DialogService>();
  final pageController = PageController(initialPage: 0);
  final pageControllerSample = PageController(initialPage: 0);
  final indexPage = 0.obs;

  final orders = <OrderEntity>[].obs;
  final currentPage = 1.obs;

  final rit = ''.obs;
  final colorRit = ''.obs;
  final tanggalRit = ''.obs;
  final isRitToday = false.obs;

  final totalOrder = 0.obs;
  final totalOrderHistory = 0.obs;
  final versionApp = '3.0.0'.obs;
  final updateVersionApp = '08 Juni 2026'.obs;

  final searchController = TextEditingController();
  final tabIndex = 0.obs;

  late final ListOrderController listOrderController;

  final isKeyboardOpen = false.obs;

  final ritConstraints = <RitConstraintEntity>[].obs;
  final listTakeItTransaction = <RitConstraintEntity>[].obs;

  // final List<Widget> pages = [
  //   HomeViewNewSample(),
  //   Container(),
  //   Container(),
  //   Container(),
  // ];

  @override
  void onReady() {
    super.onReady();
    // listOrderController = Get.put(ListOrderController(listOrderUseCase: null));
    _tokenStorage = Get.find<TokenStorage>();

    if (!isLoading.value) {
      _getHomeData();
      _getOrder();
    }
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
    pageControllerSample.dispose();
    isLoading.value = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  void onRefreshTransaction() {
    if (isLoading.value) return;
    _getHomeData();
    _getOrder(isRefresh: true);
  }

  void routeTo({bool ritToday = true}) {
    final invoice = GetStorage().read('noInvoice') ?? '';
    _getLocalRit();

    if (ritToday != isRitToday.value) {
      // GetStorage().remove('noInvoice');
      GetStorage().remove('city');
      GetStorage().remove('colorRit');
      GetStorage().remove('tanggalRit');
      GetStorage().remove('isRitToday');

      rit.value = '';
      colorRit.value = '';
      tanggalRit.value = '';
      isRitToday.value = ritToday;
    }

    GetStorage().remove('noInvoice');

    if (AppRole.isDriver && rit.isNotEmpty) {
      debugPrint('Tanggal RIT HOME : ${tanggalRit}');
      Get.toNamed(
        Routes.RIT_INFORMATION,
        arguments: {
          'invoice': invoice,
          'city': rit.value,
          'colorRit': colorRit.value,
          'tanggalRit': tanggalRit.value,
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
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> _getOrder({bool isRefresh = false}) async {
    _getLocalRit();
    try {
      loadState.value = isRefresh || currentPage.value == 1
          ? LoadState.initial
          : LoadState.loadingMore;

      if (isRefresh) {
        orders.clear();
        currentPage.value = 1;
      }

      final result = await homeUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: '$currentPage',
          q: searchController.text,
          filter: 'ongoing',
          district: rit.value,
          dateRit: tanggalRit.value,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');
          if (data.isEmpty) {
            if (isRefresh && currentPage.value == 1) {
              loadState.value = LoadState.idle;
            } else {
              loadState.value = LoadState.noMore;
            }
            return;
          }
          orders.addAll(data);
          loadState.value = LoadState.idle;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      loadState.value = LoadState.error;
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
    }
  }

  _getLocalRit() {
    rit.value = GetStorage().read('city') ?? '';
    colorRit.value = GetStorage().read('colorRit') ?? '';
    tanggalRit.value = GetStorage().read('tanggalRit') ?? '';
    isRitToday.value = GetStorage().read('isRitToday') ?? false;
  }

  ///// TROUBLE RIT DRIVER

  void addConstraint({
    required String title,
    required String nominal,
    required DateTime date,
    required String status,
    required String description,
    List<XFile>? mediaFileList,
  }) async {
    ritConstraints.add(
      RitConstraintEntity(
        title: title,
        nominal: nominal.replaceAll(',', ''),
        date: date,
        status: status,
        desc: description,
        mediaFileList: mediaFileList ?? [],
      ),
    );
  }

  ///// TAKE IT TRANSACTION

  void addTakeIt({
    required DateTime date,
    required String status,
    required String description,
    List<XFile>? mediaFileList,
  }) async {
    listTakeItTransaction.add(
      RitConstraintEntity(
        date: date,
        status: status,
        desc: description,
        mediaFileList: mediaFileList ?? [],
      ),
    );
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
    GetStorage().remove('city');
    GetStorage().remove('colorRit');
    GetStorage().remove('tanggalRit');
    AppRole.logout();
    _tokenStorage.clear();
    tabIndex.value = 0;
    Get.offAllNamed(Routes.LOGIN);
  }

  ///// PAGE VIEW

  void changePage(int index) {
    // indexPage.value = index;
    // pageController.jumpToPage(index);
    tabIndex.value = index;
    _changeStatusBar(index);
    pageControllerSample.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void changePageSample(int index) {
    // _changeStatusBar(index);
    pageControllerSample.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _changeStatusBar(int index) {
    bool isDark = true;

    if ((AppRole.isDriver && index > 2) || (!AppRole.isDriver && index == 2)) {
      isDark = false;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Untuk Android
        statusBarIconBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarBrightness: isDark
            ? Brightness.light
            : Brightness.dark, // Untuk iOS
      ),
    );
  }
}
