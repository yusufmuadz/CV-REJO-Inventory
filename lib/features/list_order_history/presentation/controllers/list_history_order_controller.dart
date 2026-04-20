import 'dart:convert';

import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../../login/data/models/user_model.dart';
import '../../domain/usecases/list_history_order_usecase.dart';

class ListHistoryOrderController extends GetxController {
  final ListHistoryOrderUseCase listHistoryOrderUseCase;

  ListHistoryOrderController({required this.listHistoryOrderUseCase});

  final isLoading = false.obs;
  final dialogService = Get.find<DialogService>();

  final orders = <OrderEntity>[].obs;
  int currentPage = 1;
  final hasmore = true.obs;
  final scrollController = ScrollController();

  final sortByNew = true.obs;

  final status = [
    {'id': '0', 'name': 'Semua', 'isSelected': true},
    {'id': '1', 'name': 'Belum Diproses', 'isSelected': false},
    {'id': '2', 'name': 'Sedang Diproses', 'isSelected': false},
    {'id': '3', 'name': 'Selesai', 'isSelected': false},
  ].obs;

  @override
  void onInit() {
    super.onInit();
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
    isLoading.value = false;
  }

  void onRefreshTransaction() {
    currentPage = 1;
    hasmore.value = true;
    // orders.clear();
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

  Future<void> _getOrder() async {
    if (isLoading.value) return;
    isLoading.value = true;

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

    if (result == null) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    }

    isLoading.value = false;
  }
}
