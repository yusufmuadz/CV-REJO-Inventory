import 'dart:io';

import 'package:cv_rejo/shared/custom/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'navigation_service.dart';

class DialogService {
  DialogService();

  /// ===== BASIC SNACKBAR =====
  SnackbarController showSnackbar({
    required String title,
    required String message,
    Color? backgroundColor,
  }) {
    return Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
    );
  }

  /// ===== BASIC DIALOG =====
  Future<void> showDialogBox({
    required String title,
    required String description,
    String buttonText = 'OK',
    bool barrierDismissible = true,
    Function()? onPressed,
  }) {
    return Get.defaultDialog(
      title: title,
      barrierDismissible: barrierDismissible,
      content: PopScope(
        canPop: false,
        child: Text(description, textAlign: TextAlign.center),
      ),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Get.back(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// ===== CONFIRM DIALOG =====
  // Future<bool> showConfirmation({
  //   required String title,
  //   required String description,
  //   String confirmText = 'Yes',
  //   String cancelText = 'No',
  // }) async {
  //   final result = await showDialog<bool>(
  //     context: _context!,
  //     builder: (_) => AlertDialog(
  //       title: Text(title),
  //       content: Text(description),
  //       actions: [
  //         TextButton(
  //           onPressed: () => _navigationService.pop(false),
  //           child: Text(cancelText),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => _navigationService.pop(true),
  //           child: Text(confirmText),
  //         ),
  //       ],
  //     ),
  //   );

  //   return result ?? false;
  // }

  /// ===== LOADING =====
  void showLoading({String message = 'Loading...'}) {
    Get.defaultDialog(
      barrierDismissible: false,
      title: '',
      titlePadding: EdgeInsets.zero,
      content: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message, style: TextStyle(color: Colors.grey.shade600)),
            ],
          ),
        ),
      ),
    );
  }

  void hideLoading() {
    // _navigationService.pop();
  }

  /// ===== ERROR =====
  Future<void> showError(
    String title,
    String message, {
    Function()? onPressed,
  }) {
    return showDialogBox(
      title: title,
      description: message,
      onPressed: onPressed,
    );
  }

  /// ===== SUCCESS =====
  Future<void> showSuccess(String message) {
    return showDialogBox(title: 'Success', description: message);
  }

  /// ===== SNACKBAR SUCCESS =====
  SnackbarController showSuccessSnackbar(String message) {
    return showSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
    );
  }

  /// ===== SNACKBAR ERROR =====
  SnackbarController showErrorSnackbar(
    String message, {
    String title = 'Error',
  }) {
    return showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.red,
    );
  }

  /// ===== SNACKBAR INFO =====
  SnackbarController showInfoSnackbar(String title, String message) {
    return showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
    );
  }

  Future<void> handleExit() {
    return Get.dialog(
      AlertDialog(
        title: const Text('Alert'),
        content: const Text('Apakah anda yakin untuk keluar'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Tidak')),
          TextButton(
            onPressed: () {
              exit(0);
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  Future<void> inputDialog({
    required String title,
    double height = 0.45,
    bool singleButton = false,
    EdgeInsetsGeometry? padding,
    String titleButton1 = 'Batal',
    String titleButton2 = 'Simpan',
    Color color1 = const Color(0xFFc7a16d),
    Color color2 = const Color(0xFF2ED471),
    VoidCallback? onPressed1,
    VoidCallback? onPressed2,
    required Widget content,
  }) {
    return Get.defaultDialog(
      radius: 10,
      title: title,
      titlePadding: const EdgeInsets.only(top: 20),
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      contentPadding: padding ?? const EdgeInsets.fromLTRB(15, 22, 15, 10),
      content: SizedBox(height: Get.height * height, child: content),
      confirm: SizedBox(
        height: 45,
        width: double.infinity,
        child: _builtButton(
          title1: titleButton1,
          title2: titleButton2,
          singleButton: singleButton,
          color1: color1,
          color2: color2,
          onPressed1: onPressed1,
          onPressed2: onPressed2,
        ),
      ),
    );
  }

  Widget _builtButton({
    required bool singleButton,
    required String title1,
    required String? title2,
    required Color color1,
    required Color? color2,
    VoidCallback? onPressed1,
    VoidCallback? onPressed2,
  }) {
    if (singleButton) {
      return CustomButton.basicButton(
        title: title1,
        color: color1,
        onPressed: () => onPressed1 ?? Get.back(),
      );
    }

    return CustomButton.doubleButton(
      title1: title1,
      title2: title2!,
      color1: color1,
      color2: color2!,
      onPressed1: onPressed1 ?? () => Get.back(),
      onPressed2: onPressed2 ?? () => Get.back(),
    );
  }
}
