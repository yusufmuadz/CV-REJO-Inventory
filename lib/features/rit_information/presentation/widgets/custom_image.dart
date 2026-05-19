import 'package:cv_rejo/features/rit_information/presentation/widgets/custom_grid_image.dart';
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

  Widget contentImage({
    int? maxImage,
    required RxList<XFile> mediaFileList,
    required RitController controller,
  }) {
    return CustomGridImage(
      maxImage: maxImage ?? 2,
      mediaFileList: mediaFileList,
      controller: controller,
    );
  }
}
