import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/collector/shared_arrive_at_office.dart';
import '../../../../../shared/custom/custom_button.dart';
import '../../../../list_order/presentation/controllers/enums/button_inv_enum.dart';
import '../../controllers/home_controller.dart';
import '../home_app_bar/app_bar_widget.dart';

class ContentArrivePopupWidget extends StatelessWidget {
  final HomeController homeController;
  const ContentArrivePopupWidget({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    final controller = homeController.homeCollectorController;

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          AppBarWidget().content(
            title: 'Sampai Kantor',
            isWithoutLeadingIcon: true,
            controller: homeController,
            icon: Icons.cancel_outlined,
            onTap: () => Get.back(),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SharedArriveAtOffice(
              isDriverCollector: true,
              recipientName: controller.recipientName,
              kmController: controller.kmController,
              mediaFileList: controller.mediaFileList,
              mediaFileListKM: controller.mediaFileListKM,
              mediaFileListTangki: controller.mediaFileListTangki,
              mediaFileListSJ: controller.mediaFileListSJ,
              mediaFileListTransportMoney:
                  controller.mediaFileListTransportMoney,
              mediaFileRecipientMoneyRit: controller.mediaFileRecipientMoneyRit,
              mediaFileRecipientBox: controller.mediaFileRecipientBox,
              mediaFileFrontTransport: controller.mediaFileFrontTransport,
              mediaFileBackTransport: controller.mediaFileBackTransport,
              mediaFileLeftTransport: controller.mediaFileLeftTransport,
              mediaFileRightTransport: controller.mediaFileRightTransport,
            ),
          ),
          CustomButton.bottomBarStyle(
            child: SizedBox(
              height: 40,
              width: Get.width,
              child: _buildButtonSaveDoc(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonSaveDoc() {
    return CustomButton.basicButton(
      title: 'Simpan',
      color: const Color(0xFF2ED471),
      onPressed: () async {
        final dataController = homeController.homeCollectorController;

        dataController.buttonINV.value = EnumButtonInv.acceptINV;

        Get.back();
      },
    );
  }
}
