import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/loading_custom.dart';
import '../../controllers/home_controller.dart';
import 'bbm_content.dart';

class BbmInputSheet extends StatelessWidget {
  final HomeController homeController;

  final bool isPreviewMode;

  final String? isiAwal;
  final String? inputNopol;
  final String? date;
  final String? desc;
  final String? rit;
  final String? routeRit;

  final List<XFile>? filesFront;
  final List<XFile>? filesAwalSegel;
  final List<XFile>? filesDispenserAwalPengisian;
  final List<XFile>? filesPengisianTangkiFull;
  final List<XFile>? filesDispenserAkhirPengisian;
  final List<XFile>? filesSegelBaru;
  final List<XFile>? filesNota;

  const BbmInputSheet({
    super.key,
    required this.homeController,
    required this.isPreviewMode,
    this.isiAwal,
    this.inputNopol,
    this.date,
    this.desc,
    this.rit,
    this.routeRit,
    this.filesFront,
    this.filesAwalSegel,
    this.filesDispenserAwalPengisian,
    this.filesPengisianTangkiFull,
    this.filesDispenserAkhirPengisian,
    this.filesSegelBaru,
    this.filesNota,
  });

  static void show({
    required HomeController homeController,
    required bool isPreviewMode,
    String? isiAwal,
    String? inputNopol,
    String? date,
    String? desc,
    String? rit,
    String? routeRit,
    List<XFile>? filesFront,
    List<XFile>? filesAwalSegel,
    List<XFile>? filesDispenserAwalPengisian,
    List<XFile>? filesPengisianTangkiFull,
    List<XFile>? filesDispenserAkhirPengisian,
    List<XFile>? filesSegelBaru,
    List<XFile>? filesNota,
  }) {
    Get.bottomSheet(
      BbmInputSheet(
        homeController: homeController,
        isPreviewMode: isPreviewMode,
        isiAwal: isiAwal,
        inputNopol: inputNopol,
        date: date,
        desc: desc,
        rit: rit,
        routeRit: routeRit,
        filesFront: filesFront,
        filesAwalSegel: filesAwalSegel,
        filesDispenserAwalPengisian: filesDispenserAwalPengisian,
        filesPengisianTangkiFull: filesPengisianTangkiFull,
        filesDispenserAkhirPengisian: filesDispenserAkhirPengisian,
        filesSegelBaru: filesSegelBaru,
        filesNota: filesNota,
      ),
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeBbmController;

    return SizedBox(
      height: Get.height * .85,
      child: Obx(() {
        if (controller.isLoadingDialog.value) {
          return const LoadingView();
        }

        return BbmContent(
          homeController: homeController,
          isPreviewMode: isPreviewMode,
          isiAwal: isiAwal,
          inputNopol: inputNopol,
          date: date,
          desc: desc,
          rit: rit,
          routeRit: routeRit,
          filesFront: filesFront,
          filesAwalSegel: filesAwalSegel,
          filesDispenserAwalPengisian: filesDispenserAwalPengisian,
          filesPengisianTangkiFull: filesPengisianTangkiFull,
          filesDispenserAkhirPengisian: filesDispenserAkhirPengisian,
          filesSegelBaru: filesSegelBaru,
          filesNota: filesNota,
        );
      }),
    );
  }
}
