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
import '../widgets/dialog_list_order/detail_rit_dialog.dart';
import 'list_order_controller.dart';

class GetDataListController extends GetxController {
  final ListOrderUseCase listOrderUseCase;

  GetDataListController({required this.listOrderUseCase});

  ListOrderController get listCtrl => Get.find<ListOrderController>();

  Future<void> getOrder({
    bool isRefresh = false,
    bool isDetail = false,
    String? dateRIT,
    String? noRIT,
  }) async {
    try {
      if (isDetail) {
        listCtrl.loadStateDetailPO.value = _getLoad(
          isRefresh: isRefresh,
          currentPage: listCtrl.currentPageDetail.value,
        );
      } else {
        listCtrl.loadState.value = _getLoad(
          isRefresh: isRefresh,
          currentPage: listCtrl.currentPage.value,
        );
      }

      if (isRefresh) {
        if (listCtrl.pageIndex.value == 0 && !isDetail) {
          listCtrl.listRit.clear();
        } else {
          listCtrl.orders.clear();
        }

        if (isDetail) {
          listCtrl.currentPageDetail.value = 1;
        } else {
          listCtrl.currentPage.value = 1;
        }
      }

      final result = await listOrderUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          page: isDetail
              ? '${listCtrl.currentPageDetail.value}'
              : '${listCtrl.currentPage.value}',
          q: listCtrl.searchController.text,
          sort: listCtrl.sortByNew.value ? 'newest' : 'oldest',
          filter: listCtrl.isStatusSelected.value.toLowerCase(),
          district: noRIT ?? listCtrl.isDistrictSelected.value.toLowerCase(),
          dateRit: dateRIT ?? listCtrl.tanggalRit.value,
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
              if (isDetail) {
                listCtrl.loadStateDetailPO.value = LoadState.noMore;
              } else {
                listCtrl.loadState.value = LoadState.noMore;
              }
            }
            return;
          }

          final filterData = data.where((element) {
            bool result = true;

            // if (AppRole.isChecker2 &&
            //     element.checker2?.status == 'completed' &&
            //     element.loader?.status == 'available') {
            //   result = false;
            // }

            return result;
          }).toList();

          listCtrl.orders.addAll(filterData);

          debugPrint('isDetail: $isDetail');

          if (isDetail) {
            debugPrint('Data Order: ${listCtrl.orders.length}');
            listCtrl.loadStateDetailPO.value = LoadState.idle;
            // if (listCtrl.orders.isNotEmpty) {
            //   DetailRITDialog().showDetailRIT(controller: listCtrl);
            // }
          } else {
            listCtrl.loadState.value = LoadState.idle;
          }

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

  LoadState _getLoad({bool isRefresh = false, int currentPage = 1}) {
    final result = (isRefresh || currentPage == 1)
        ? LoadState.initial
        : LoadState.loadingMore;

    return result;
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
