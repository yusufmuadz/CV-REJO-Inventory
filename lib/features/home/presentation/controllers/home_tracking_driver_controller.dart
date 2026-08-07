import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/rit_list_entity.dart';
import '../../../list_order/domain/params/get_rit_param.dart';
import '../../../list_order/domain/usecases/list_order_usecase.dart';
import '../../domain/usecases/get_home_usecase.dart';

class HomeTrackingDriverController extends GetxController {
  final GetHomeUseCase homeUseCase;
  final ListOrderUseCase listOrderUseCase;

  HomeTrackingDriverController({
    required this.homeUseCase,
    required this.listOrderUseCase,
  });

  final isLoading = false.obs;
  final loadState = LoadState.initial.obs;
  final dialogService = Get.find<DialogService>();

  final currentPage = 1.obs;
  final listRit = <RitListEntity>[].obs;

  late final scrollerController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _getRit(isRefresh: true);

    scrollerController.addListener(onWidgetScroll);
  }

  @override
  void onClose() {
    super.onClose();
    scrollerController.dispose();
  }

  void onRefreshTransaction() {
    _getRit(isRefresh: true);
  }

  void retryFetch() => _getRit(isRefresh: loadState.value == LoadState.error);

  Future<void> _getRit({
    bool isRefresh = false,
    bool? isPashRit,
    String? dateRIT,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;

    String sendDate = DateTime.now().toString();

    // if (sendDate.isEmpty) {
    //   sendDate = tanggalRit.value;
    // }

    debugPrint('DATE RIT : $sendDate');

    final result = await listOrderUseCase.callGetRit(
      ParamGetRIT(isPastRit: false, date: sendDate),
    );

    try {
      switch (result) {
        case Success(:final data):
          listRit.value = data;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          loadState.value = LoadState.error;
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      isLoading.value = false;
      // loadState.value = LoadState.idle;
    }
  }

  void onWidgetScroll() {
    if (!scrollerController.hasClients) return;

    final currentPixels = scrollerController.position.pixels;
    final maxScroll = scrollerController.position.maxScrollExtent;

    // DEBUG: Pantau angka ini di console saat Anda melakukan scroll
    // debugPrint('Pixels: $currentPixels / Max: $maxScroll');

    final canLoad = loadState.value == LoadState.idle;

    // Jika canLoad bernilai false, pagination tidak akan berjalan.
    // Pastikan setelah _getOrder() selesai, loadState.value dikembalikan ke LoadState.idle
    if (canLoad && currentPixels >= maxScroll - 200) {
      debugPrint('=== MEMANGGIL HALAMAN BERIKUTNYA ===');
      currentPage.value++;
      _getRit();
    }
  }
}
