import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../detail_order/domain/entities/transportation_entity.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
import '../../../ending_order/domain/params/post_ending_order_param.dart';
import '../../../ending_order/domain/usecases/ending_order_usecase.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../domain/usecases/list_order_usecase.dart';
import 'list_order_controller.dart';

class PostDataListController extends GetxController {
  final ListOrderUseCase listOrderUseCase;
  final EndingOrderUseCase endingOrderUseCase;

  PostDataListController({
    required this.listOrderUseCase,
    required this.endingOrderUseCase,
  });

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
          AppRole.isChecker2 && listCtrl.totalPendingPoRITCheck2.value != '0';

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

  Future<bool> addAssistant({
    bool isDetail = false,
    String invoice = '',
  }) async {
    if (listCtrl.isLoadingAssistant.value) return false;
    listCtrl.isLoadingAssistant.value = true;

    try {
      TransportationEntity? loader;
      UserEntity? driver;
      UserEntity? kenek;
      String? idKendaraan;

      if (listCtrl.statusTransportationSelected.value == 'Internal') {
        loader = listCtrl.transportations.firstWhereOrNull((element) {
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
        driver = listCtrl.listUser.firstWhereOrNull(
          (element) => element.nama == listCtrl.driverSelected.value,
        );
        kenek = listCtrl.listUser.firstWhereOrNull(
          (element) => element.nama == listCtrl.assistantSelected.value,
        );

        // debugPrint('ID Kendaraan: ${loader}');
        // debugPrint('ID Forklift: ${loader.id}');

        idKendaraan = AppRole.isChecker2
            ? loader?.idDeliveryMobil ?? ''
            : loader?.id ?? '';
      }

      final dateRIT = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(listCtrl.tanggalRit.value));

      final result = await listOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          invoice: invoice,
          district: listCtrl.isSelected.value,
          idKendaraan: idKendaraan,
          idDriver: driver != null ? driver.userId : '',
          idKenek: kenek != null ? kenek.userId : '',
          dateRIT: dateRIT,
          isDetail: isDetail,
          isSisipan: listCtrl.isSisipan.value,
          statusTransportation: listCtrl.statusTransportationSelected.value
              .toUpperCase(),
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            // takeItOrder();
            // isSelect.value = !isSelect.value;
            debugPrint('Success Add Assistant: ${data.message}');
            listCtrl.isAddAssistant.value = true;
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

  void changeDriver() async {
    if (listCtrl.isLoadingAssistant.value) return;
    listCtrl.isLoadingAssistant.value = true;

    try {
      TransportationEntity? loader;
      UserEntity? driver;
      String? idKendaraan;

      loader = listCtrl.transportations.firstWhereOrNull((element) {
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

      driver = listCtrl.listUser.firstWhereOrNull(
        (element) => element.nama == listCtrl.driverSelected.value,
      );

      idKendaraan = AppRole.isChecker2
          ? loader?.idDeliveryMobil ?? ''
          : loader?.id ?? '';

      final rawDate = listCtrl.tanggalRit.value;
      final parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
      final dateRIT = DateFormat('yyyy-MM-dd').format(parsedDate);

      debugPrint('RIT: ${listCtrl.isSelected.value}');
      debugPrint('ID Kendaraan: $idKendaraan');
      debugPrint('ID Driver: ${driver?.userId}');
      debugPrint('Date RIT: $dateRIT');
      debugPrint('Desc: ${listCtrl.descAssistantController.value.text}');

      final result = await listOrderUseCase.callSwitchDriver(
        ParamsAddAssistant(
          district: listCtrl.isSelected.value,
          idKendaraan: idKendaraan,
          idDriver: driver != null ? driver.userId : '',
          dateRIT: dateRIT,
          desc: listCtrl.descAssistantController.value.text,
        ),
      );

      switch (result) {
        case Success():
          if (Get.isDialogOpen == true) Get.back();
          listCtrl.dialogService.showSuccessDefaultDialog(
            title: 'Success',
            message: 'Berhasil Mengubah Driver & Armada',
            onPressed1: () {
              listCtrl.driverSelected.value = listCtrl.listUser.first.nama;
              listCtrl.descAssistantController.clear();
              Get.back();
            },
          );
        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      listCtrl.dialogService.showError('Failed', '$e');
    } finally {
      listCtrl.isLoadingAssistant.value = false;
    }
  }

  Future<void> pendingRIT() async {
    if (listCtrl.isLoadingReason.value) return;
    listCtrl.isLoadingReason.value = true;

    try {
      final result = await endingOrderUseCase.callPendingOrder(
        ParamsEndingOrder(
          jenisCancel: 'rit',
          rit: listCtrl.isDistrictSelected.value,
          dateRit: listCtrl.tanggalRit.value,
          role: AppRole.current!.name.toLowerCase(),
          statusChecker2: 'ongoing',
          desc: listCtrl.reasonPendingRITController.text,
          images: listCtrl.mediaFileReasonPendingRIT,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Item Product: $data');
          if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true)
            Get.back();
          listCtrl.dialogService.showSuccessDefaultDialog(
            title: 'Success',
            message: 'Berhasil Menunda Pesanan',
            onPressed1: () {
              listCtrl.changeRIT();
              listCtrl.reasonPendingRITController.clear();
              listCtrl.mediaFileReasonPendingRIT.clear();

              GetStorage().remove('city');
              GetStorage().remove('colorRit');
              GetStorage().remove('tanggalRit');
              GetStorage().remove('routeRit');
              GetStorage().remove('notaRoute');
              GetStorage().remove('isAcceptRIT');
              GetStorage().remove('buttonRIT');
              GetStorage().remove('buttonINV');

              listCtrl.homeController.getLocalRit();

              if (Get.isDialogOpen == true) Get.back();
            },
          );

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
      }
    } catch (e) {
      debugPrint('Error Simpan Pesanan: $e');
      if (Get.isDialogOpen == true) Get.back();
      // loadState.value = LoadState.error;
      listCtrl.dialogService.showError('Failed', 'Error Pending Pesanan\n$e');
    } finally {
      listCtrl.isLoadingReason.value = false;
    }
  }
}
