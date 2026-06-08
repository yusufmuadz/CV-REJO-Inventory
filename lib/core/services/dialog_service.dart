import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../shared/custom/custom_button.dart';
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
  Future<bool> showConfirmation({
    required String title,
    required String description,
    String confirmText = 'Yes',
    String cancelText = 'No',
    Function()? onConfirm,
    Function()? onCancel,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ikon Trash + Warning
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Ionicons.trash_outline, size: 40, color: Colors.red),
            ),
            SizedBox(height: 20),

            // Judul
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),

            // Deskripsi
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
            SizedBox(height: 24),

            // Tombol Batal & Hapus
            Row(
              children: [
                Expanded(
                  child: CustomButton.basicOutlinedButton(
                    title: cancelText,
                    textColor: Colors.black,
                    side: BorderSide(color: Colors.grey[300]!, width: 1),
                    onPressed: onCancel ?? () => Get.back(),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: CustomButton.basicButton(
                    title: confirmText,
                    color: Color(0xFFDC2626),
                    onPressed:
                        onConfirm ??
                        () {
                          Get.back();
                          Get.back();
                        },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return result ?? false;
  }

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
    bool singleButton = true,
    String titleButton1 = 'Kembali',
    String titleButton2 = 'Hubungi Admin',
    VoidCallback? onPressed1,
    VoidCallback? onPressed2,
  }) {
    return defaultDialog(
      height: 0.15,
      title: title,
      onPressed1: onPressed1,
      onPressed2: onPressed2,
      singleButton: singleButton,
      titleButton1: titleButton1,
      titleButton2: titleButton2,
      barrierDismissible: false,
      color1: Colors.red,
      color2: const Color(0xFF0c8ce8),
      actionsPadding: const EdgeInsets.all(16),
      content: PopScope(
        canPop: false,
        child: Center(
          child: SingleChildScrollView(
            child: Text(message, textAlign: TextAlign.center),
          ),
        ),
      ),
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

  /// ===== HANDLE EXIT =====

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

  /// ===== DEFAULT DIALOG =====

  Future<void> defaultDialog({
    required String title,
    required Widget content,
    EdgeInsets? insetPadding,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? titleStyle,
    double height = 0.45,
    double width = 1,
    bool singleButton = false,
    String titleButton1 = 'Batal',
    String titleButton2 = 'Simpan',
    Color color1 = const Color(0xFFc7a16d),
    Color color2 = const Color(0xFF2ED471),
    VoidCallback? onPressed1,
    VoidCallback? onPressed2,
    EdgeInsetsGeometry? marginButton,
    bool barrierDismissible = true,
    List<Widget>? actions,
  }) {
    return Get.dialog(
      barrierDismissible: barrierDismissible,
      AlertDialog(
        insetPadding:
            insetPadding ?? EdgeInsets.all(30), // ⬅️ Hapus padding luar
        contentPadding:
            contentPadding ?? EdgeInsets.all(16), // Padding dalam konten
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Opsional: sudut kotak
        ),
        actionsPadding: actionsPadding ?? const EdgeInsets.all(10),
        titlePadding: titlePadding ?? const EdgeInsets.all(16),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style:
              titleStyle ??
              const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
        ),
        content: SizedBox(
          height: Get.height * height,
          width: Get.width * width,
          child: content,
        ),
        actions:
            actions ??
            [
              SizedBox(
                height: 45,
                width: double.infinity,
                child: _buildButton(
                  title1: titleButton1,
                  title2: titleButton2,
                  singleButton: singleButton,
                  color1: color1,
                  color2: color2,
                  onPressed1: onPressed1,
                  onPressed2: onPressed2,
                ),
              ),
            ],
      ),
    );
  }

  /// ===== INPUT DIALOG =====

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
    TextStyle? titleStyle,
    EdgeInsetsGeometry? marginButton,
    required Widget content,
  }) {
    return Get.defaultDialog(
      radius: 10,
      title: title,
      titlePadding: const EdgeInsets.only(top: 20),
      titleStyle:
          titleStyle ??
          const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
      contentPadding: padding ?? const EdgeInsets.fromLTRB(15, 22, 15, 10),
      content: SizedBox(height: Get.height * height, child: content),
      confirm: Container(
        height: 45,
        width: double.infinity,
        margin: marginButton,
        child: _buildButton(
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

  /// ===== BUILD BUTTON =====

  Widget _buildButton({
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
        onPressed: onPressed1 ?? () => Get.back(),
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
