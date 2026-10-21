import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/presentation/controllers/enums/button_inv_enum.dart';
import '../../domain/entities/route_collector_entity.dart';
import '../../domain/params/get_collector_transaction_param.dart';
import '../../domain/usecases/rit_usecase.dart';
import 'rit_controller.dart';

class InvController extends GetxController {
  final RitUseCase ritUseCase;

  InvController({required this.ritUseCase});

  RitController get ritController => Get.find<RitController>();

  final isGetLoading = false.obs;
  // final getLoadState = LoadState.initial.obs;

  final dialogService = Get.find<DialogService>();

  final buttonINV = EnumButtonInv.acceptINV.obs;

  final isSelectedRoute = ''.obs;
  final dateRoute = ''.obs;

  final searchInvController = TextEditingController();

  final listRouteCollector = <RouteCollectorEntity>[].obs;
  final listInv = <OrderEntity>[].obs;

  void retryFetchRouteCollector() => getRouteCollector(
    isRefresh: ritController.loadState.value == LoadState.error,
  );

  void retryFetchInvCollector() => getInvCollector(
    isRefresh: ritController.loadState.value == LoadState.error,
  );

  void onRefreshRouteCollector() {
    getRouteCollector(isRefresh: true);
  }

  void onRefreshInvCollector() {
    getInvCollector(isRefresh: true);
  }

  Future<void> getRouteCollector({bool isRefresh = false}) async {
    try {
      if (isGetLoading.value) return;

      ritController.loadState.value =
          (isRefresh || ritController.currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      isGetLoading.value = true;

      if (isRefresh) {
        listRouteCollector.clear();
        ritController.currentPage.value = 1;
      }

      final result = await ritUseCase.callGetRouteCollector();

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');

          if (data.isEmpty) {
            if (isRefresh && ritController.currentPage.value == 1) {
              ritController.loadState.value = LoadState.idle;
            } else {
              ritController.loadState.value = LoadState.noMore;
            }
            return;
          }

          listRouteCollector.addAll(data);
          ritController.loadState.value = LoadState.idle;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          ritController.loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      ritController.loadState.value = LoadState.error;
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isGetLoading.value = false;
    }
  }

  Future<void> getInvCollector({
    bool isRefresh = false,
    String? noRoute,
  }) async {
    try {
      if (isGetLoading.value) return;

      ritController.loadState.value =
          (isRefresh || ritController.currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      isGetLoading.value = true;

      if (isRefresh) {
        listInv.clear();
        ritController.currentPage.value = 1;
      }

      final result = await ritUseCase.callInvCollector(
        ParamsGetCollectorTransaction(
          noRoute: noRoute ?? isSelectedRoute.value,
        ),
      );

      if (noRoute != null && noRoute.isNotEmpty) {
        isSelectedRoute.value = noRoute;
      }

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');

          if (data.isEmpty) {
            if (isRefresh && ritController.currentPage.value == 1) {
              ritController.loadState.value = LoadState.idle;
            } else {
              ritController.loadState.value = LoadState.noMore;
            }
            return;
          }

          listInv.addAll(data);
          ritController.loadState.value = LoadState.idle;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          ritController.loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      ritController.loadState.value = LoadState.error;
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isGetLoading.value = false;
    }
  }

  LoadState _getLoad({bool isRefresh = false, int currentPage = 1}) {
    final result = (isRefresh || currentPage == 1)
        ? LoadState.initial
        : LoadState.loadingMore;

    return result;
  }

  void onSelectedInv(int index) {
    if (index != -1) {
      final invEntity = listInv[index];

      bool result = !invEntity.isChecked;

      final updatedInv = invEntity.copyWith(isChecked: result);

      final updateList = List<OrderEntity>.from(listInv);
      updateList[index] = updatedInv;

      listInv.value = updateList;
      // selectedAllItem.value = listInv.every((e) => e.isChecked);

      //   isSelectedRoute.value = id;
      //   listInv[index].isSelected = !listInv[index].isSelected;
      //   dateRoute.value = listInv[index].date?.transaction ?? '';
    } else {
      isSelectedRoute.value = '';
      dateRoute.value = '';
    }
  }

  void onWidgetScroll({
    required bool isInv,
    required ScrollController activeController,
  }) {
    if (!activeController.hasClients) return;

    final currentPixels = activeController.position.pixels;
    final maxScroll = activeController.position.maxScrollExtent;

    // DEBUG: Pantau angka ini di console saat Anda melakukan scroll
    // debugPrint('Pixels: $currentPixels / Max: $maxScroll');

    final canLoad = ritController.loadState.value == LoadState.idle;

    // Jika canLoad bernilai false, pagination tidak akan berjalan.
    // Pastikan setelah _getOrder() selesai, loadState.value dikembalikan ke LoadState.idle
    if (canLoad && currentPixels >= maxScroll - 200) {
      debugPrint('=== MEMANGGIL HALAMAN BERIKUTNYA ===');
      ritController.currentPage.value++;
      if (isInv) {
        getInvCollector();
      } else {
        getRouteCollector();
      }
    }
  }
}
