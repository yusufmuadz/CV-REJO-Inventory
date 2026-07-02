import 'package:cv_rejo/features/detail_order/presentation/widgets/content/content_info_customer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../shared/images/custom_image.dart';
import '../../controllers/detail_order_controller.dart';
import 'content_info_item_widget.dart';

class ContentDetailOrderWidget extends StatelessWidget {
  final DetailOrderController controller;
  const ContentDetailOrderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        Visibility(
          visible: AppRole.isChecker2,
          child: _buildBody(
            title: 'Status Pesanan',
            value: controller.statusLoader.value == 'completed'
                ? 'Complete'
                : controller.statusChecker2.value == 'completed'
                ? 'Leader'
                : 'Checker',
          ),
        ),
        _buildBody(
          title: 'ID Transaksi',
          value: AppRole.isDriver
              ? controller.orderDetail.value.suratJalan
              : controller.orderDetail.value.orderNo,
        ),
        _buildBoxStyle(
          vertical: 15,
          child: ContentInfoCustomerWidget(controller: controller),
        ),
        _buildBoxStyle(child: ContentInfoItemWidget(controller: controller)),
        Visibility(
          visible: controller.isFromHistory.value,
          child: _buildPreviewImage(),
        ),
      ],
    );
  }

  Widget _buildBoxStyle({required Widget child, double? vertical}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, right: 16, left: 16),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: vertical ?? 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xFFD7C3B4)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _buildIconStyle({required IconData icon}) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFFDF2F8),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFFEC4899)),
    );
  }

  Widget _buildBody({
    required String title,
    required String value,
    String pengiriman = '',
  }) {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyles.basicTextStyle(
                  color: const Color(0xFF7C7C7C),
                ),
              ),
              Text(
                value,
                textAlign: TextAlign.left,
                style: TextStyles.basicTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF171717),
                ),
              ),
            ],
          ),
          if (pengiriman.isNotEmpty) _buildShippingText(pengiriman),
        ],
      ),
    );
  }

  Widget _buildShippingText(String text) {
    final parts = text.split('-');

    return Container(
      width: 135,
      margin: const EdgeInsets.only(top: 5),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${parts[0]} ${parts.length > 1 ? "-" : ""} ',
              style: TextStyles.basicTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (parts.length > 1)
              TextSpan(
                text: parts[1],
                style: TextStyles.basicTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleIconText({required String title, required IconData icon}) {
    return Row(
      children: [
        _buildIconStyle(icon: icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyles.basicTextStyle(
            fontSize: 16,
            fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
            fontWeight: FontWeight.w600,
            color: Color(0xFF151C27),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewImage() {
    RxList<XFile> mediaFileList = <XFile>[].obs;

    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleIconText(
            title: 'Foto Semua Produk',
            icon: Icons.image_outlined,
          ),
          const SizedBox(height: 20),
          CustomImage().buildContentImage(
            readOnly: true,
            isPreview: true,
            isHistory: true,
            maxImage: mediaFileList.length,
            title: 'Semuanya',
            mediaFileList: mediaFileList,
          ),
        ],
      ),
    );
  }
}
