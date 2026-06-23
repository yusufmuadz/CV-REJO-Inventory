import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../utils/loading_custom.dart';
import '../../../detail_order/domain/entities/transportation_entity.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../domain/params/get_rit_param.dart';
import '../../domain/params/get_transaction_param.dart';
import '../../domain/usecases/list_order_usecase.dart';
import 'list_order_controller.dart';

class GetDataListController extends GetxController {
  final ListOrderUseCase listOrderUseCase;

  GetDataListController({required this.listOrderUseCase});

  final masterCtrl = Get.find<ListOrderController>();

  Future<void> getOrder({bool isRefresh = false}) async {
    try {
      masterCtrl.loadState.value =
          (isRefresh || masterCtrl.currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      if (isRefresh) {
        if (masterCtrl.pageIndex.value == 0) {
          masterCtrl.listRit.clear();
        } else {
          masterCtrl.orders.clear();
        }

        masterCtrl.currentPage.value = 1;
      }

      final result = await listOrderUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: '${masterCtrl.currentPage.value}',
          q: masterCtrl.searchController.text,
          sort: masterCtrl.sortByNew.value ? 'newest' : 'oldest',
          filter: masterCtrl.isStatusSelected.value.toLowerCase(),
          district: masterCtrl.isDistrictSelected.value.toLowerCase(),
          dateRit: masterCtrl.tanggalRit.value,
          pastRit: !masterCtrl.isRitToday.value,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');
          if (data.isEmpty) {
            if (isRefresh && masterCtrl.currentPage.value == 1) {
              masterCtrl.loadState.value = LoadState.idle;
            } else {
              masterCtrl.loadState.value = LoadState.noMore;
            }
            return;
          }
          masterCtrl.orders.addAll(data);
          masterCtrl.loadState.value = LoadState.idle;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          masterCtrl.loadState.value = LoadState.error;
          masterCtrl.dialogService.showError('Failed', message);
      }
    } catch (e) {
      masterCtrl.loadState.value = LoadState.error;
      if (Get.isDialogOpen == true) Get.back();
      masterCtrl.dialogService.showError('Failed', 'Error Get Data');
    } finally {
      masterCtrl.isLoading.value = false;
    }
  }

  Future<void> getRit({bool? isPashRit, String? dateRIT}) async {
    if (masterCtrl.isLoading.value) return;
    masterCtrl.isLoading.value = true;

    String sendDate = masterCtrl.pastRitDateSelected.value;

    if (sendDate.isEmpty) {
      sendDate = masterCtrl.tanggalRit.value;
    }

    debugPrint('DATE RIT : $sendDate');

    final result = await listOrderUseCase.callGetRit(
      ParamGetRIT(isPastRit: !masterCtrl.isRitToday.value, date: sendDate),
    );

    try {
      switch (result) {
        case Success(:final data):
          masterCtrl.listRit.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          masterCtrl.loadState.value = LoadState.error;
          masterCtrl.dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      masterCtrl.dialogService.showError('Failed', 'Error Get Data');
    } finally {
      masterCtrl.isLoading.value = false;
      masterCtrl.loadState.value = LoadState.idle;
    }
  }

  Future<void> getAssisten() async {
    if (masterCtrl.isLoadingAssistant.value) return;
    masterCtrl.isLoadingAssistant.value = true;

    try {
      final result = await Future.wait([
        listOrderUseCase.callUsers(),
        if (!AppRole.isChecker2) listOrderUseCase.callTransportations(),
        if (AppRole.isChecker2) listOrderUseCase.callLoaderTransportations(),
      ]);

      final usersResult = result[0];
      final transportationsResult = result[1];

      switch (usersResult) {
        case Success(:final data):
          masterCtrl.listUser.value = data as List<UserEntity>;
          masterCtrl.driverSelected.value = data.first.nama;
          masterCtrl.assistantSelected.value = data.first.nama;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          masterCtrl.dialogService.showError('Failed', message);
      }

      switch (transportationsResult) {
        case Success(:final data):
          masterCtrl.transportations.value = data as List<TransportationEntity>;

          if (data.first.namaKendaraan != null &&
              data.first.namaKendaraan != '-') {
            masterCtrl.selectTransportation.value = data.first.namaKendaraan!;
          } else if (data.first.jenisKendaraan != null &&
              data.first.jenisKendaraan != '-') {
            masterCtrl.selectTransportation.value = data.first.jenisKendaraan!;
          }

          masterCtrl.nopolTransportation.value =
              data.first.idDeliveryMobil ?? '-';

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          masterCtrl.dialogService.showError('Failed', message);
      }
    } finally {
      masterCtrl.isLoadingAssistant.value = false;
    }
  }
}
