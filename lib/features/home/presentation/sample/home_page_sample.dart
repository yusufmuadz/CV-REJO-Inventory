import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomePageSample extends GetView<HomeController> {
  const HomePageSample({super.key});

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
        // HomeView(controller: controller),
        // CustomBottomBarScreen(),
        // HomeViewNewSample(),
        // ProfileView(controller: controller),
      ],
    );
  }
}