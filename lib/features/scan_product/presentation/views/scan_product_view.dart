import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/loading_custom.dart';
import '../controllers/scan_product_controller.dart';
import '../widgets/dialog_scan_product/open_order_dialog.dart';
import '../widgets/dialog_scan_product/search_product_dialog.dart';
import '../widgets/scanner_error_widget.dart';
import '../widgets/scanner_overlay_widget.dart';

class ScanProductView extends GetView<ScanProductController> {
  const ScanProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        // ⛔ cegah NaN
        if (width == 0 || height == 0) {
          return const SizedBox();
        }

        final scanWindow = Rect.fromCenter(
          center: Offset(width / 2, height / 2 - 100),
          width: 350,
          height: 150,
        );

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leadingWidth: 55,
            leading: InkWell(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.only(left: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              Container(
                width: 40, // Adjusted width
                height: 40, // Adjusted height
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Obx(
                  () => InkWell(
                    child: Icon(
                      controller.isLightOn.value
                          ? Icons.flash_on_outlined
                          : Icons.flash_off_outlined,
                    ),
                    onTap: () {
                      controller.toggleFlashLight();
                    },
                  ),
                ),
              ),
              Visibility(
                visible: !AppRole.isChecker2,
                child: Container(
                  width: 40, // Adjusted width
                  height: 40, // Adjusted height
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 5),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: InkWell(
                    child: Image.asset(
                      Assets.icons.orderan.path,
                      height: 23,
                      width: 23,
                    ),
                    onTap: () async {
                      openPesanan(controller: controller);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Stack(
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return const LoadingView();
                }
                return MobileScanner(
                  fit: BoxFit.fill,
                  controller: controller.controllerScanner,
                  scanWindow: scanWindow,
                  errorBuilder: (context, error) {
                    debugPrint('Error while scanning: $error');
                    // throw error; // Rethrow the error to be caught by the parent widget
                    return ScannerErrorWidget(error: error);
                  },
                  overlayBuilder: (context, constraints) {
                    return const Padding(
                      padding: EdgeInsets.only(
                        bottom: 0.00,
                        left: 10,
                        right: 10,
                      ),
                    );
                  },
                );
              }),
              CustomPaint(painter: ScannerOverlay(scanWindow: scanWindow)),
            ],
          ),
          floatingActionButton: AppRole.isChecker2
              ? null
              : FloatingActionButton(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.search, color: Colors.black),
                  onPressed: () {
                    if (controller.controllerScanner.value.isRunning) {
                      controller.stopScanner();
                    }
                    showSearchProduct();
                  },
                ),
        );
      },
    );
  }
}
