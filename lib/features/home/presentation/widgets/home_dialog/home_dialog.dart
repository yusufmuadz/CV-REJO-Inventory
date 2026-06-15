import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controllers/home_controller.dart';
import 'home_content_input_dialog.dart';

class HomeDialog {
  ////// ====== POPUP INPUT ====== //////
  static void popupInput({
    String? title,
    String? nominal,
    String? date,
    String? desc,
    List<XFile>? files,
    required isPreviewMode,
    required HomeController controller,
  }) {
    final titleProductController = TextEditingController(text: title);
    final nominalProductController = TextEditingController(text: nominal);
    final descProductController = TextEditingController(text: desc);
    final mediaFileList = <XFile>[].obs;

    if (files != null && files.isNotEmpty) {
      mediaFileList.value = mediaFileList;
    }

    date ??= DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

    Get.bottomSheet(
      HomeContentInputDialog(
        date: date,
        isPreviewMode: isPreviewMode,
        mediaFileList: mediaFileList,
        titleProductController: titleProductController,
        nominalProductController: nominalProductController,
        descProductController: descProductController,
        onPressedSave: () {
          controller.addConstraint(
            title: titleProductController.text,
            nominal: nominalProductController.text,
            date: DateTime.now(),
            status: 'SELESAI',
            description: descProductController.text,
            mediaFileList: mediaFileList,
          );
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  ////// ====== POPUP INPUT TAKE IT TRANSACTION ====== //////
  static void popupInputTakeIt({
    String? date,
    String? desc,
    List<XFile>? files,
    required isPreviewMode,
    required HomeController controller,
  }) {
    final descProductController = TextEditingController(text: desc);
    final mediaFileList = <XFile>[].obs;

    if (files != null && files.isNotEmpty) {
      mediaFileList.value = mediaFileList;
    }

    date ??= DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now());

    Get.bottomSheet(
      HomeContentInputDialog(
        isTakeIt: true,
        date: date,
        isPreviewMode: isPreviewMode,
        mediaFileList: mediaFileList,
        descProductController: descProductController,
        onPressedSave: () {
          debugPrint('ADD TAKE IT');
          controller.addTakeIt(
            date: DateTime.now(),
            status: 'SELESAI',
            description: descProductController.text,
            mediaFileList: mediaFileList,
          );
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
