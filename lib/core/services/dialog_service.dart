import 'dart:io';

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
        child: Text(description),
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
  SnackbarController showErrorSnackbar(String message) {
    return showSnackbar(
      title: 'Error',
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
}
