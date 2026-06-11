import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/district_entity.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/usecases/list_history_order_usecase.dart';

class ListHistoryOrderController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ListHistoryOrderUseCase listHistoryOrderUseCase;

  ListHistoryOrderController({required this.listHistoryOrderUseCase});

  final isLoadingSort = false.obs;
  final dialogService = Get.find<DialogService>();
  late final TabController tabController;

  final isDistrictSelected = ''.obs;

  final listDistrict = <DistrictEntity>[].obs;

  final orders = <OrderEntity>[].obs;
  final currentPage = 1.obs;
  final hasmore = true.obs;
  final scrollController = ScrollController();

  final searchController = TextEditingController();

  final loadState = LoadState.initial.obs;

  final sortByNew = true.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: AppRole.isChecker2 ? 2 : 1,
      vsync: this,
    );
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    _getOrder();
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
    isLoadingSort.value = false;
    tabController.dispose();
    loadState.value = LoadState.idle;
  }

  Future<void> onRefreshTransaction() async {
    currentPage.value = 1;
    // hasmore.value = true;
    orders.clear();
    await _getOrder(isRefresh: true);
  }

  void retryFetch() => _getOrder(isRefresh: loadState.value == LoadState.error);

  void onResetSort() {
    currentPage.value = 1;
    orders.clear();
    sortByNew.value = true;
    isDistrictSelected.value = '';
    _getOrder(isRefresh: true);
  }

  void _onScroll() {
    final canLoad = loadState.value == LoadState.idle;

    if (canLoad &&
        scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
      currentPage.value++;
      _getOrder();
    }
  }

  Future<void> _getOrder({bool isRefresh = false}) async {
    try {
      loadState.value = (isRefresh || currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      if (isRefresh) {
        orders.clear();
        currentPage.value = 1;
      }

      final result = await listHistoryOrderUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: '$currentPage',
          q: searchController.text,
          sort: sortByNew.value ? 'newest' : 'oldest',
          district: isDistrictSelected.value.toLowerCase(),
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
      dialogService.showError('Failed', '$e');
    } finally {
      // loadState.value = LoadState.idle;
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

  void reorderOrders(int oldIndex, int newIndex) {
    // 1. Sesuaikan index (quirk bawaan Flutter)
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 2. Pindahkan item di dalam list
    final item = orders.removeAt(oldIndex);
    orders.insert(newIndex, item);

    // 3. (Opsional) Jika Anda menggunakan GetBuilder, Anda bisa memanggil update()
    // TAPI baca "Catatan Penting" di bawah agar animasi tidak rusak!
    // update(['orders']); 

    // 4. (Opsional) Panggil API untuk menyimpan urutan baru ke server
    // _saveNewOrderToServer();
  }
}
