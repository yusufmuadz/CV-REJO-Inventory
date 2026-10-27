import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/rit/shared_card_rit.dart';
import '../../../../utils/loading_custom.dart';
import '../../../list_order/presentation/controllers/enums/button_inv_enum.dart';
import '../controllers/home_collector_controller.dart';
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Obx(() => _buildContent(controller: controller)),
            ),
          ),
          Obx(() {
            if (controller.getLoadState.value == LoadState.idle ||
                controller.isRoute.value) {
              return const SizedBox.shrink();
            }

            return CustomButton.bottomBarStyle(
              child: SizedBox(
                height: 40,
                width: Get.width,
                child: _buildButton(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent({required HomeCollectorController controller}) {
    if (controller.isRoute.value) {
      return _buildRouteList(controller: controller);
    }

    return SharedListInvView(
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
      onRefresh: () async {},
    );
  }

  Widget _buildRouteList({required HomeCollectorController controller}) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (BuildContext context, int index) {
        return SharedCardRIT(
          isSelected: false,
          totalPO: '5',
          noRIT: '${index + 1}',
          dateRIT: '',
          colorRIT: int.parse('0xC7C1CEE2'),
          routeRIT: [],
          isSelection: false.obs,
          onTap: () {
            controller.isRoute.value = false;
            // controller.getOrder(noRoute: '${index + 1}');
          },
          onTapSeePO: () {},
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemCount: 1,
    );
  }

  Widget _buildButton() {
    final dataController = homeController.homeCollectorController;

    // if (dataController.getLoadState.value == LoadState.idle) {
    //   return const SizedBox.shrink();
    // }

    if (dataController.buttonINV.value == EnumButtonInv.buttonSaveDoc) {
      return _buildButtonArriveAtOffice();
    }

    return _buildButtonAcceptInv(controller: dataController);
  }

  Widget _buildButtonAcceptInv({required HomeCollectorController controller}) {
    return CustomButton.doubleButton(
      title1: 'Pilih Rute',
      title2: 'Terima Invoice',
      color1: Colors.redAccent[100]!,
      color2: const Color(0xFF2ED471),
      onPressed1: () {
        controller.isRoute.value = true;
        // controller.getOrder();
      },
      onPressed2: () => controller.acceptInv(),
    );
    // CustomButton.basicButton(
    //   title: '',
    //   color: const Color(0xFF2ED471),
    //   onPressed: () async {
    //
    // );
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
