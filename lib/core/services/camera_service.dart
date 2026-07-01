import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraControllerService extends GetxController {
  CameraController? cameraController;
  final isInitialized = false.obs;
  final isTakingPicture = false.obs;

  // Rx untuk memantau status Flash Mode secara real-time
  final currentFlashMode = FlashMode.off.obs;

  Future<void> initCamera() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();

      // Atur flash default ke kondisi mati saat pertama dibuka
      await cameraController!.setFlashMode(FlashMode.off);
      currentFlashMode.value = FlashMode.off;

      isInitialized.value = true;
    } catch (e) {
      debugPrint("Error inisialisasi kamera: $e");
    }
  }

  // Fungsi untuk mengganti mode flash secara bergantian (Off -> On -> Auto)
  Future<void> toggleFlash() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    try {
      FlashMode nextMode;

      // Jika sekarang mati, saat diklik langsung pindah ke TORCH (cahaya langsung muncul)
      if (currentFlashMode.value == FlashMode.off) {
        nextMode = FlashMode
            .torch; // 💡 Kunci utama: Lampu senter langsung menyala konstan
      } else {
        nextMode = FlashMode.off; // Matikan lampu
      }

      // // Alur siklus tombol: Off -> On -> Auto -> Off kembali
      // if (currentFlashMode.value == FlashMode.off) {
      //   nextMode = FlashMode.always; // Nyala terus saat memotret
      // } else if (currentFlashMode.value == FlashMode.always) {
      //   nextMode = FlashMode.auto;   // Otomatis mendeteksi cahaya sekitar
      // } else {
      //   nextMode = FlashMode.off;    // Mati
      // }

      await cameraController!.setFlashMode(nextMode);
      currentFlashMode.value = nextMode; // Update status UI
    } catch (e) {
      debugPrint("Error mengubah mode flash: $e");
    }
  }

  Future<String?> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return null;
    }
    if (isTakingPicture.value) return null;

    try {
      isTakingPicture.value = true;
      XFile file = await cameraController!.takePicture();

      // 💡 KUNCI UTAMA: Ubah status inisialisasi ke FALSE terlebih dahulu!
      // Ini akan memicu UI (Obx) untuk menyembunyikan CameraPreview secara instan.
      isInitialized.value = false;

      // Beri jeda sangat singkat agar UI sempat berganti ke widget Loading
      await Future.delayed(const Duration(milliseconds: 100));

      // 💡 SOLUSI AGRESIF ANTI-LAG:
      // Langsung dispose & reset status kamera dari dalam Service sebelum file dikembalikan
      await cameraController?.dispose();
      cameraController = null;

      return file.path;
    } catch (e) {
      debugPrint("Error ambil foto: $e");
      return null;
    } finally {
      isTakingPicture.value = false;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    cameraController = null;
    isInitialized.value = false;
    super.onClose();
  }
}
