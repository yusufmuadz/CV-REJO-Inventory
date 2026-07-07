import 'dart:io';

import 'package:cv_rejo/shared/images/custom_grid_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

import '../../core/services/dialog_service.dart';
import 'camera_screen.dart';
import '../../features/rit_information/presentation/controllers/rit_controller.dart';

class CustomImage {
  Widget buildTitle({required String title, bool isNotOptional = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unggah Foto $title',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.48,
          ),
        ),
        Visibility(
          visible: isNotOptional,
          child: Text(
            '*Upload minimal 1 foto',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.red,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget addImage({Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: const Color(0xFFffd8ab),
          strokeWidth: 1.5,
          padding: EdgeInsets.all(3),
          dashPattern: const [5, 3.5],
          strokeCap: StrokeCap.round,
          radius: const Radius.circular(10),
        ),
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFfffdfa),
          ),
          child: Center(
            child: Icon(
              Icons.camera_alt_outlined,
              color: const Color(0xFFfa913c),
            ),
          ),
        ),
      ),
    );
  }

  Widget contentImage({
    int? maxImage,
    bool isTransportation = false,
    Function()? onTap,
    required RxList<XFile> mediaFileList,
    required RitController controller,
  }) {
    return CustomGridImage(
      maxImage: maxImage ?? 2,
      mediaFileList: mediaFileList,
      plusLength: (isTransportation && mediaFileList.length == 4 ? 0 : 1),
      onAdd: isTransportation
          ? onTap
          : () => controller.selectImage(null, mediaFileList),
      onRemove: (int index) =>
          controller.removeImage(index, null, mediaFileList, isTransportation),
    );
  }

  Widget displayImage({
    required String path,
    bool isPreview = false,
    bool isPadding = true,
    Function()? onTapRemove,
  }) {
    return Stack(
      children: [
        InkWell(
          onTap: isPreview ? () => previewImage(path: path) : null,
          child: Padding(
            padding: !isPreview && isPadding
                ? const EdgeInsets.all(5.0)
                : EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Visibility(
          visible: !isPreview,
          child: Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: onTapRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContentImage({
    int? maxImage,
    bool isShadow = true,
    bool readOnly = false,
    bool isPreview = false,
    bool isHistory = false,
    required String title,
    required RxList<XFile> mediaFileList,
  }) {
    return _buildBoxStyle(
      isShadow: isShadow,
      child: Obx(() {
        if (isHistory && mediaFileList.isEmpty) {
          return const Center(child: Text('Coming soon'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: mediaFileList.isNotEmpty && !readOnly,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(child: CustomImage().buildTitle(title: title)),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () => clearAllImages(mediaFileList),
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
                  ],
                ),
              ),
            ),
            Visibility(
              visible: mediaFileList.isNotEmpty,
              child: CustomGridImage(
                isPreview: isPreview,
                maxImage: maxImage ?? 2,
                mediaFileList: mediaFileList,
                onAdd: () {
                  if (readOnly) return;
                  selectImage(null, mediaFileList);
                },
                onRemove: (int index) {
                  if (readOnly) return;
                  removeImage(index, null, mediaFileList);
                },
              ),
            ),
            Visibility(
              visible: mediaFileList.isEmpty,
              child: Row(
                children: [
                  addImage(
                    onTap: readOnly
                        ? null
                        : () {
                            selectImage(null, mediaFileList);
                          },
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: CustomImage().buildTitle(title: title)),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBoxStyle({required Widget child, bool isShadow = true}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFf4f4f5)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: !isShadow
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: child,
    );
  }

  void previewImage({required String path}) {
    final dialogService = Get.find<DialogService>();

    dialogService.defaultDialog(
      height: 0.35,
      title: 'Preview Image',
      singleButton: true,
      titleButton1: 'Kembali',
      content: Image.file(File(path), fit: BoxFit.cover),
    );
  }

  void selectImage(Rx<XFile>? file, RxList<XFile> files) async {
    // final picker = ImagePicker();

    try {
      // String? path = await cameraService.takePicture();
      final String? path = await Get.to(() => const CameraScreen());

      if (path != null) {
        if (file != null) {
          file.value = XFile(path);
        } else {
          files.add(XFile(path));
        }
      }
      // final pickedFile = await picker.pickImage(
      //   source: source, // Atau ImageSource.gallery untuk galeri
      //   imageQuality: 70,
      // );

      // if (pickedFile != null) {
      //   if (file != null) {
      //     file.value = pickedFile;
      //   } else {
      //     files.add(pickedFile);
      //   }
      //   // debugPrint('Image path: ${pickedFile.path}');
      // }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void removeImage(int index, Rx<XFile>? file, RxList<XFile> files) {
    if (file != null) {
      files.remove(file.value);
      file.value = XFile('');
      return;
    }

    if (index >= 0 && index < files.length) {
      files.removeAt(index);
    }
  }

  void clearAllImages(files) {
    files.clear();
  }
}
