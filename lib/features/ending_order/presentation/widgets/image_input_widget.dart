import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../controllers/ending_order_controller.dart';

class ImageInputWidget extends StatelessWidget {
  final EndingOrderController controller;

  const ImageInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Unggah Foto Barang',
            style: TextStyle(
              color: Color(0xFF171717),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 0,
              letterSpacing: 0.48,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '*Upload minimal 1 foto untuk bukti akhir transaksi',
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.mediaFileList.isNotEmpty,
              child: Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 10),
                child: InkWell(
                  onTap: () =>
                      controller.clearAllImages(controller.mediaFileList),
                  child: const Text(
                    'Hapus Semua',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Obx(
            () => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
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
                          onTap: () => controller.removeImage(
                            index,
                            controller.mediaFileList,
                          ),
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
                      onTap: () =>
                          controller.selectImage(controller.mediaFileList),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey[200],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
