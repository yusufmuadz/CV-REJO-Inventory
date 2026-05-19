import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/domain/entities/list_order_entity.dart';
import '../../../list_order/domain/params/get_transaction_param.dart';
import '../../domain/params/post_rit_param.dart';
import '../../domain/usecases/rit_usecase.dart';

class RitController extends GetxController {
  final RitUseCase ritUseCase;

  RitController({required this.ritUseCase});

  final isLoading = false.obs;
  final isLoadingReason = false.obs;
  final loadState = LoadState.initial.obs;
  final dialogService = Get.find<DialogService>();
  final noInvoice = ''.obs;
  final routeFrom = ''.obs;

  final currentPage = 1.obs;
  final orders = <OrderEntity>[].obs;
  final isDistrictSelected = ''
      .obs; // DIUBAH JADI RIT DULU NANTI JIKA ADA PERUBAHAN DISINI BUAT JADI KOTA LAGI
  final colorRit = ''.obs;
  final tanggalRit = ''.obs;

  final isAccept = false.obs;
  final isSave = false.obs;

  final kmController = TextEditingController();
  final reasonController = TextEditingController();

  final picker = ImagePicker();
  final mediaFileList = <XFile>[].obs;
  final mediaFileListKM = <XFile>[].obs;
  final mediaFileListTangki = <XFile>[].obs;
  final mediaFileListSJ = <XFile>[].obs;
  final mediaFileReason = <XFile>[].obs;

  final pageIndex = 0.obs;
  final pageController = PageController(initialPage: 0);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      noInvoice.value = args['invoice'] ?? '';
      isDistrictSelected.value = args['city'] ?? '';
      colorRit.value = args['colorRit'] ?? '';
      tanggalRit.value = args['tanggalRit'] ?? '';
      routeFrom.value = args['routeFrom'] ?? '';
    }
  }

  @override
  void onReady() {
    super.onReady();
    _getOrder();
  }

  @override
  void onClose() {
    super.onClose();
    isLoading.value = false;
    kmController.dispose();
    mediaFileList.clear();
    noInvoice.value = '';
    routeFrom.value = '';
    colorRit.value = '';
    tanggalRit.value = '';
    mediaFileListKM.clear();
    mediaFileListTangki.clear();
    mediaFileListSJ.clear();
    pageIndex.value = 0;
    pageController.dispose();
    isLoadingReason.value = false;
  }

  void onRefreshTransaction() {
    currentPage.value = 1;

    orders.clear();
    _getOrder(isRefresh: true);
  }

  void retryFetch() => _getOrder(isRefresh: loadState.value == LoadState.error);

  Future<void> acceptRit() async {
    isAccept.value = !isAccept.value;
    // pageIndex.value = 1;
    // pageController.animateToPage(
    //   1,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
  }

  Future<void> saveOrder() async {
    if (isLoading.value) return;

    if (mediaFileList.isEmpty ||
        mediaFileListKM.isEmpty ||
        mediaFileListTangki.isEmpty ||
        mediaFileListSJ.isEmpty ||
        kmController.text.isEmpty) {
      dialogService.showErrorSnackbar(
        title: 'Gagal!',
        'Silakan lengkapi data terlebih dahulu!',
      );
      return;
    }
    isLoading.value = true;

    try {
      final result = await ritUseCase.call(
        ParamsRit(
          rit: isDistrictSelected.value,
          km: kmController.text,
          kmImage: mediaFileListKM[0],
          tankTruckImage: mediaFileListTangki[0],
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Save Order: $data');
          dialogService.showDialogBox(
            title: 'Success',
            description: 'Berhasil Menyimpan Data',
            barrierDismissible: false,
            onPressed: () {
              mediaFileList.clear();
              mediaFileListKM.clear();
              mediaFileListTangki.clear();
              mediaFileListSJ.clear();
              kmController.clear();
              isSave.value = true;
              pageIndex.value = 0;
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          );

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pendingProduct() async {
    if (isLoading.value) return;
    isAccept.value = !isAccept.value;

    //   if (mediaFileList.isEmpty) {
    //     dialogService.showErrorSnackbar(title: 'Gagal!', 'Coming Soon');
    //     return;
    //   }
    //   isLoading.value = true;

    //   try {
    //     final result = await ritUseCase.callPendingOrder(
    //       ParamsRit(
    //         role: AppRole.current!.name.toLowerCase(),
    //         statusChecker2: statusChecker2.value,
    //         invoice: noInvoice.value,
    //         desc: fieldController.text,
    //         images: mediaFileList,
    //       ),
    //     );

    //     switch (result) {
    //       case Success(:final data):
    //         debugPrint('Data Item Product: $data');
    //         dialogService.showDialogBox(
    //           title: 'Success',
    //           description: 'Berhasil Menunda Pesanan',
    //           barrierDismissible: false,
    //           onPressed: () {
    //             GetStorage().remove('noInvoice');
    //             Get.offAllNamed(
    //               Routes.LIST_ORDER,
    //               arguments: {'routeFrom': 'endingOrder'},
    //             );
    //           },
    //         );

    //       case ErrorResult(:final message):
    //         if (Get.isDialogOpen == true) Get.back();
    //         dialogService.showError('Failed', message);
    //     }
    //   } finally {
    //     isLoading.value = false;
    //   }
  }

  Future<void> _getOrder({bool isRefresh = false}) async {
    try {
      loadState.value = (isRefresh || currentPage.value == 1)
          ? LoadState.initial
          : LoadState.loadingMore;

      final result = await ritUseCase.callGetOrders(
        ParamsGetTransaction(
          limit: '10',
          page: '$currentPage',
          filter: 'all',
          // sort: sortByNew.value ? 'newest' : 'oldest',
          district: isDistrictSelected.value.toLowerCase(),
        ),
      );

      switch (result) {
        case Success(:final data):
          debugPrint('Data Order: ${data.length}');
          if (data.isEmpty) {
            if (isRefresh && currentPage.value == 1) {
              loadState.value = LoadState.idle;
            } else {
              loadState.value = LoadState.noMore;
            }
            return;
          }
          orders.addAll(data);
          loadState.value = LoadState.idle;

        case ErrorResult(:final message):
          if (Get.isDialogOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      loadState.value = LoadState.error;
      if (Get.isDialogOpen == true) Get.back();
      dialogService.showError('Failed', 'Error Get Data');
    } finally {
      // isLoading.value = false;
    }
  }

  void selectImage(ImageSource source, files) async {
    try {
      final pickedFile = await picker.pickImage(
        source: source, // Atau ImageSource.gallery untuk galeri
        imageQuality: 70,
      );

      if (pickedFile != null) {
        files.add(pickedFile);
        update(); // Memperbarui state untuk menampilkan gambar yang dipilih
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void removeImage(int index, files) {
    if (index >= 0 && index < files.length) {
      files.removeAt(index);
      update(); // Memperbarui state setelah gambar dihapus
    }
  }

  void clearAllImages(files) {
    files.clear();
    update(); // Memperbarui state setelah semua gambar dan teks dihapus
  }
}
