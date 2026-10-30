import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../core/middlewares/app_role.dart';
import '../../../../shared/custom/custom_button.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../utils/loading_custom.dart';
import '../../../../shared/images/custom_image.dart';
import '../controllers/ending_order_controller.dart';
import '../controllers/enums/enum_button.dart';
import '../widgets/field_input_loader_widget.dart';
import '../widgets/field_input_widget.dart';
import '../widgets/input_pending_widget.dart';
import 'collector_arrive.dart';
import 'driver_arrive.dart';

class EndingOrderView extends GetView<EndingOrderController> {
  const EndingOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Foto & Keterangan'),
          elevation: 1,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingView();
          }

          if (AppRole.isCollector || controller.isDriverCollector.value) {
            return CollectorArrive(controller: controller);
          }

          if ((AppRole.isDriver &&
              controller.statusDriver.value == 'completed')) {
            return DriverArrive(controller: controller);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Visibility(
                visible: !_isImageProduct(),
                child: FieldInputLoaderWidget(controller: controller),
              ),
              FieldInputWidget(controller: controller),
              const SizedBox(height: 16),
              Visibility(
                visible: _isImageProduct(),
                child: CustomImage().buildContentImage(
                  title: 'Barang',
                  mediaFileList: controller.mediaFileList,
                ),
              ),
              // ImageInputWidget(controller: controller),
            ],
          );
        }),
        bottomNavigationBar: Obx(() {
          if (controller.isLoading.value) {
            return const SizedBox.shrink();
          }
          // if (AppRole.isDriver &&
          //     controller.statatusDriver.value == 'completed') {
          //   return CustomButton.bottomBarStyle(child: _buildButtonSave());
          // }

          if (AppRole.isCollector ||
              (AppRole.isDriver && controller.isDriverCollector.value)) {
            if (controller.statusButton.value == EnumButtonEndingOrder.savePO) {
              return CustomButton.bottomBarStyle(child: _buildButtonSave());
            }

            return _buildButtonSavePaymentCollector(context: context);
          }

          return CustomButton.bottomBarStyle(child: _buildButtonSelect());
        }),
      ),
    );
  }

  bool _isImageProduct() {
    if (AppRole.isChecker2 &&
        controller.statusChecker2.value == 'completed' &&
        controller.jenisArmada.value.toLowerCase() == 'external') {
      return false;
    }

    return true;
  }

  Widget _buildButtonSelect() {
    String titlePending = 'Pending PO';

    if (AppRole.isDriver && controller.statusDriver.value == 'completed') {
      titlePending = 'Kendala PO';
    }
    return CustomButton.doubleButton(
      title1: titlePending,
      title2: 'Simpan PO',
      color1: Colors.redAccent,
      color2: const Color(0xFF2ED471),
      onPressed1: () {
        if (AppRole.isDriver) {
          InputPendingWidget.inputReason(controller: controller);
          return;
        }

        // if (AppRole.isChecker2 &&
        //     controller.statusChecker2.value == 'completed' &&
        //     !controller.formKey.currentState!.validate()) {
        //   debugPrint('error');
        //   return;
        // }

        controller.pendingProduct();
      },
      onPressed2: () {
        if (AppRole.isDriver) {
          controller.savePoDriver();
          return;
        }

        if (_isImageProduct() && controller.formKey.currentState != null) {
          if (!controller.formKey.currentState!.validate()) {
            debugPrint('error');
            return;
          }
        }

        controller.saveOrder();
      },
    );
  }

  Widget _buildButtonSave() {
    return CustomButton.basicButton(
      title: 'Simpan',
      color: const Color(0xFF2ED471),
      onPressed: () {
        if (controller.statusButton.value ==
            EnumButtonEndingOrder.saveCollectorInv) {
          controller.savePaymentCollector();
          return;
        }
        // controller.saveDummyCollector();
        // controller.resetInv();
        controller.saveArriveCollector();
      },
    );
  }

  Widget _buildButtonSavePaymentCollector({required BuildContext context}) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: CustomButton.bottomBarStyle(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: !controller.statusPaymentInv.value,
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.only(bottom: keyboardHeight),

                child: _buildFieldNote(
                  title: 'Note Khusus',
                  textEditingController: controller.fieldController,
                ),
              ),
            ),
            Visibility(
              visible: keyboardHeight == 0,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: Get.width,
                child: _buildButtonSave(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldNote({
    required String title,
    required TextEditingController textEditingController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            style: TextStyle(
              color: Color(0xFF171717),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 0,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SharedTextField(
          // maxLines: 4,
          controller: textEditingController,
          textStyle: const TextStyle(
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: Color(0xFF171717),
          ),
          contentPadding: const EdgeInsets.all(12),
          hintStyle: const TextStyle(
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            color: Color(0xFF9FA2B4),
          ),
          hintText: 'Note khusus untuk pengingat penagihan jika diperlukan',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ],
    );
  }
}
