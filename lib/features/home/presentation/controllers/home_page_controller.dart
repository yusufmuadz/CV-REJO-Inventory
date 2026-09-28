import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../core/middlewares/app_role.dart';
import 'home_controller.dart';

class HomePageController extends GetxController {
  HomeController get masterController => Get.find<HomeController>();

  final listMenu = [
    {
      'icon': Ionicons.home_outline,
      'activeIcon': Ionicons.home,
      'label': 'Home',
      'onTap': () {},
      'isSelected': true,
    },
    {
      'icon': Ionicons.arrow_undo_circle_outline,
      'activeIcon': Ionicons.arrow_undo_circle,
      'label': 'Retur',
      'onTap': () {},
      'isSelected': false,
    },
    {
      'icon': Ionicons.alert_circle_outline,
      'activeIcon': Ionicons.alert_circle,
      'label': 'Kendala',
      'onTap': () {},
      'isSelected': false,
    },
    {
      'icon': Ionicons.reader_outline,
      'activeIcon': Ionicons.reader,
      'label': 'Pesanan',
      'onTap': () {},
      'isSelected': false,
    },
    {
      'icon': Ionicons.speedometer_outline,
      'activeIcon': Ionicons.speedometer,
      'label': 'Isi BBM',
      'onTap': () {},
      'isSelected': false,
    },
  ].obs;

  void selectMenu(int index) {
    for (var i = 0; i < listMenu.length; i++) {
      listMenu[i]['isSelected'] = i == index;
    }

    // listMenu[index]['isSelected'] = true;
    listMenu.refresh();
    changePage(index);
    // update();
  }

  void changePage(int index) {
    try {
      debugPrint(
        'PageController: ${masterController.pageController.hashCode}, '
        'hasClients=${masterController.pageController.hasClients}, '
        'positions=${masterController.pageController.positions.length}',
      );

      if (AppRole.isDriver && index == 1) {
        masterController.dialogService.showComingSoonSnackbar();
        return;
      }

      // pageController.jumpToPage(index);
      // _changeStatusBar(index);
      masterController.getCacheSize(index);
      masterController.pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      if (AppRole.isChecker2 &&
          masterController.homeTrackingDriverController.listOrder.isEmpty) {
        masterController.homeTrackingDriverController.onRefreshTransaction();
      }
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
