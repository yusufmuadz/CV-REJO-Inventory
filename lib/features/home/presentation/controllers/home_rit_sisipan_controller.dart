import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../detail_order/domain/entities/transportation_entity.dart';
import '../../../detail_order/domain/params/add_assistant_param.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../../../list_order/domain/params/get_rit_param.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../../list_order/domain/usecases/list_order_usecase.dart';
import '../../../login/domain/entities/user_entity.dart';
import '../../domain/usecases/get_home_usecase.dart';

class HomeRitSisipanController extends GetxController {
  final GetHomeUseCase homeUseCase;
  final ListOrderUseCase listOrderUseCase;

  HomeRitSisipanController({
    required this.homeUseCase,
    required this.listOrderUseCase,
  });

  final isLoading = false.obs;
  final isLoadingPO = false.obs;
  final isLoadingAssistant = false.obs;
  final getLoadState = LoadState.initial.obs;

  final dialogService = Get.find<DialogService>();

  final listRit = <RitListEntity>[].obs;
  final listOrder = <OrderEntity>[].obs;

  final listUser = <UserEntity>[].obs;
  final transportations = <TransportationEntity>[].obs;
  final statusTransportations = ['Internal', 'External'].obs;

  final driverSelected = ''.obs;
  final assistantSelected = ''.obs;
  final selectTransportation = ''.obs;
  final statusTransportationSelected = 'Internal'.obs;
  final nopolTransportation = ''.obs;

  final extNopolTransporation = TextEditingController();

  final currentNoRIT = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getRit(isRefresh: false);
  }

  void onRefreshRIT() {
    // _getRit(isRefresh: true);
    getRit(isRefresh: true);
  }

  void retryFetch() => getRit(isRefresh: getLoadState.value == LoadState.error);

  Future<void> getRit({
    required bool isRefresh,
    bool? isPashRit,
    String? dateRIT,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    // String sendDate = pastRitDateSelected.value;

    // if (sendDate.isEmpty) {
    //   sendDate = tanggalRit.value;
    // }

    // debugPrint('DATE RIT : $sendDate');

    final result = await homeUseCase.callGetRIT(ParamGetRIT(isPastRit: false));

    try {
      getLoadState.value = isRefresh
          ? LoadState.initial
          : LoadState.loadingMore;

      switch (result) {
        case Success(:final data):
          listRit.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          getLoadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
      getLoadState.value = LoadState.idle;
    }
  }

  Future<void> getPO({
    bool isRefresh = false,
    required String noRIT,
    required String date,
  }) async {
    if (isLoadingPO.value) return;
    isLoadingPO.value = true;

    try {
      if (isRefresh || currentNoRIT.value != noRIT) {
        listOrder.clear();
      }

      if (currentNoRIT.value == noRIT) {
        return;
      }

      currentNoRIT.value = noRIT;

      debugPrint('NO RIT: $noRIT');
      debugPrint('CURRENT NO RIT: ${currentNoRIT.value}');
      debugPrint('DATE RIT: $date');

      final result = await homeUseCase.call(
        ParamsGetTransaction(
          limit: '10',
          // q: searchTrackingController.text,
          filter: '',
          district: noRIT, // '10'
          dateRit: date, // '2026-09-02'
          isSisipan: true,
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');
          listOrder.addAll(data);

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoadingPO.value = false;
    }
  }

  Future<void> getAssisten() async {
    if (isLoadingAssistant.value) return;
    isLoadingAssistant.value = true;

    try {
      final result = await Future.wait([
        listOrderUseCase.callUsers(),
        listOrderUseCase.callLoaderTransportations(),
      ]);

      final usersResult = result[0];
      final transportationsResult = result[1];

      switch (usersResult) {
        case Success(:final data):
          listUser.value = data as List<UserEntity>;

          listUser.sort(
            (UserEntity a, UserEntity b) => a.nama.compareTo(b.nama),
          );

          driverSelected.value = listUser.first.nama;
          assistantSelected.value = listUser.first.nama;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }

      switch (transportationsResult) {
        case Success(:final data):
          transportations.value = data as List<TransportationEntity>;

          if (data.first.namaKendaraan != null &&
              data.first.namaKendaraan != '-') {
            transportations.sort(
              (TransportationEntity a, TransportationEntity b) =>
                  a.namaKendaraan!.compareTo(b.namaKendaraan!),
            );
            selectTransportation.value = transportations.first.namaKendaraan!;
          } else if (data.first.jenisKendaraan != null &&
              data.first.jenisKendaraan != '-') {
            transportations.sort(
              (TransportationEntity a, TransportationEntity b) =>
                  a.jenisKendaraan!.compareTo(b.jenisKendaraan!),
            );
            selectTransportation.value = transportations.first.jenisKendaraan!;
          }

          nopolTransportation.value = data.first.idDeliveryMobil ?? '-';

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } finally {
      isLoadingAssistant.value = false;
    }
  }

  void addAssistant({required String noRIT, required String tanggalRIT}) async {
    if (isLoadingAssistant.value) return;
    isLoadingAssistant.value = true;

    try {
      TransportationEntity? loader;
      UserEntity? driver;
      UserEntity? kenek;
      String? idKendaraan;

      if (statusTransportationSelected.value == 'Internal') {
        loader = transportations.firstWhereOrNull((element) {
          bool result = false;
          String kendaraan = element.jenisKendaraan ?? '';

          if (kendaraan == selectTransportation.value) {
            result = true;
          }
          return result;
        });
        driver = listUser.firstWhereOrNull(
          (element) => element.nama == driverSelected.value,
        );
        kenek = listUser.firstWhereOrNull(
          (element) => element.nama == assistantSelected.value,
        );

        // debugPrint('ID Kendaraan: ${loader}');
        // debugPrint('ID Forklift: ${loader.id}');

        idKendaraan = loader!.idDeliveryMobil;
      }

      final dateRIT = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(tanggalRIT));

      final result = await listOrderUseCase.callPostAssistant(
        ParamsAddAssistant(
          // invoice: invoice,
          district: noRIT,
          idKendaraan: idKendaraan,
          idDriver: driver?.userId ?? '',
          idKenek: kenek?.userId ?? '',
          dateRIT: dateRIT,
          isSisipan: true,
          isDetail: false,
          statusTransportation: statusTransportationSelected.value
              .toUpperCase(),
        ),
      );

      switch (result) {
        case Success(:final data):
          if (data.status) {
            debugPrint('Success Add Assistant: ${data.message}');
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showSuccessSnackbar('Berhasil Menambahkan Asisten');
          } else {
            if (Get.isDialogOpen == true) Get.back();
            dialogService.showError('Failed', data.message);
          }

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          // loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      debugPrint('Error Add Assistant: $e');
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', '$e');
    } finally {
      isLoadingAssistant.value = false;
    }
  }
}
