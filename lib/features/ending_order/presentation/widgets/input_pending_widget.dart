import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/images/custom_image.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/ending_order_controller.dart';

class InputPendingWidget {
  static void inputReason({
    int? maxImage,
    required EndingOrderController controller,
  }) {
    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.6,
        child: Obx(() {
          if (controller.isLoadingReason.value) {
            return const LoadingView();
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(15, 22, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Masukkan Alasan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 15),
                SharedTextField(
                  isDense: true,
                  maxLines: 4,
                  controller: controller.fieldController,
                  hintText: 'Masukkan alasan pending PO...',
                  contentPadding: const EdgeInsets.all(12),
                  validator: (String? p1) {
                    if (p1 == null || p1.isEmpty) {
                      return 'Masukkan alasan terlebih dahulu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 23),
                CustomImage().buildTitle(title: 'Alasan', isNotOptional: false),
                const SizedBox(height: 10),
                CustomImage().buildContentImage(
                  title: 'Alasan(Optional)',
                  maxImage: maxImage,
                  mediaFileList: controller.mediaFileList,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton.basicButton(
                    title: 'Kirim',
                    color: const Color(0xFF2ED471),
                    onPressed: () {
                      if (controller.fieldController.text.isEmpty) {
                        controller.dialogService.showErrorSnackbar(
                          'Masukkan Alasan',
                        );
                        return;
                      }

                      controller.pendingProduct();

                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
