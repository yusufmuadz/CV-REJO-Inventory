import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../list_order/domain/entities/district_entity.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/usecases/list_history_order_usecase.dart';

class ListHistoryOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ListHistoryOrderUseCase listHistoryOrderUseCase;

  ListHistoryOrderController({required this.listHistoryOrderUseCase});

  final isLoading = false.obs;
  final isLoadingSort = false.obs;
  final isLoadingLoader = false.obs;
  final dialogService = Get.find<DialogService>();
  late final TabController tabController;

  final isStatusSelected = ''.obs;
  final isDistrictSelected = ''.obs;

  final listDistrict = <DistrictEntity>[].obs;

  final orders = <OrderEntity>[].obs;
  final loaderOrders = <OrderEntity>[].obs;
  int currentPage = 1;
  int currentPageLoader = 1;
  final hasmore = true.obs;
  final hasmoreLoader = true.obs;
  final scrollController = ScrollController();
  final scrollControllerLoader = ScrollController();

  final sortByNew = true.obs;

  final status = [
    {'id': '0', 'name': 'Available', 'isSelected': false},
    {'id': '1', 'name': 'Ongoing', 'isSelected': false},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: AppRole.isChecker2 ? 2 : 1,
      vsync: this,
    );
    scrollController.addListener(_onScroll);
    scrollControllerLoader.addListener(_onScrollLoader);
  }

  @override
  void onReady() {
    super.onReady();
    _getOrder();
    if (AppRole.isChecker2) {
      _getLoaderOrder();
    }
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    isLoading.value = false;
  }

  void onRefreshTransaction() {
    currentPage = 1;
    hasmore.value = true;
    // orders.clear();
    _getOrder();
  }

  void onRefreshLoaderTransaction() {
    currentPageLoader = 1;
    hasmoreLoader.value = true;
    // loaderOrders.clear();
    _getLoaderOrder();
  }

  void onResetSort() {
    currentPage = 1;
    hasmore.value = true;
    orders.clear();
    sortByNew.value = true;
    isStatusSelected.value = '';
    isDistrictSelected.value = '';
    _getOrder();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      // Panggil fungsi untuk memuat lebih banyak data
      if (hasmore.value && !isLoading.value) {
        currentPage++;
        _getOrder();
      }
    }
  }

  void _onScrollLoader() {
    if (scrollControllerLoader.position.pixels >=
        scrollControllerLoader.position.maxScrollExtent - 200) {
      // Panggil fungsi untuk memuat lebih banyak data
      if (hasmoreLoader.value && !isLoadingLoader.value) {
        currentPageLoader++;
        _getLoaderOrder();
      }
    }
  }

  Future<void> _getOrder() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await listHistoryOrderUseCase.call(
        ParamsGetTransaction(limit: '10', page: '$currentPage'),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');
          if (data.isEmpty) {
            hasmore.value = false;
            isLoading.value = false;
            if (orders.isNotEmpty) {
              dialogService.showInfoSnackbar(
                'Info',
                'Tidak ada data pesanan lagi',
              );
            }
            return;
          }
          orders.addAll(data);

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getLoaderOrder() async {
    if (isLoadingLoader.value) return;
    isLoadingLoader.value = true;

    try {
      final result = await listHistoryOrderUseCase.call(
        ParamsGetTransaction(limit: '10', page: '$currentPageLoader'),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Loader Order: ${data.length}');
          if (data.isEmpty) {
            hasmoreLoader.value = false;
            isLoadingLoader.value = false;
            if (loaderOrders.isNotEmpty) {
              dialogService.showInfoSnackbar(
                'Info',
                'Tidak ada data pesanan lagi',
              );
            }
            return;
          }
          loaderOrders.addAll(data);

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data: $e');
    } finally {
      isLoadingLoader.value = false;
    }
  }

  Future<void> getDistrict() async {
    if (isLoadingSort.value) return;
    isLoadingSort.value = true;

    final result = await listHistoryOrderUseCase.callGetDistrict();

    try {
      switch (result) {
        case Success(:final data):
          listDistrict.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoadingSort.value = false;
    }
  }
}
