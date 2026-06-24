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

  ListOrderController get listCtrl => Get.find<ListOrderController>();

  Future<void> getOrder({bool isRefresh = false}) async {
    try {
      listCtrl.loadState.value =
          (isRefresh || listCtrl.currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      if (isRefresh) {
        if (listCtrl.pageIndex.value == 0) {
          listCtrl.listRit.clear();
        } else {
          listCtrl.orders.clear();
        }

        listCtrl.currentPage.value = 1;
      }

      final result = await listOrderUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: '${listCtrl.currentPage.value}',
          q: listCtrl.searchController.text,
          sort: listCtrl.sortByNew.value ? 'newest' : 'oldest',
          filter: listCtrl.isStatusSelected.value.toLowerCase(),
          district: listCtrl.isDistrictSelected.value.toLowerCase(),
          dateRit: listCtrl.tanggalRit.value,
          pastRit: !listCtrl.isRitToday.value,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');
          if (data.isEmpty) {
            if (isRefresh && listCtrl.currentPage.value == 1) {
              listCtrl.loadState.value = LoadState.idle;
            } else {
              listCtrl.loadState.value = LoadState.noMore;
            }
            return;
          }
          listCtrl.orders.addAll(data);
          listCtrl.loadState.value = LoadState.idle;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          listCtrl.loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
      }
    } catch (e) {
      listCtrl.loadState.value = LoadState.error;
      if (Get.isDialogOpen == true) Get.back();
      listCtrl.dialogService.showError('Failed', 'Error Get Data');
    } finally {
      listCtrl.isLoading.value = false;
    }
  }

  Future<void> getRit({bool? isPashRit, String? dateRIT}) async {
    if (listCtrl.isLoading.value) return;
    listCtrl.isLoading.value = true;

    String sendDate = listCtrl.pastRitDateSelected.value;

    if (sendDate.isEmpty) {
      sendDate = listCtrl.tanggalRit.value;
    }

    debugPrint('DATE RIT : $sendDate');

    final result = await listOrderUseCase.callGetRit(
      ParamGetRIT(isPastRit: !listCtrl.isRitToday.value, date: sendDate),
    );

    try {
      switch (result) {
        case Success(:final data):
          listCtrl.listRit.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          listCtrl.loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      listCtrl.dialogService.showError('Failed', 'Error Get Data');
    } finally {
      listCtrl.isLoading.value = false;
      listCtrl.loadState.value = LoadState.idle;
    }
  }

  Future<void> getAssisten() async {
    if (listCtrl.isLoadingAssistant.value) return;
    listCtrl.isLoadingAssistant.value = true;

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
          listCtrl.listUser.value = data as List<UserEntity>;
          listCtrl.driverSelected.value = data.first.nama;
          listCtrl.assistantSelected.value = data.first.nama;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
      }

      switch (transportationsResult) {
        case Success(:final data):
          listCtrl.transportations.value = data as List<TransportationEntity>;

          if (data.first.namaKendaraan != null &&
              data.first.namaKendaraan != '-') {
            listCtrl.selectTransportation.value = data.first.namaKendaraan!;
          } else if (data.first.jenisKendaraan != null &&
              data.first.jenisKendaraan != '-') {
            listCtrl.selectTransportation.value = data.first.jenisKendaraan!;
          }

          listCtrl.nopolTransportation.value =
              data.first.idDeliveryMobil ?? '-';

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          listCtrl.dialogService.showError('Failed', message);
      }
    } finally {
      listCtrl.isLoadingAssistant.value = false;
    }
  }
}
