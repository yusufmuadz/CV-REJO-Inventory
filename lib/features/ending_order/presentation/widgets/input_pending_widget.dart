import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/middlewares/app_role.dart';
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
        height: Get.height * 0.7,
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
                Divider(height: 20, color: Colors.grey.shade200),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 0.0,
                  children: controller.pendingReason.map((status) {
                    final isSelected =
                        controller.pendingReasonSelected.value ==
                        status['name'];

                    return FilterChip(
                      label: Text(status['name'] as String),
                      selected: isSelected,
                      onSelected: (bool p1) {
                        if (isSelected && status['isSelected'] == true) {
                          status['isSelected'] = false;
                          controller.pendingReasonSelected.value = '';
                          return;
                        }

                        status['isSelected'] = p1;

                        controller.pendingReasonSelected.value = status['name']
                            .toString();
                        // controller.pendingReason.refresh();
                      },
                      selectedColor: const Color(0xFFc7a16d),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: isSelected ? Colors.transparent : Colors.grey,
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                    );
                  }).toList(),
                ),
                Visibility(
                  visible: controller.pendingReasonSelected.value == 'Lainnya',
                  child: SharedTextField(
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
                ),
                const SizedBox(height: 23),
                CustomImage().buildTitle(title: 'Alasan', isNotOptional: false),
                const SizedBox(height: 10),
                CustomImage().buildContentImage(
                  title: 'Alasan',
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
                      final reasonSelected = controller
                          .pendingReasonSelected
                          .value
                          .trim();
                      final customReason = controller.fieldController.text
                          .trim();

                      if (reasonSelected.isEmpty) {
                        controller.dialogService.showErrorSnackbar(
                          'Pilih salah satu alasan kendala!',
                        );
                        return;
                      }

                      if (reasonSelected == 'Lainnya' && customReason.isEmpty) {
                        controller.dialogService.showErrorSnackbar(
                          'Masukkan alasan kendala terlebih dahulu!',
                        );
                        return;
                      }

                      controller.pendingPoDriver();

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
