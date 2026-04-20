import 'dart:convert';

import 'package:cv_rejo/features/detail_order/domain/entities/transportation_entity.dart';
import 'package:cv_rejo/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../list_order/data/models/courier_model.dart';
import '../../../list_order/data/models/date_model.dart';
import '../../../login/data/models/user_model.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../data/models/customer_model.dart';
import '../../domain/entities/detail_order_entity.dart';
import '../../domain/params/add_assistant_param.dart';
import '../../domain/usecases/detail_order_usecase.dart';

class DetailOrderController extends GetxController {
  final DetailOrderUseCase detailOrderUseCase;

  DetailOrderController({required this.detailOrderUseCase});

  final isLoading = false.obs;
  final isLoadingAssistant = false.obs;
  final dialogService = Get.find<DialogService>();
  final noInvoice = ''.obs;
  final routeFrom = ''.obs;

  final isSelect = false.obs;

  final driverSelected = ''.obs;
  final assistantSelected = ''.obs;
  final selectTransportation = ''.obs;

  final listUser = <UserEntity>[].obs;
  final transportations = <TransportationEntity>[].obs;

  final userModel = UserModel(
    userId: '',
    nama: '',
    username: '',
    jabatan: '',
    notelp: '',
    alamat: '',
  ).obs;

  final orderDetail = DetailOrderEntity(
    invoice: '',
    orderNo: '',
    courier: Courier(service: '', waybillNumber: ''),
    customer: CustomerModel(username: '', name: ''),
    date: DateModel(transaction: '', delivery: ''),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    _getStorage();
    final args = Get.arguments;
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
      routeFrom.value = args['routeFrom'] ?? '';
    }
  }

  @override
  void onReady() {
    super.onReady();
    // _getDetailOrder();
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = false;
  }

  void onRefreshDetailOrder() {
    _getDetailOrder();
  }

  void onRefreshAssistant() {
    getAssisten();
  }

  Future<void> _getDetailOrder() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await detailOrderUseCase.call(noInvoice.value);

      switch (result) {
        case Success(:final data):
          debugPrint('Data Detail Order: $data');
          orderDetail.value = data;
          isSelect.value = orderDetail.value.assistant != null;

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

  Future<void> getAssisten() async {
    if (isLoadingAssistant.value) return;
    isLoadingAssistant.value = true;

    try {
      final result = await Future.wait([
        detailOrderUseCase.callUsers(),
        detailOrderUseCase.callTransportations(),
      ]);

      final usersResult = result[0];
      final transportationsResult = result[1];

      switch (usersResult) {
        case Success(:final data):
          debugPrint('Data Detail Order Users: $data');
          listUser.value = data as List<UserEntity>;
          driverSelected.value = data.first.username;
          assistantSelected.value = data.first.username;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }

      switch (transportationsResult) {
        case Success(:final data):
          debugPrint('Data Detail Order Users: $data');
          transportations.value = data as List<TransportationEntity>;
          selectTransportation.value = data.first.namaKendaraan!;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } finally {
      isLoadingAssistant.value = false;
    }
  }

  Future<void> addAssistant() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final loader = transportations.firstWhereOrNull(
        (element) => element.namaKendaraan == selectTransportation.value,
      );
      final driver = listUser.firstWhereOrNull(
        (element) => element.username == driverSelected.value,
      );
      final kenek = listUser.firstWhereOrNull(
        (element) => element.username == assistantSelected.value,
      );

      final result = await detailOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          invoice: noInvoice.value,
          idLoader: loader!.id,
          idDriver: driver!.userId,
          idKenek: kenek!.userId,
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            isSelect.value = !isSelect.value;
            dialogService.showSuccessSnackbar('Berhasil Menambahkan Asisten');
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPendingSO() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      final result = await detailOrderUseCase.callPendingSO(noInvoice.value);

      switch (result) {
        case Success(:final data):
          if (data.status) {
            dialogService.showDialogBox(
              title: 'Success',
              description: data.message,
              barrierDismissible: false,
              onPressed: () => Get.offNamed(Routes.LIST_ORDER));
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  void _getStorage() {
    final userStorage = GetStorage().read('user');

    if (userStorage != null) {
      final parsing = jsonDecode(userStorage);
      userModel.value = UserModel.fromJson(parsing);
    }
  }
}
