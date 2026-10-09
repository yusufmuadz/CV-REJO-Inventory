import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../../../home/presentation/controllers/home_bbm_controller.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../../list_order/presentation/controllers/enums/button_inv_enum.dart';
import '../../../list_order/presentation/controllers/list_order_controller.dart';
import '../views/list_inv_route_view.dart';
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

            String label =
                'Detail RIT - ${controller.isDistrictSelected.value}';

            if (controller.tanggalRit.value != '') {
              dateTime = dateFormat.format(
                DateTime.parse(controller.tanggalRit.value),
              );
            }

            if (AppRole.isCollector) {
              label = 'Invoice Hari Ini';
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
                  label,
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

              if (controller.pageIndex.value != 0 &&
                  controller.pageIndex.value != 3) {
                if (AppRole.isCollector) {
                  controller.pageIndex.value = 3;
                } else {
                  controller.pageIndex.value = 0;
                }

                controller.pageController.jumpToPage(
                  controller.pageIndex.value,
                );

                debugPrint('Pilih Pesanan');
                return;
              }

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
                // Get.until((route) => route.settings.name == Routes.HOME);

                // final hasHome = Get.routing.routeStack.any(
                //   (route) => route.name == Routes.HOME,
                // );

                if (controller.routeStackService.contains(Routes.HOME)) {
                  Get.until((route) => route.settings.name == Routes.HOME);
                } else {
                  Get.offAllNamed(Routes.HOME);
                }

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

          if (AppRole.isCollector) {
            return CustomButton.bottomBarStyle(child: _buildButtonInv());
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
        ListInvRouteView(masterCtrlr: controller),
      ],
    );
  }

  Widget _buildButton() {
    final buttonRIT = controller.buttonRIT.value;

    if (controller.isLoading.value) {
      return const LoadingView();
    }

    if (buttonRIT == EnumButtonRIT.buttonChangePO) {
      return _buildButtonChangePO();
    }

    if (buttonRIT == EnumButtonRIT.buttonConfirmChangePO) {
      return _buildButtonConfirmChangePO();
    }

    if (buttonRIT == EnumButtonRIT.buttonArriveRIT) {
      return _buildShowButtonArrive();
    }
    if (buttonRIT == EnumButtonRIT.acceptRIT) {
      return _buildButtonSelect();
    }
    if (buttonRIT == EnumButtonRIT.buttonSaveDoc) {
      return _buildButtonArriveSafeDoc();
    }

    return _buildButtonTakeOffSave();
  }

  Widget _buildButtonTakeOffSave() {
    String title = 'Keberangkatan';
    Color color = const Color(0xFFd5914d);

    if (controller.pageIndex.value != 0 && controller.pageIndex.value != 3) {
      title = 'Simpan';
      color = const Color(0xFF2ED471);
    }

    return CustomButton.basicButton(
      title: title,
      color: color,
      onPressed: () {
        debugPrint('Pilih Pesanan');
        // controller.saveOrderDummy();

        if (controller.pageIndex.value == 0 ||
            controller.pageIndex.value == 3) {
          controller.pageIndex.value = 1;
              // controller.resetSortingSisipan();
          controller.pageController.jumpToPage(1);
        } else {
          if (AppRole.isCollector) {
            controller.saveOrderDummy();
          } else {
            controller.saveOrder();
          }
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
      onPressed: () {
        if (AppRole.isCollector) {
          controller.saveOrderDummy();
          return;
        }
        controller.saveOrder();
      },
    );
  }

  ////////=====COLLECTOR=====////////

  Widget _buildButtonInv() {
    if (controller.loadState.value == LoadState.initial) {
      return const SizedBox.shrink();
    }

    final dataController = controller.invController;

    if (dataController.buttonINV.value == EnumButtonInv.takeOff) {
      return _buildButtonTakeOffSave();
    }

    if (dataController.buttonINV.value == EnumButtonInv.saveTakeOff) {
      return _buildButtonArriveAtOffice();
    }

    if (dataController.buttonINV.value == EnumButtonInv.buttonSaveDoc) {
      return _buildButtonArriveSafeDoc();
    }

    if (dataController.listInv.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildButtonAcceptInv();
  }

  Widget _buildButtonAcceptInv() {
    return CustomButton.basicButton(
      title: 'Terima Invoice',
      color: const Color(0xFF2ED471),
      onPressed: () async {
        final dataController = controller.invController;

        final allChecked = dataController.listInv.every(
          (element) => element.isChecked == true,
        );

        if (!allChecked) {
          controller.dialogService.showErrorSnackbar(
            title: 'Warning!',
            'Pilih semua invoice terlebih dahulu',
          );
          return;
        }

        final newListInv = dataController.listInv
            .map((element) => element.copyWith(isChecked: false))
            .toList();

        dataController.listInv.value = newListInv;

        dataController.buttonINV.value = EnumButtonInv.takeOff;
      },
    );
  }

  Widget _buildButtonArriveAtOffice() {
    if (controller.loadState.value == LoadState.initial) {
      return const SizedBox.shrink();
    }

    return CustomButton.basicButton(
      title: 'Sampai Kantor',
      color: const Color(0xFF2ED471),
      onPressed: () async {
        final dataController = controller.invController;

        dataController.buttonINV.value = EnumButtonInv.buttonSaveDoc;

        controller.pageIndex.value = 2;
        controller.pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }
}
