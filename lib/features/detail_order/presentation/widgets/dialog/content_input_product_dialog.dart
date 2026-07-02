import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../shared/text_field/textfield_shared.dart';
import '../../../../../utils/loading_custom.dart';
import '../../../../../shared/images/custom_image.dart';

class ContentInputProductDialog extends StatelessWidget {
  final String itemName;
  final String barcodeValue;
  final TextEditingController qtyController;
  final RxList<XFile> mediaFileList;
  final String messageProduct;
  final bool isInputQty;
  final bool isLoadingProduct;

  const ContentInputProductDialog({
    super.key,
    required this.itemName,
    required this.barcodeValue,
    required this.mediaFileList,
    required this.messageProduct,
    required this.isLoadingProduct,
    required this.qtyController,
    this.isInputQty = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingProduct) {
      return SizedBox(height: 50, width: 50, child: const LoadingView());
    }

    if (messageProduct.isNotEmpty) {
      return SizedBox(
        height: 70,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(messageProduct, textAlign: TextAlign.center),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBoxIconText(
            title: 'NAMA BARANG',
            value: itemName,
            icon: Icons.inventory_2_outlined,
          ),
          _buildBoxIconText(
            title: 'JUMLAH',
            isField: true,
            icon: Icons.calculate_outlined,
          ),
          const Divider(thickness: 1, height: 30, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 10),
          _buildImageView(),
        ],
      ),
    );
  }

  Widget _buildImageView() {
    return CustomImage().buildContentImage(
      title: 'Barang',
      mediaFileList: mediaFileList,
    );
  }

  Widget _buildBoxIconText({
    required String title,
    required IconData icon,
    String value = '',
    bool isField = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFFEC5B13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.basicTextStyle(
                    height: 1.5,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                Visibility(
                  visible: !isField,
                  child: Text(
                    value,
                    style: TextStyles.basicTextStyle(
                      height: 1.5,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    ),
                  ),
                ),
                Visibility(
                  visible: isField,
                  child: Container(
                    height: 38,
                    margin: const EdgeInsets.only(top: 2),
                    child: SharedTextField(
                      readOnly: !isInputQty,
                      radius: 8,
                      controller: qtyController,
                      hintText: 'Masukkan Jumlah',
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      textStyle: TextStyles.basicTextStyle(
                        height: 1.5,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1F2937),
                        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
