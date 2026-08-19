import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/usecases/get_home_usecase.dart';
import 'home_controller.dart';

class HomeTransactionsController extends GetxController {
  final GetHomeUseCase homeUseCase;

  HomeTransactionsController({required this.homeUseCase});

  final loadState = LoadState.initial.obs;

  HomeController get masterController => Get.find<HomeController>();
  final dialogService = Get.find<DialogService>();

  final currentPage = 1.obs;

  final totalOrder = 0.obs;
  final totalOrderHistory = 0.obs;

  final orders = <OrderEntity>[].obs;

  Future<void> getHomeData() async {
    if (masterController.isLoading.value) return;
    masterController.isLoading.value = true;

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
      masterController.isLoading.value = false;
    }
  }

  Future<void> getOrder({bool isRefresh = false}) async {
    // masterController.getLocalRit();

    if (masterController.rit.isEmpty) {
      masterController.isLoading.value = false;
      loadState.value = LoadState.idle;
      return;
    }

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
          page: '${currentPage.value}',
          q: masterController.searchController.text,
          filter: 'ongoing',
          district: masterController.rit.value,
          dateRit: masterController.tanggalRit.value,
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
      masterController.isLoading.value = false;
    }
  }
}
