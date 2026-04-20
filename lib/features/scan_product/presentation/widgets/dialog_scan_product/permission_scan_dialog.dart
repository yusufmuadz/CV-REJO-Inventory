import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPermissionScanDialog({required bool isPermanentlyDenied, Function()? onConfirm}) {
  Get.defaultDialog(
    title: 'Izin Kamera Diperlukan',
    middleText: isPermanentlyDenied
        ? 'Izin kamera telah dinonaktifkan permanen. Buka Settings untuk mengaktifkannya kembali.'
        : 'Aplikasi membutuhkan izin kamera untuk memindai barcode. Izinkan akses kamera?',
    textConfirm: isPermanentlyDenied ? 'Buka Settings' : 'Izinkan',
    textCancel: 'Batal',
    confirmTextColor: Colors.white,
    onConfirm: onConfirm,
    onCancel: () {
      Get.back();
      // Opsional: kembali ke halaman sebelumnya atau tampilkan placeholder
    },
    barrierDismissible: false, // User harus pilih opsi
  );
}
