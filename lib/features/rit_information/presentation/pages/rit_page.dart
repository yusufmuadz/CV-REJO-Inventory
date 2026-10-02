import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../../../home/presentation/controllers/home_bbm_controller.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../list_order/presentation/controllers/list_order_controller.dart';
import '../controllers/rit_controller.dart';
import '../controllers/enums/enum_rit.dart';
import '../widgets/rit_dialog.dart';
import '../widgets/rit_dialog_info_po.dart';
import '../views/arrive_at_office.dart';
import '../views/input_image_view.dart';
import '../views/rit_view.dart';

class RitPage extends GetView<RitController> {
  const RitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            final dateFormat = DateFormat('dd MMMM yyyy');
            String dateTime = dateFormat.format(DateTime.now());

            if (controller.tanggalRit.value != '') {
              dateTime = dateFormat.format(
                DateTime.parse(controller.tanggalRit.value),
              );
            }

            if (controller.buttonRIT.value == EnumButtonRIT.buttonSaveDoc) {
              return Text(
                'Sampai Kantor',
                style: TextStyles.basicTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                  color: const Color(0xFF1F2937),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail RIT - ${controller.isDistrictSelected.value}',
                  style: TextStyles.basicTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                Text(
                  dateTime,
                  style: TextStyles.basicTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            );
          }),
          elevation: 1,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              final route = controller.routeFrom.value;

