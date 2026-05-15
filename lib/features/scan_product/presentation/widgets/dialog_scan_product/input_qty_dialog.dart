import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../utils/loading_custom.dart';
import '../../controllers/scan_product_controller.dart';

Future<void> openInputQtyDialog({
  required String itemName,
  required String barcodeValue,
  required ScanProductController controller,
}) async {
  await Future.delayed(const Duration(milliseconds: 300));

  await Get.dialog(
    // barrierDismissible: false,
    ContentInputDialog(
      itemName: itemName,
      barcodeValue: barcodeValue,
      controller: controller,
    ),
  );
}

class ContentInputDialog extends StatelessWidget {
  final ScanProductController controller;
  final String itemName;
  final String barcodeValue;
  final qtyController = TextEditingController();

  ContentInputDialog({
    super.key,
    required this.itemName,
    required this.barcodeValue,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Center(
          child: Text(
            'Masukkan Jumlah Barang',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
          ),
        ),
        actionsPadding: EdgeInsets.only(top: 20, bottom: 10, right: 20),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 26.0, 20.0, 0.0),
        content: Obx(() {
          if (controller.isLoadingProduct.value) {
            return SizedBox(height: 50, width: 50, child: const LoadingView());
          }

          if (controller.messageProduct.isNotEmpty) {
            return SizedBox(
              height: 50,
              child: Text(
                controller.messageProduct.value,
                textAlign: TextAlign.center,
              ),
            );
          }
          return SingleChildScrollView(
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
        actions: [
          Visibility(
            visible: true,
            child: TextButton(
              onPressed: () {
                if (controller.isMaxFailureChecker.value) {
                  controller.onTapHubungiAdmin();
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
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, // Warna teks & ikon
                backgroundColor: Colors.redAccent[100], // Warna latar belakang
                disabledForegroundColor: Colors.grey, // Warna saat disabled
                disabledBackgroundColor: Colors.blue[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Obx(
                () => Text(
                  controller.isMaxFailureChecker.value
                      ? 'Hubungi Admin'
                      : controller.messageProduct.isEmpty
                      ? 'Batal'
                      : controller.messageProduct.isNotEmpty &&
                            !controller.statusPostProduct.value
                      ? 'Ulangi'
                      : 'Kembali',
                ),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible:
                  !controller.isLoadingProduct.value &&
                  controller.messageProduct.isEmpty,
              child: TextButton(
                onPressed: () {
                  if (qtyController.text.isEmpty &&
                      controller.mediaFileList.isEmpty) {
                    return;
                  }

                  controller.addProduct(
                    barcode: barcodeValue,
                    quantity: qtyController.text,
                  );
                  // qtyController.clear();
                  // controller.startScanner(); // Mulai ulang pemindaian
                  // Get.back(); // Tutup dialog
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, // Warna teks & ikon
                  backgroundColor: Color(0xFF2ED471), // Warna latar belakang
                  disabledForegroundColor: Colors.grey, // Warna saat disabled
                  disabledBackgroundColor: Colors.blue[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text('Tambah'),
              ),
            ),
          ),
        ],
      ),
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
