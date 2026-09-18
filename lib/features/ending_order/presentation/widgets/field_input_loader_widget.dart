import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../shared/images/custom_image.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../controllers/ending_order_controller.dart';

class FieldInputLoaderWidget extends StatelessWidget {
  final EndingOrderController controller;

  const FieldInputLoaderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(title: 'Masukkan Kendaraan/Nopol*'),
            const SizedBox(height: 10),
            SharedTextField(
              radius: 8,
              isDense: true,
              controller: controller.extNopolTransportion,
              hintText: 'jenis kendaraan/nopol',
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              textStyle: TextStyles.basicTextStyle(
                height: 1.5,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
              ),
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Masukkan Kendaraan/Nopol Kendaraan';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTitle(title: 'Masukkan Nama Driver*'),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: SharedTextField(
                radius: 8,
                isDense: true,
                controller: controller.extDriverName,
                hintText: 'nama driver',
                fillColor: const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                textStyle: TextStyles.basicTextStyle(
                  height: 1.5,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                  fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                ),
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Masukkan Nama Driver';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            CustomImage().buildContentImage(
              title: 'Muatan/Semua barang',
              mediaFileList: controller.mediaFileList,
            ),
            const SizedBox(height: 10),
            CustomImage().buildContentImage(
              maxImage: 1,
              title: 'Kendaraan',
              mediaFileList: controller.mediaFileListTransportation,
            ),
            const SizedBox(height: 10),
            CustomImage().buildContentImage(
              maxImage: 1,
              title: 'Surat Jalan/Invoice',
              mediaFileList: controller.mediaFileListInfoInvoice,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Text(
      title,
      style: TextStyles.basicTextStyle(
        color: Color(0xFF171717),
        fontSize: 15,
        fontFamily: GoogleFonts.inter().fontFamily,
        fontWeight: FontWeight.w600,
        height: 0,
        letterSpacing: 0.48,
      ),
    );
  }
}