              if ((controller.isAcceptRIT.value && route == 'listOrder') ||
                  route == 'endingOrder') {
                debugPrint(
                  '🚨 BEFORE NAV '
                  'currentRoute=${Get.currentRoute} '
                  'routing=${Get.routing.current}',
                );
                debugPrint('CURRENT ROUTE: ${Get.currentRoute}');
                debugPrint('IS HOME: ${Get.currentRoute == Routes.HOME}');
                debugNavigation('BEFORE HOME');
                // if (Get.isRegistered<ListOrderController>()) {
                //   Get.delete<ListOrderController>(force: true);
                // }
                // Get.offAllNamed(Routes.HOME);
                Get.until((route) => route.settings.name == Routes.HOME);

                // final hasHome = Get.routing.routeStack.any(
                //   (route) => route.name == Routes.HOME,
                // );

                // if (hasHome) {
                //   Get.until((route) => route.settings.name == Routes.HOME);
                // } else {
                //   Get.offAllNamed(Routes.HOME);
                // }

                debugPrint(
                  '🚨 AFTER NAV '
                  'currentRoute=${Get.currentRoute} '
                  'routing=${Get.routing.current}',
                );
                debugPrint('📚 CURRENT ROUTE: ${Get.currentRoute}');
                debugPrint('📚 ROUTING: ${Get.routing}');
                Future.delayed(const Duration(milliseconds: 500), () {
                  debugNavigation('500ms AFTER HOME');
                });
                Future.delayed(const Duration(seconds: 2), () {
                  debugPrint(
                    '⏱️ 2 DETIK SETELAH HOME '
                    'currentRoute=${Get.currentRoute}',
                  );

                  debugPrint(
                    'HOME REGISTERED: ${Get.isRegistered<HomeController>()}',
                  );

                  debugPrint(
                    'BBM REGISTERED: ${Get.isRegistered<HomeBbmController>()}',
                  );
                });
                return;
              }
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          if (controller.loadState.value == LoadState.initial) {
            return const LoadingView();
          }
          return _buildPage();
        }),
        bottomNavigationBar: Obx(() {
          if (controller.loadState.value == LoadState.initial ||
              controller.orders.isEmpty ||
              controller.isArrive.value ||
              // controller.buttonRIT.value == EnumButtonRIT.saveChangePO ||
              controller.buttonRIT.value == EnumButtonRIT.buttonSaveRitDoc ||
              controller.buttonRIT.value == EnumButtonRIT.cancelRIT) {
            return const SizedBox.shrink();
          }
          return CustomButton.bottomBarStyle(child: _buildButton());
        }),
      ),
    );
  }

  void debugNavigation(String label) {
    debugPrint('========== $label ==========');

    debugPrint('Current route: ${Get.currentRoute}');
    debugPrint('Previous route: ${Get.previousRoute}');
    debugPrint('Routing current: ${Get.routing.current}');
    debugPrint('Routing previous: ${Get.routing.previous}');
  }

  Widget _buildPage() {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        RitView(controller: controller),
        InputImageView(controller: controller),
        ArriveAtOffice(controller: controller),
      ],
    );
  }

  Widget _buildButton() {
    final buttonRIT = controller.buttonRIT.value;

    if (controller.isLoading.value) {
      return const LoadingView();
    }

    // if (buttonRIT == EnumButtonRIT.buttonChangePO) {
    //   return _buildButtonChangePO();
    // }

    // if (buttonRIT == EnumButtonRIT.buttonConfirmChangePO) {
    //   return _buildButtonConfirmChangePO();
    // }

    if (buttonRIT == EnumButtonRIT.buttonArriveRIT) {
      return _buildShowButtonArrive();
    }
    if (buttonRIT == EnumButtonRIT.acceptRIT) {
      return _buildButtonSelect();
    }
    if (buttonRIT == EnumButtonRIT.buttonSaveDoc) {
      return _buildButtonArriveSafeDoc();
    }

    return CustomButton.basicButton(
      title: controller.pageIndex.value == 0 ? 'Keberangkatan' : 'Simpan',
      color: controller.pageIndex.value == 0
          ? const Color(0xFFd5914d)
          : const Color(0xFF2ED471),
      onPressed: () {
        debugPrint('Pilih Pesanan');
        // controller.saveOrderDummy();
        if (controller.pageIndex.value == 0) {
          controller.pageIndex.value = 1;
          controller.pageController.jumpToPage(1);
        } else {
          controller.saveOrder();
        }
      },
    );
  }

  Widget _buildButtonSelect() {
    return CustomButton.doubleButton(
      title1: 'Tolak',
      title2: 'Terima',
      color1: Colors.redAccent[100]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () => RitDialog().inputReason(controller: controller),
      onPressed2: () => controller.acceptRit(),
    );
  }

  Widget _buildShowButtonArrive() {
    return CustomButton.doubleButton(
      title1: 'Retur',
      title2: 'Sampai Kantor',
      color1: Colors.redAccent[200]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () {
        // controller.dialogService.showErrorSnackbar(
        //   title: 'Warning!',
        //   'Coming Soon',
        // );
        RitDialog().inputRetur(controller: controller);
      },
      onPressed2: () {
        // controller.dialogService.showErrorSnackbar(
        //   title: 'Warning!',
        //   'Coming Soon',
        // );
        // controller.isSave.value = false;
        // controller.isArriveInput.value = true;
        controller.buttonRIT.value = EnumButtonRIT.buttonSaveDoc;
        controller.pageIndex.value = 2;
        controller.pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  Widget _buildButtonChangePO() {
    return CustomButton.basicButton(
      title: 'Ubah Urutan PO',
      color: const Color.fromARGB(255, 58, 175, 225),
      onPressed: () {
        controller.buttonRIT.value = EnumButtonRIT.buttonConfirmChangePO;
      },
    );
  }

  Widget _buildButtonConfirmChangePO() {
    return CustomButton.doubleButton(
      title1: 'Batal',
      title2: 'Konfirmasi',
      color1: Colors.redAccent[200]!,
      color2: const Color(0xFF8B97F3),
      onPressed1: () {
        controller.cancelSelection();
        controller.buttonRIT.value = EnumButtonRIT.buttonChangePO;
      },
      onPressed2: () {
        final hasEmptyNumber = controller.orders.any(
          (e) => e.number.value == 0,
        );

        if (hasEmptyNumber) {
          controller.dialogService.showErrorSnackbar(
            title: 'Warning!',
            'Pilih PO yang ingin diurutkan terlebih dahulu',
          );
          return;
        }
        RitDialogInfoPo().confirmPO(controller: controller);
      },
    );
  }

  Widget _buildButtonArriveSafeDoc() {
    return CustomButton.basicButton(
      title: 'Simpan',
      color: const Color(0xFF2ED471),
      onPressed: () => controller.saveOrder(),
    );
  }
}
