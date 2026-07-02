import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';

import '../../core/services/camera_service.dart';

class CameraScreen extends GetView<CameraControllerService> {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initCamera();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Ambil Foto', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        // MENAMBAHKAN TOMBOL FLASH DI BARIS APPBAR
        actions: [
          Obx(() {
            // Jika kamera belum siap, jangan tampilkan tombol flash dulu
            if (!controller.isInitialized.value) return const SizedBox();

            IconData flashIcon;
            Color iconColor;

            if (controller.currentFlashMode.value == FlashMode.torch) {
              flashIcon = Icons.flash_on; // Ikon lampu menyala
              iconColor = Colors
                  .yellow; // Berwarna kuning menandakan lampu sedang aktif
            } else {
              flashIcon = Icons.flash_off; // Ikon lampu mati
              iconColor = Colors.white38; // Redup
            }

            // // Menentukan ikon berdasarkan mode aktif
            // switch (controller.currentFlashMode.value) {
            //   case FlashMode.always:
            //     flashIcon = Icons.flash_on;
            //     iconColor = Colors.yellow; // Kuning menandakan aktif
            //     break;
            //   case FlashMode.auto:
            //     flashIcon = Icons.flash_auto;
            //     iconColor = Colors.white;
            //     break;
            //   default:
            //     flashIcon = Icons.flash_off;
            //     iconColor = Colors.white38; // Redup menandakan mati
            // }

            return IconButton(
              icon: Icon(flashIcon, color: iconColor),
              onPressed: () {
                controller.toggleFlash(); // Memicu pergantian mode
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (!controller.isInitialized.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 15),
                Text(
                  'Menyiapkan Kamera...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            Center(child: CameraPreview(controller.cameraController!)),

            if (controller.isTakingPicture.value)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),

            // Tombol Jepret Foto
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: InkWell(
                  onTap: () async {
                    String? path = await controller.takePicture();
                    if (path != null) {
                      Get.back(result: path);
                    }
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
