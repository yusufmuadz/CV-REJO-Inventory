import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/custom/custom_button.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/presentation/controllers/enums/button_inv_enum.dart';
import '../controllers/home_controller.dart';
import '../widgets/home_app_bar/app_bar_widget.dart';
import '../widgets/home_collector_driver/content_arrive_popup_widget.dart';
import '../widgets/home_collector_driver/list_invoice_widget.dart';

class HomeCollectorDriverView extends StatelessWidget {
  final HomeController homeController;
  const HomeCollectorDriverView({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeCollectorController;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBarWidget().content(
            title: 'Kolektor',
            isActionIcon: false,
            controller: homeController,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SharedListInvView(
              isGetLoading: controller.isGetLoading,
              getLoadState: controller.getLoadState,
              isSelectedRoute: controller.isSelectedRoute,
              listInv: controller.listInv,
              buttonINV: controller.buttonINV,
              searchInvController: controller.searchInvController,
              routeStackService: homeController.routeStackService,
              dialogService: homeController.dialogService,
              onSubmitted: (String p1) {},
              onSuffixTap: () {},
              onCheckboxChanged: (int value) => controller.onSelectedInv(value),
              retryFetch: () => controller.retryFetch(),
            ),
          ),
          Obx(
            () => CustomButton.bottomBarStyle(
              child: SizedBox(
                height: 40,
                width: Get.width,
                child: _buildButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    final dataController = homeController.homeCollectorController;

    if (dataController.getLoadState.value == LoadState.idle) {
      return const SizedBox.shrink();
    }

    if (dataController.buttonINV.value == EnumButtonInv.buttonSaveDoc) {
      return _buildButtonArriveAtOffice();
    }

    return _buildButtonAcceptInv();
  }

  Widget _buildButtonAcceptInv() {
    return CustomButton.basicButton(
      title: 'Terima Invoice',
      color: const Color(0xFF2ED471),
      onPressed: () async {
        final dataController = homeController.homeCollectorController;

        final allChecked = dataController.listInv.every(
          (element) => element.isChecked == true,
        );

        if (!allChecked) {
          homeController.dialogService.showErrorSnackbar(
            title: 'Warning!',
            'Pilih semua invoice terlebih dahulu',
          );
          return;
        }

        final newListInv = dataController.listInv
            .map((element) => element.copyWith(isChecked: false))
            .toList();

        dataController.listInv.value = newListInv;

        dataController.buttonINV.value = EnumButtonInv.buttonSaveDoc;
      },
    );
  }

  Widget _buildButtonArriveAtOffice() {
    // final controller = homeController.homeCollectorController;

    return CustomButton.basicButton(
      title: 'Sampai Kantor',
      color: const Color(0xFF8B97F3),
      onPressed: () async {
        homeController.dialogService.showSidePopup(
          width: 1,
          child: ContentArrivePopupWidget(homeController: homeController),
        );
        // final dataController = homeController.homeCollectorController;

        // dataController.buttonINV.value = EnumButtonInv.buttonSaveDoc;

        // controller.pageIndex.value = 2;
        // controller.pageController.animateToPage(
        //   2,
        //   duration: const Duration(milliseconds: 300),
        //   curve: Curves.easeInOut,
        // );
      },
    );
  }
}
