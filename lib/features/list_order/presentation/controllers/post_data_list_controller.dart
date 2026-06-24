import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
import '../../domain/usecases/list_order_usecase.dart';
import 'list_order_controller.dart';

class PostDataListController extends GetxController {
  final ListOrderUseCase listOrderUseCase;

  PostDataListController({required this.listOrderUseCase});

  ListOrderController get listCtrl => Get.find<ListOrderController>();

  Future<bool> takeRIT({
    String rit = '',
    String clrRit = '',
    String tglRit = '',
    bool isRitDate = false,
  }) async {
    if (listCtrl.isLoading.value) return false;
    listCtrl.isLoading.value = true;

    try {
      final dateRIT = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(listCtrl.tanggalRit.value));

      bool isCheck2 =
          AppRole.isChecker2 &&
          listCtrl.totalPendingPoRITCheck2.value != '0';

      final result = await listOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          district: listCtrl.isSelected.value,
          dateRIT: dateRIT,
          isChecker2: isCheck2,
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            // takeItOrder();
            // isSelect.value = !isSelect.value;
            debugPrint('Success Add Assistant: ${data.message}');
            return true;
          } else {
            if (Get.isDialogOpen == true) Get.back();
            listCtrl.dialogService.showError('Failed', data.message);
            return false;
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
          return false;
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      listCtrl.dialogService.showError('Failed', '$e');
      return false;
    } finally {
      listCtrl.isLoading.value = false;
    }
  }

  Future<bool> addAssistant() async {
    if (listCtrl.isLoadingAssistant.value) return false;
    listCtrl.isLoadingAssistant.value = true;

    try {
      final loader = listCtrl.transportations.firstWhereOrNull((element) {
        bool result = false;
        String kendaraan = element.namaKendaraan ?? '';

        if (AppRole.isChecker2) {
          kendaraan = element.jenisKendaraan ?? '';
        }

        if (kendaraan == listCtrl.selectTransportation.value) {
          result = true;
        }
        return result;
      });
      final driver = listCtrl.listUser.firstWhereOrNull(
        (element) => element.nama == listCtrl.driverSelected.value,
      );
      final kenek = listCtrl.listUser.firstWhereOrNull(
        (element) => element.nama == listCtrl.assistantSelected.value,
      );

      // debugPrint('ID Kendaraan: ${loader}');
      // debugPrint('ID Forklift: ${loader.id}');

      final idKendaraan = AppRole.isChecker2
          ? loader!.idDeliveryMobil
          : loader!.id;

      final dateRIT = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(listCtrl.tanggalRit.value));

      final result = await listOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          district: listCtrl.isSelected.value,
          idKendaraan: idKendaraan,
          idDriver: driver!.userId,
          idKenek: kenek!.userId,
          dateRIT: dateRIT,
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            // takeItOrder();
            // isSelect.value = !isSelect.value;
            debugPrint('Success Add Assistant: ${data.message}');
            return true;
          } else {
            if (Get.isDialogOpen == true) Get.back();
            listCtrl.dialogService.showError('Failed', data.message);
            return false;
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
          return false;
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      listCtrl.dialogService.showError('Failed', '$e');
      return false;
    } finally {
      listCtrl.isLoadingAssistant.value = false;
    }
  }
}
