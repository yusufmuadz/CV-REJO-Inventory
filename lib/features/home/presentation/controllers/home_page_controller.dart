import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
import 'home_controller.dart';

class HomePageController extends GetxController {
  HomeController get masterController => Get.find<HomeController>();

  void changePage(int index) {
    try {
      debugPrint(
        'PageController: ${masterController.pageController.hashCode}, '
        'hasClients=${masterController.pageController.hasClients}, '
        'positions=${masterController.pageController.positions.length}',
      );

      // pageController.jumpToPage(index);
      // _changeStatusBar(index);
      masterController.getCacheSize(index);
      masterController.pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (e, stackTrace) {
      debugPrint('Error button page => ${e.toString()}');
      debugPrint('Error button page stack => ${stackTrace}');
      // masterController.dialogService.defaultDialog(title: 'ERROR', content: );
    }
  }

  void _changeStatusBar(int index) {
    bool isDark = true;

    if ((AppRole.isDriver && index > 2) || (!AppRole.isDriver && index == 1)) {
      isDark = false;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Untuk Android
        statusBarIconBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarBrightness: isDark
            ? Brightness.light
            : Brightness.dark, // Untuk iOS
      ),
    );
  }
}
