import 'package:cv_rejo/features/detail_order/presentation/controllers/detail_order_controller.dart';
import 'package:flutter/material.dart';

import '../../../../../core/middlewares/app_role.dart';

class AssistantDialog {
  static void detailAssistant(DetailOrderController controller) {
    controller.dialogService.inputDialog(
      title: 'Detail Asisten',
      titleButton1: 'Kembali',
      height: 0.30,
      singleButton: true,
      contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailTextAssistant(
              title: 'Nama Driver',
              value: controller.driverSelected.value,
            ),
            const SizedBox(height: 23),
            _buildDetailTextAssistant(
              title: 'Nama Kenek',
              value: controller.assistantSelected.value,
            ),
            const SizedBox(height: 23),
            _buildDetailTextAssistant(
              title: 'Kendaraan',
              value: controller.selectTransportation.value,
            ),
            Visibility(
              visible: AppRole.isChecker2,
              child: Container(
                margin: const EdgeInsets.only(top: 23),
                child: _buildDetailTextAssistant(
                  title: 'Nopol Kendaraan',
                  value: controller.nopolTransportation.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDetailTextAssistant({
  required String title,
  required String value,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(
        width: 110,
        child: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(
        width: 10,
        child: Text(
          ':',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      Expanded(
        child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}
