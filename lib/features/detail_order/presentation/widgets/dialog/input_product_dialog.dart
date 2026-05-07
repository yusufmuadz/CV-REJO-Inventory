import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../utils/loading_custom.dart';
import '../../controllers/detail_order_controller.dart';

Future<bool?> openInputFieldDialog({
  required String itemName,
  required String qty,
  required String barcodeValue,
  required DetailOrderController controller,
}) async {
  await Future.delayed(const Duration(milliseconds: 300));

  final result = await Get.dialog(
    barrierDismissible: false,
    ContentInputDialog(
      itemName: itemName,
      qty: qty,
      barcodeValue: barcodeValue,
      controller: controller,
    ),
  );

  return result;
}

class ContentInputDialog extends StatelessWidget {
  final DetailOrderController controller;
  final String itemName;
  final String barcodeValue;
  final String qty;
  final descController = TextEditingController();

  ContentInputDialog({
    super.key,
    required this.itemName,
    required this.qty,
    required this.barcodeValue,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text(
          'Informasi Barang',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
        ),
        titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
        actionsPadding: EdgeInsets.only(top: 10, bottom: 10, right: 20),
        content: SizedBox(
          height: Get.height * 0.3,
          width: double.maxFinite,
          child: Obx(() {
            if (controller.isLoadingProduct.value) {
              return const SizedBox(
                height: 50,
                width: 50,
                child: LoadingView(),
              );
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

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildText(title: 'Nama Barang', value: itemName),
                const SizedBox(height: 5),
                _buildText(title: 'Qty', value: qty),
                const SizedBox(height: 30),
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
            );
          }),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: () {
                if (controller.messageProduct.isNotEmpty) {
                  controller.messageProduct.value = '';
                  return;
                }
                controller.isLoadingProduct.value = false;
                Get.back(result: false); // Tutup dialog
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
              child: Text(
                controller.messageProduct.value.isEmpty ? 'Batal' : 'Ulangi',
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible:
                  !controller.isLoadingProduct.value &&
                  controller.messageProduct.value.isEmpty,
              child: TextButton(
                onPressed: () {
                  controller.addProduct(barcode: barcodeValue, quantity: qty);
                  // controller.startScanner(); // Mulai ulang pemindaian
                  // Get.back(result: true); // Tutup dialog
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
                child: const Text('Tambah'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText({required String title, required String value}) {
    return Row(
      children: [
        SizedBox(
          width: 85,
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        Text(' :  ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
    // Text.rich(
    //   TextSpan(
    //     text: '$title: ',
    //     style: const TextStyle(fontWeight: FontWeight.w600),
    //     children: [
    //       TextSpan(
    //         text: value,
    //         style: const TextStyle(fontWeight: FontWeight.normal),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildImageView() {
    return Obx(
      () => GridView.builder(
        primary: false,
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
