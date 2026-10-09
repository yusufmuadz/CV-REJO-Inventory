import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/bbm_entity.dart';
import '../../domain/params/isi_bbm_param.dart';
import '../../domain/usecases/get_home_usecase.dart';
import 'home_controller.dart';

class HomeBbmController extends GetxController {
  final GetHomeUseCase homeUseCase;

  HomeBbmController({required this.homeUseCase});

  HomeController get masterController => Get.find<HomeController>();

  final isLoading = false.obs;
  final isLoadingDialog = false.obs;
  final dialogService = Get.find<DialogService>();
  final locationService = LocationService();

  final formKey = GlobalKey<FormState>();

  final date = DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now()).obs;

  final isiAwalController = TextEditingController();
  final inputNopolController = TextEditingController();
  final descController = TextEditingController();
  final nominalController = TextEditingController();
  final paymentMethodController = TextEditingController();

  final mediaFileListFront = <XFile>[].obs;
  final mediaFilesAwalSegel = <XFile>[].obs;
  final mediaFilesDispenserAwalPengisian = <XFile>[].obs;
  final mediaFilesPengisianTangkiFull = <XFile>[].obs;
  final mediaFilesDispenserAkhirPengisian = <XFile>[].obs;
  final mediaFilesSegelBaru = <XFile>[].obs;
  final mediaFilesNota = <XFile>[].obs;

  @override
  void onInit() {
    super.onInit();

    debugPrint('🟢 BBM CREATED: ${hashCode}');
  }

  @override
  void onClose() {
    debugPrint('🔴 BBM CLOSED: ${hashCode}');

    // debugPrintStack(
    //   label: '🔥 HomeBbmController onClose dipanggil dari:',
    //   maxFrames: 15,
    // );

    isiAwalController.dispose();
    inputNopolController.dispose();
    descController.dispose();
    nominalController.dispose();
    paymentMethodController.dispose();

    debugPrint('On Close BBM');

    super.onClose();
  }

  final listBbm = <BbmEntitity>[].obs;

  void addBbm(BbmEntitity bbm) async {
    if (isLoadingDialog.value) return;

    if (_getEmptyMessage() != null) {
      dialogService.showErrorSnackbar(_getEmptyMessage()!);
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoadingDialog.value = true;

    try {
      final date = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(masterController.tanggalRit.value));

      final position = await locationService.getLatestLocationLightweight();

      final lat = position.latitude.toString();
      final long = position.longitude.toString();

      final result = await homeUseCase.callPostIsiBbm(
        ParamsIsiBbm(
          noRit: masterController.rit.value,
          dateRit: date,
          fieldKm: isiAwalController.text,
          fieldNopol: inputNopolController.text,
          fieldDesc: descController.text,
          paymentNominal: nominalController.text,
          paymentMethod: paymentMethodController.text,
          lat: lat,
          long: long,
          imagesFrontTransportation: bbm.mediaFilesFront,
          imagesSealBefore: bbm.mediaFilesAwalSegel,
          imagesSealAfter: bbm.mediaFilesSegelBaru,
          imagesDispenserAwal: bbm.mediaFilesDispenserAwalPengisian,
          imagesDispenserAkhir: bbm.mediaFilesDispenserAkhirPengisian,
          imagesPengisianFull: bbm.mediaFilesPengisianTangkiFull,
          imagesBuktiPembayaran: bbm.mediaFilesNota,
        ),
      );

      switch (result) {
        case Success(:final data):
          listBbm.add(bbm);
          clearForm();
          clearImage();

          if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
            Get.back();
          }

          dialogService.showSuccessDefaultDialog(
            'Success',
            'Berhasil Menyimpan BBM',
            onPressed1: () {
              Get.back();
            },
          );

        case ErrorResult(:final message):
          // if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
          //   Get.back();
          // }
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();

      dialogService.showError('Failed', 'Error Simpan BBM\n$e');
    } finally {
      isLoadingDialog.value = false;
    }
  }

  void clearForm() {
    isiAwalController.clear();
    inputNopolController.clear();
    descController.clear();
    nominalController.clear();
    paymentMethodController.clear();
  }

  void clearImage() {
    mediaFileListFront.clear();
    mediaFilesAwalSegel.clear();
    mediaFilesDispenserAwalPengisian.clear();
    mediaFilesPengisianTangkiFull.clear();
    mediaFilesDispenserAkhirPengisian.clear();
    mediaFilesSegelBaru.clear();
    mediaFilesNota.clear();
  }

  String? _getEmptyMessage() {
    if (masterController.rit.isEmpty || masterController.routeRit.isEmpty) {
      return 'Silakan pilih RIT terlebih dahulu';
    }

    if (isiAwalController.text.isEmpty) {
      return 'Isi awal tidak boleh kosong';
    }

    if (inputNopolController.text.isEmpty) {
      return 'Nomor nopol tidak boleh kosong';
    }

    // if (descController.text.isEmpty) {
    //   return 'Deskripsi tidak boleh kosong';
    // }

    // if (nominalController.text.isEmpty) {
    //   return 'Nominal tidak boleh kosong';
    // }

    // if (paymentMethodController.text.isEmpty) {
    //   return 'Metode pembayaran tidak boleh kosong';
    // }

    if (mediaFileListFront.isEmpty) {
      return 'Foto awal tidak boleh kosong';
    }

    if (mediaFilesAwalSegel.isEmpty) {
      return 'Foto awal segel tidak boleh kosong';
    }

    if (mediaFilesDispenserAwalPengisian.isEmpty) {
      return 'Foto dispenser awal pengisian tidak boleh kosong';
    }

    if (mediaFilesPengisianTangkiFull.isEmpty) {
      return 'Foto pengisian tangki full tidak boleh kosong';
    }

    if (mediaFilesDispenserAkhirPengisian.isEmpty) {
      return 'Foto dispenser akhir pengisian tidak boleh kosong';
    }

    if (mediaFilesSegelBaru.isEmpty) {
      return 'Foto segel baru tidak boleh kosong';
    }

    if (mediaFilesNota.isEmpty) {
      return 'Foto nota tidak boleh kosong';
    }
    return null;
  }
}
