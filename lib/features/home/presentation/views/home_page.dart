import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile/presentation/views/profile_view.dart';
import 'home_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          controller.dialogService.handleExit(),
      child: Scaffold(body: Stack(children: [_buildPage()])),
    );
  }

  Widget _buildPage() {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HomeView(controller: controller),
        ProfileView(controller: controller),
      ],
    );
  }

  Widget _buildButtonBottom() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: Obx(() {
        if (controller.indexPage.value == 0) return const SizedBox.shrink();
        return InkWell(
          onTap: () => controller.changePage(0),
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFc6017b),
            ),
            child: Obx(() {
              return SizedBox(
                height: 60,
                width: 60,
                child: controller.indexPage.value == 1
                    ? const Icon(Icons.home, size: 32, color: Colors.white)
                    : const Icon(
                        Icons.qr_code_scanner,
                        size: 32,
                        color: Colors.white,
                      ),
              );
            }),
          ),
        );
      }),
    );
  }
}
