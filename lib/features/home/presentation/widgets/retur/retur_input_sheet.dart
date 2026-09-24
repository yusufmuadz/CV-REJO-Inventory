import 'package:cv_rejo/features/home/presentation/controllers/home_retur_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/loading_custom.dart';
import 'retur_content.dart';

class ReturInputSheet extends StatelessWidget {
  final HomeReturController controller;

  const ReturInputSheet({super.key, required this.controller});

  static void show({required HomeReturController controller}) {
    Get.bottomSheet(
      ReturInputSheet(controller: controller),
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
    return SizedBox(
      height: Get.height * .85,
      child: Obx(() {
        if (controller.isLoadingRetur.value) {
          return const LoadingView();
        }

        return ReturContent(controller: controller);
      }),
    );
  }
}
