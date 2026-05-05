import 'package:cv_rejo/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile/presentation/views/profile_view.dart';
import '../sample/home_view_new_sample.dart';
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
        // HomeViewNewSample(),
        ProfileView(controller: controller),
      ],
    );
  }
}
