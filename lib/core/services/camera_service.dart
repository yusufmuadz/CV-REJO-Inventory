import 'dart:io';

import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

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
        ResolutionPreset.low,
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

  // TAKE PICTURE BARU

  Future<String?> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return null;
    }

    if (isTakingPicture.value) return null;

    try {
      isTakingPicture.value = true;

      final XFile file = await cameraController!.takePicture();

      // Sembunyikan preview kamera
      isInitialized.value = false;

      await Future.delayed(const Duration(milliseconds: 100));

      // Dispose kamera
      await cameraController?.dispose();
      cameraController = null;

      // Baca foto asli
      final originalBytes = await file.readAsBytes();

      debugPrint(
        'Original Size: ${(originalBytes.length / 1024).toStringAsFixed(2)} KB',
      );

      // Decode gambar
      final decodedImage = img.decodeImage(originalBytes);

      if (decodedImage == null) {
        return file.path;
      }

      // Perbaiki orientasi berdasarkan EXIF
      final orientedImage = img.bakeOrientation(decodedImage);

      // Resize jika lebar lebih dari 1280 px
      final resizedImage = orientedImage.width > 1280
          ? img.copyResize(orientedImage, width: 1280)
          : orientedImage;

      // Kompres menjadi JPEG quality 80
      final compressedBytes = img.encodeJpg(resizedImage, quality: 70); // 90, 80, 70, 60

      // Jika hasil kompresi lebih besar, gunakan file asli
      if (compressedBytes.length >= originalBytes.length) {
        debugPrint('Menggunakan foto original karena lebih kecil.');
        return file.path;
      }

      // Simpan hasil kompresi
      final compressedFile = File('${file.path}.compressed.jpg');

      await compressedFile.writeAsBytes(compressedBytes, flush: true);

      debugPrint(
        'Compressed Size: ${(compressedBytes.length / 1024).toStringAsFixed(2)} KB',
      );

      debugPrint('Resolution: ${resizedImage.width} x ${resizedImage.height}');

      return compressedFile.path;
    } catch (e) {
      debugPrint('Error ambil foto: $e');
      return null;
    } finally {
      isTakingPicture.value = false;
    }
  }

  // TAKE PICTURE LAMA

  // Future<String?> takePicture() async {
  //   if (cameraController == null || !cameraController!.value.isInitialized) {
  //     return null;
  //   }
  //   if (isTakingPicture.value) return null;

  //   try {
  //     isTakingPicture.value = true;
  //     XFile file = await cameraController!.takePicture();

  //     // 💡 KUNCI UTAMA: Ubah status inisialisasi ke FALSE terlebih dahulu!
  //     // Ini akan memicu UI (Obx) untuk menyembunyikan CameraPreview secara instan.
  //     isInitialized.value = false;

  //     // Beri jeda sangat singkat agar UI sempat berganti ke widget Loading
  //     await Future.delayed(const Duration(milliseconds: 100));

  //     // 💡 SOLUSI AGRESIF ANTI-LAG:
  //     // Langsung dispose & reset status kamera dari dalam Service sebelum file dikembalikan
  //     await cameraController?.dispose();
  //     cameraController = null;

  //     final bytes = await file.readAsBytes();

  //     debugPrint("Foto berhasil diambil: ${file.path}");
  //     debugPrint("Foto Size: ${(bytes.length / 1024).toStringAsFixed(2)} KB");

  //     return file.path;
  //   } catch (e) {
  //     debugPrint("Error ambil foto: $e");
  //     return null;
  //   } finally {
  //     isTakingPicture.value = false;
  //   }
  // }

  @override
  void onClose() {
    cameraController?.dispose();
    cameraController = null;
    isInitialized.value = false;
    super.onClose();
  }
}
