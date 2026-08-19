import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../../../../core/result/result_custom.dart';
import '../../../../core/services/dialog_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../ending_order/domain/usecases/ending_order_usecase.dart';
import '../../../rit_information/domain/params/trouble_rit_param.dart';
import '../../../rit_information/presentation/controllers/enums/enum_trouble.dart';
import '../../domain/entities/rit_constraint_entity.dart';
import '../../domain/usecases/get_home_usecase.dart';
import 'home_controller.dart';

class HomeRITController extends GetxController {
  final GetHomeUseCase homeUseCase;
  final EndingOrderUseCase endingOrderUseCase;

  HomeRITController({
    required this.homeUseCase,
    required this.endingOrderUseCase,
  });

  final isLoading = false.obs;

  final dialogService = Get.find<DialogService>();
  final locationService = LocationService();

  final ritConstraints = <RitConstraintEntity>[].obs;
  final listTakeItTransaction = <RitConstraintEntity>[].obs;

  HomeController get masterController => Get.find<HomeController>();

  void addConstraint({
    required String title,
    required String nominal,
    required String solution,
    required DateTime date,
    required String status,
    required String description,
    List<XFile>? mediaFileList = const [],
  }) async {
    debugPrint('RIT: ${masterController.rit.value}');
    if (masterController.rit.isEmpty) {
      // if (Get.isBottomSheetOpen == true) Get.back();
      Future.delayed(const Duration(milliseconds: 50), () {
        dialogService.showErrorSnackbar(
          title: 'Gagal!',
          'Belum ada RIT yang diambil',
        );
      });
      return;
    }

    debugPrint('mediaFileList: $mediaFileList');

    if (mediaFileList == null ||
        title.isEmpty ||
        nominal.isEmpty ||
        solution.isEmpty) {
      Future.delayed(const Duration(milliseconds: 50), () {
        dialogService.showErrorSnackbar(
          title: 'Gagal!',
          'Masukkan semua data yang diperlukan',
        );
      });
      return;
    }
    isLoading.value = true;

    try {
      final position = await locationService.getLatestLocationLightweight();

      final lat = position.latitude.toString();
      final long = position.longitude.toString();

      final result = await endingOrderUseCase.callPendingOrderDriver(
        ParamsTroubleRIT(
          noRIT: masterController.rit.value,
          tanggalRIT: masterController.tanggalRit.value,
          troubleRIT: EnumTroubleRIT.tolak,
          titleTrouble: title,
          solution: solution,
          nominal: nominal.replaceAll(',', ''),
          date: date,
          status: status,
          desc: description,
          lat: lat,
          long: long,
          images: mediaFileList,
        ),
      );

      switch (result) {
        case Success():
          // debugPrint('Data Item Product: $data');
          ritConstraints.add(
            RitConstraintEntity(
              titleTrouble: title,
              nominal: nominal.replaceAll(',', ''),
              solution: solution,
              date: date,
              status: status,
              desc: description,
              mediaFileList: mediaFileList,
            ),
          );
          Future.delayed(const Duration(milliseconds: 50), () {
            dialogService.showDialogBox(
              title: 'Success',
              description: 'Berhasil Menyimpan Kendala',
              onPressed: () {
                if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
                  // Get.back();
                  Get.back();
                }
              },
            );
          });

        case ErrorResult(:final message):
          if (Get.isBottomSheetOpen == true) Get.back();
          dialogService.showError('Failed', message);
      }
    } catch (e) {
      if (Get.isBottomSheetOpen == true) Get.back();
      dialogService.showError('Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void addTakeIt({
    required DateTime date,
    required String status,
    required String description,
    List<XFile>? mediaFileList,
  }) async {
    listTakeItTransaction.add(
      RitConstraintEntity(
        date: date,
        status: status,
        desc: description,
        mediaFileList: mediaFileList ?? [],
      ),
    );
  }
}
