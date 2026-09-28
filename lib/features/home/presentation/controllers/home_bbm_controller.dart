import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/dialog_service.dart';
import '../../domain/entities/bbm_entity.dart';
import 'home_controller.dart';

class HomeBbmController extends GetxController {
  HomeController get masterController => Get.find<HomeController>();

  final isLoading = false.obs;
  final isLoadingDialog = false.obs;
  final dialogService = Get.find<DialogService>();

  final formKey = GlobalKey<FormState>();

  final date = DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now()).obs;

  final isiAwalController = TextEditingController();
  final inputNopolController = TextEditingController();
  final descController = TextEditingController();

  final mediaFileListFront = <XFile>[].obs;
  final mediaFilesAwalSegel = <XFile>[].obs;
  final mediaFilesDispenserAwalPengisian = <XFile>[].obs;
  final mediaFilesPengisianTangkiFull = <XFile>[].obs;
  final mediaFilesDispenserAkhirPengisian = <XFile>[].obs;
  final mediaFilesSegelBaru = <XFile>[].obs;
  final mediaFilesNota = <XFile>[].obs;

  @override
  void onClose() {
    isiAwalController.dispose();
    inputNopolController.dispose();
    descController.dispose();

    super.onClose();
  }

  final listBbm = <BbmEntitity>[].obs;

  void addBbm(BbmEntitity bbm) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (_getEmptyMessage() != null) {
      dialogService.showErrorSnackbar(_getEmptyMessage()!);
      return;
    }

    listBbm.add(bbm);
    Get.back();
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
