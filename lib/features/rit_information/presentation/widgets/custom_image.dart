import 'dart:io';

import 'package:cv_rejo/features/rit_information/presentation/widgets/custom_grid_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/rit_controller.dart';

class CustomImage {
  Widget buildTitle({required String title}) {
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
        Text(
          '*Upload minimal 1 foto',
          style: GoogleFonts.hankenGrotesk(
            color: Colors.red,
            fontSize: 11,
            fontWeight: FontWeight.w400,
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
          : () =>
                controller.selectImage(ImageSource.camera, null, mediaFileList),
      onRemove: (int index) =>
          controller.removeImage(index, null, mediaFileList, isTransportation),
    );
  }

  Widget displayImage({required String path, Function()? onTap}) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
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
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
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
      ],
    );
  }
}
