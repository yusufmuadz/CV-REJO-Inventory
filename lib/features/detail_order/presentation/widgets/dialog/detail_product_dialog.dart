import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../shared/images/custom_image.dart';
import '../../../data/models/item_order_model.dart';
import '../../controllers/detail_order_controller.dart';

class DetailProductDialog {
  void popupDetailItem({
    ItemOrderModel? orderDetail,
    required DetailOrderController controller,
  }) {
    final idProduct = orderDetail?.barcode ?? '-';
    final nameProduct = orderDetail?.item ?? '-';
    final qty = orderDetail?.qty ?? '-';
    final location = orderDetail?.locationRack ?? '-';
    final images = orderDetail?.pic.images ?? [];
    final color = orderDetail?.color ?? '-';

    controller.dialogService.defaultDialog(
      height: 0.50,
      title: 'Detail Produk',
      onPressed2: () => Get.back(),
      singleButton: true,
      titleButton1: 'Oke',
      color1: const Color(0xFF8A5012),
      insetPadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      titlePadding: const EdgeInsets.only(top: 16),
      titleStyle: TextStyles.basicTextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
        color: const Color(0xFF8A5012),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1, height: 0, color: Color(0xFFE7EEFE)),
            Visibility(
              visible: !AppRole.isDriver,
              child: _buildBoxIconText(
                title: 'Kode Produk',
                value: idProduct,
                icon: Icons.fingerprint_outlined,
              ),
            ),

            _buildBoxIconText(
              title: 'Nama Produk',
              value: nameProduct,
              icon: Icons.inventory_2_outlined,
            ),

            Visibility(
              visible: !AppRole.isChecker1,
              child: _buildBoxIconText(
                title: 'Jumlah Produk',
                value: qty,
                icon: CupertinoIcons.cube_box,
              ),
            ),

            Visibility(
              visible: !AppRole.isDriver,
              child: _buildBoxIconText(
                title: 'Lokasi Simpan (Rak)',
                value: location,
                icon: Icons.shelves,
                isBox: AppRole.isPIC,
              ),
            ),

            _buildBoxIconText(
              title: 'Warna Produk',
              value: color,
              icon: Icons.palette_outlined,
              isBox: !AppRole.isPIC,
            ),

            Visibility(
              visible: AppRole.isPIC && controller.isFromHistory.value,
              child: _buildImageProduct(images: images),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageProduct({required List<dynamic> images}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBoxIconText(
          title: 'Foto Produk',
          value: '-',
          icon: Icons.photo_camera_outlined,
          isImage: true,
        ),
        GridView.builder(
          shrinkWrap: true,
          itemCount: images.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final image = images[index];

            if (image == null) {
              return Text('Gagal mengambil gambar');
            }

            return SizedBox(
              height: 120,
              width: 120,
              child: CustomImage().displayImageNetwork(
                path: image,
                isPreview: true,
                isPadding: false,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBoxIconText({
    required String title,
    required String value,
    required IconData icon,
    bool isBox = false,
    bool isImage = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: EdgeInsets.symmetric(horizontal: isBox ? 10 : 0, vertical: 12),
      decoration: isBox
          ? BoxDecoration(
              color: Color(0xFFE7EEFE),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
            )
          : null,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: isBox ? Colors.white : const Color(0xFFE7EEFE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF8A5012)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.basicTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    color: const Color(0xFF524439),
                  ),
                ),
                Visibility(visible: !isImage, child: const SizedBox(height: 3)),
                Visibility(
                  visible: !isImage,
                  child: Text(
                    value,
                    style: TextStyles.basicTextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                      color: const Color(0xFF151C27),
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
