import 'dart:convert';

import 'package:cv_rejo/features/list_order/domain/entities/list_order_entity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../login/data/models/user_model.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/usecases/list_order_usecase.dart';

class ListOrderController extends GetxController {
  final ListOrderUseCase listOrderUseCase;

  ListOrderController({required this.listOrderUseCase});

  final isLoading = false.obs;
  final dialogService = Get.find<DialogService>();

  final orders = <OrderEntity>[].obs;
  int currentPage = 1;
  final hasmore = true.obs;
  final scrollController = ScrollController();
  final searchController = TextEditingController();

  final isSelection = false.obs;
  final isSelected = ''.obs;
  final isStatusSelected = ''.obs;
  final listSelected = <dynamic>[].obs;

  final userModel = UserModel(
    userId: '',
    nama: '',
    username: '',
    jabatan: '',
    notelp: '',
    alamat: '',
  ).obs;

  final sortByNew = true.obs;

  final status = [
    {'id': '0', 'name': 'Available', 'isSelected': false},
    {'id': '1', 'name': 'Ongoing', 'isSelected': false},
  ].obs;

  final armada = [
    {'id': '0', 'name': 'SICEPAT', 'isSelected': false},
    {'id': '1', 'name': 'JNE', 'isSelected': false},
    {'id': '2', 'name': 'POS INDONESIA', 'isSelected': false},
    {'id': '3', 'name': 'TIKI', 'isSelected': false},
    {'id': '4', 'name': 'Wahana', 'isSelected': false},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    _getUser();
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
    orders.clear();
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

  void onSelected(String id) {
    final index = orders.indexWhere((order) => order.invoice == id);
    if (index != -1) {
      isSelected.value = id;
      // final order = orders[index];
      // final updatedOrder = order.copyWith(isSelected: !order.isSelected);
      // orders[index] = updatedOrder;
    }
  }

  void _getUser() {
    final userStorage = GetStorage().read('user');

    if (userStorage != null) {
      final parsing = jsonDecode(userStorage);
      userModel.value = UserModel.fromJson(parsing);
      // debugPrint('User Parsing: ${user.jabatan}');
    }
  }

  void cancelSelection() {
    isSelected.value = '';
  }

  void takeItOrder() async {
    // final invoice =
    //     orders.firstWhereOrNull((order) => order.isSelected)?.invoice ?? '';
    // debugPrint('Invoice: $invoice');
    if (isLoading.value) return;

    if (isSelected.value.isEmpty) {
      dialogService.showError('Error', 'Pilih pesanan terlebih dahulu');
      return;
    }

    isLoading.value = true;

    final result = await listOrderUseCase.callTakeItTransaction(
      isSelected.value,
    );

    try {
      switch (result) {
        case Success(:final data):
          if (data.status) {
            GetStorage().write('noInvoice', isSelected.value);
            Get.offNamed(
              Routes.DETAIL_ORDER,
              arguments: {
                'invoice': isSelected.value,
                'routeFrom': 'listOrder',
              },
            );
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
          }
        // debugPrint('Data Take It Order: ${data.length}');
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

  Future<void> _getOrder() async {
    if (isLoading.value) return;
    isLoading.value = true;

    final result = await listOrderUseCase.call(
      ParamsGetTransaction(
        limit: '10',
        page: '$currentPage',
        q: searchController.text,
        filter: isStatusSelected.value.toLowerCase(),
      ),
    );

    try {
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
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
    }
  }
}
