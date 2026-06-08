import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../routes/app_pages.dart';
import '../../../../../shared/custom/custom_button.dart';
import '../../../../../utils/loading_custom.dart';
import '../../controllers/scan_product_controller.dart';

Future<void> openInputQtyDialog({
  required String itemName,
  required String barcodeValue,
  required ScanProductController controller,
}) async {
  await Future.delayed(const Duration(milliseconds: 300));

  final qtyController = TextEditingController();
  controller.mediaFileList.clear();

  controller.dialogService.defaultDialog(
    height: 0.35,
    title: 'Masukkan Jumlah Barang',
    titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    actionsPadding: const EdgeInsets.fromLTRB(20, 0.5, 20, 10),
    contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
    content: ContentInputDialog(
      itemName: 'Halo',
      barcodeValue: '12345',
      controller: controller,
      qtyController: qtyController,
    ),
    actions: [
      Obx(() {
        String text1 = 'Batal';
        String text2 = 'Tambah';
        Color color1 = Colors.redAccent[100] ?? Colors.red;
        Color color2 = const Color(0xFF2ED471);

        if (controller.messageProduct.isNotEmpty &&
            !controller.statusPostProduct.value) {
          text1 = 'Ulangi';
        }

        if (AppRole.isChecker1 && controller.isMaxFailureChecker.value) {
          text1 = 'Kembali';
          text2 = 'Hubungi Admin';
          color1 = Colors.red;
          color2 = const Color(0xFF0c8ce8);
        }

        return _buildButton(
          title1: text1,
          title2: text2,
          color1: color1,
          color2: color2,
          visible:
              !controller.isLoadingProduct.value &&
              (controller.messageProduct.isEmpty ||
                  controller.isMaxFailureChecker.value),
          onPressed1: () {
            if (controller.isMaxFailureChecker.value) {
              final rit = GetStorage().read('city') ?? '';
              final colorRit = GetStorage().read('colorRit') ?? '';
              final tanggalRit = GetStorage().read('tanggalRit') ?? '';

              Get.toNamed(
                Routes.LIST_ORDER,
                arguments: {
                  'routeFrom': 'home',
                  'city': rit,
                  'colorRit': colorRit,
                  'tanggalRit': tanggalRit,
                },
              );
              return;
            }
            if (!controller.statusPostProduct.value &&
                controller.messageProduct.isNotEmpty) {
              controller.messageProduct.value = '';
              return;
            }

            Get.back(); // Tutup dialog
            qtyController.clear();
            controller.mediaFileList.clear();
            controller.messageProduct.value = '';
            controller.startScanner(); // Mulai ulang pemindaian
          },
          onPressed2: () {
            if (controller.isMaxFailureChecker.value) {
              controller.onTapHubungiAdmin();
              return;
            }

            if (qtyController.text.isEmpty &&
                controller.mediaFileList.isEmpty) {
              return;
            }

            controller.addProduct(
              barcode: barcodeValue,
              quantity: qtyController.text,
            );
          },
        );
      }),
    ],
  );
}

Widget _buildButton({
  required String title1,
  required String? title2,
  required Color color1,
  required Color? color2,
  bool visible = false,
  VoidCallback? onPressed1,
  VoidCallback? onPressed2,
}) {
  return CustomButton.doubleButton(
    title1: title1,
    title2: title2!,
    color1: color1,
    color2: color2!,
    onPressed1: onPressed1 ?? () => Get.back(),
    onPressed2: onPressed2 ?? () => Get.back(),
    visible2: visible,
    visibleSpace: visible,
  );
}

class ContentInputDialog extends StatelessWidget {
  final ScanProductController controller;
  final String itemName;
  final String barcodeValue;
  final TextEditingController qtyController;

  const ContentInputDialog({
    super.key,
    required this.itemName,
    required this.barcodeValue,
    required this.controller,
    required this.qtyController,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Obx(() {
        if (controller.isLoadingProduct.value) {
          return SizedBox(height: 50, width: 50, child: const LoadingView());
        }

        if (controller.messageProduct.isNotEmpty) {
          return SizedBox(
            height: 70,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                controller.messageProduct.value,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Nama Barang: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: itemName,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  hintText: '0',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Unggah Foto barang',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '*Upload minimal 1 foto untuk bukti',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              _buildImageView(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImageView() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: controller.mediaFileList.length + 1,
        itemBuilder: (context, index) {
          if (index < controller.mediaFileList.length) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.file(
                      File(controller.mediaFileList[index].path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => controller.removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (controller.mediaFileList.length < 2) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () => controller.selectImage(ImageSource.camera),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[200],
                  ),
                  child: const Center(
                    child: Icon(Icons.camera_alt_outlined, color: Colors.grey),
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
