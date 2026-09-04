import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/district_entity.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../../../list_order/domain/params/get_rit_param.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../../list_order/domain/usecases/list_order_usecase.dart';
import '../../../list_order_history/domain/usecases/list_history_order_usecase.dart';
import '../../domain/usecases/get_home_usecase.dart';

class HomeTrackingDriverController extends GetxController {
  final GetHomeUseCase homeUseCase;
  final ListOrderUseCase listOrderUseCase;

  HomeTrackingDriverController({
    required this.homeUseCase,
    required this.listOrderUseCase,
  });

  final isLoading = false.obs;
  final isLoadingSort = false.obs;
  final loadState = LoadState.initial.obs;
  final dialogService = Get.find<DialogService>();

  final currentPage = 1.obs;
  final listRit = <RitListEntity>[].obs;
  final listOrder = <OrderEntity>[].obs;

  final sortByNew = false.obs;
  final ritTracking = ''.obs;
  final dateTracking = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  final listRIT = <DistrictEntity>[].obs;
  final searchTrackingController = TextEditingController();

  late final scrollerController = ScrollController();

  final listHistoryOrderUseCase = Get.find<ListHistoryOrderUseCase>();

  @override
  void onInit() {
    super.onInit();
    _getRit(isRefresh: true);

    scrollerController.addListener(onWidgetScroll);
  }

  @override
  void onClose() {
    super.onClose();
    scrollerController.dispose();
  }

  void onRefreshTransaction() {
    // _getRit(isRefresh: true);
    _getOrder(isRefresh: true);
  }

  void onResetSort() {
    currentPage.value = 1;
    listOrder.clear();
    sortByNew.value = true;
    ritTracking.value = '';
    dateTracking.value = DateFormat('yyyy-MM-dd').format(DateTime.now());
    onRefreshTransaction();
  }

  void retryFetch() => _getRit(isRefresh: loadState.value == LoadState.error);

  Future<void> getDistrict() async {
    if (isLoadingSort.value) return;
    isLoadingSort.value = true;

    final result = await listHistoryOrderUseCase.callGetDistrict();

    try {
      switch (result) {
        case Success(:final data):
          listRIT.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoadingSort.value = false;
    }
  }

  Future<void> _getRit({
    bool isRefresh = false,
    bool? isPashRit,
    String? dateRIT,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    String sendDate = DateTime.now().toString();

    // if (sendDate.isEmpty) {
    //   sendDate = tanggalRit.value;
    // }

    debugPrint('DATE RIT : $sendDate');

    final result = await listOrderUseCase.callGetRit(
      ParamGetRIT(isPastRit: false, date: sendDate),
    );

    try {
      switch (result) {
        case Success(:final data):
          listRit.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
      // loadState.value = LoadState.idle;
    }
  }

  Future<void> _getOrder({bool isRefresh = false}) async {
    // masterController.getLocalRit();

    // if (masterController.rit.isEmpty) {
    //   masterController.isLoading.value = false;
    //   loadState.value = LoadState.idle;
    //   return;
    // }

    if (isLoading.value) return;
    isLoading.value = true;

    try {
      loadState.value = isRefresh || currentPage.value == 1
          ? LoadState.initial
          : LoadState.loadingMore;

      if (isRefresh) {
        listOrder.clear();
        currentPage.value = 1;
      }

      final result = await homeUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: '${currentPage.value}',
          q: searchTrackingController.text,
          filter: '',
          district: '10', // ritTracking.value
          dateRit: '2026-09-02', // dateTracking.value
          isTracking: true,
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
          listOrder.addAll(data);
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

  void onWidgetScroll() {
    if (!scrollerController.hasClients) return;

    final currentPixels = scrollerController.position.pixels;
    final maxScroll = scrollerController.position.maxScrollExtent;

    // DEBUG: Pantau angka ini di console saat Anda melakukan scroll
    // debugPrint('Pixels: $currentPixels / Max: $maxScroll');

    final canLoad = loadState.value == LoadState.idle;

    // Jika canLoad bernilai false, pagination tidak akan berjalan.
    // Pastikan setelah _getOrder() selesai, loadState.value dikembalikan ke LoadState.idle
    if (canLoad && currentPixels >= maxScroll - 200) {
      debugPrint('=== MEMANGGIL HALAMAN BERIKUTNYA ===');
      currentPage.value++;
      // _getRit();
      _getOrder();
    }
  }
}
