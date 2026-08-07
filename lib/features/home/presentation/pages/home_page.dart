import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../profile/presentation/views/profile_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import '../views/home_view.dart';
import '../views/rit_contsraint_view.dart';
import '../views/take_it_order_view.dart';
import '../views/home_tracking_driver_view.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          controller.dialogService.handleExit(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppRole.isDriver || AppRole.isChecker1
            ? Color(0xFFf5f0fa)
            : AppColors.backgroundMint,
        body: _buildPage(),
        bottomNavigationBar: Obx(() {
          if (controller.isKeyboardOpen.value) return const SizedBox();
          return CustomButton.bottomBarIcon(controller: controller);
        }),
      ),
    );
  }

  Widget _buildPage() {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) => controller.tabIndex.value = value,
      children: [
        HomeView(controller: controller),
        // ListOrderPage(),
        if (AppRole.isChecker2 || AppRole.isPIC)
          HomeTrackingDriverView(homeController: controller),
        if (AppRole.isDriver) RitConstraint(controller: controller),
        if (AppRole.isDriver) TakeItOrderView(controller: controller),
        ProfileView(controller: controller),
      ],
    );
  }
}
