import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../shared/images/custom_image.dart';
import '../../../../../utils/loading_custom.dart';
import '../../../data/models/item_order_model.dart';
import '../../controllers/detail_order_controller.dart';
import 'detail_product_dialog.dart';

class ContentInputAllProductDialog extends StatelessWidget {
  final Widget? button;
  final DetailOrderController controller;

  const ContentInputAllProductDialog({
    super.key,
    required this.controller,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 30),
                  const Text(
                    'Informasi Semua Barang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1, height: 20, color: Colors.grey.shade200),
              Obx(() {
                final orderDetails = controller.orderDetail.value.orderDetails!
                    .where((element) => !element.isChecked)
                    .toList();

                if (orderDetails.isEmpty) {
                  return Expanded(
                    child: Center(child: Text('Tidak ada barang')),
                  );
                }

                if (controller.isLoadingProduct.value) {
                  return Expanded(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: const LoadingView(),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.separated(
                    itemCount: orderDetails.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(bottom: 10),
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      final order = orderDetails[index];

                      return _buildContentProduct(index: index, order: order);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                  ),
                );
              }),
              Divider(thickness: 1, height: 20, color: Colors.grey.shade200),
              if (button != null) button!,
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentProduct({
    required int index,
    required ItemOrderModel order,
  }) {
    String title = order.barcode;
    String value = order.qty.toString();

    RxList<XFile> files = RxList<XFile>.from(order.mediaFileList ?? <XFile>[]);

    if (AppRole.isDriver) {
      title = order.item;
    }

    return InkWell(
      onTap: () => DetailProductDialog().popupDetailItem(
        orderDetail: order,
        controller: controller,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 1,
              offset: const Offset(0, 0.5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.basicTextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Qty: $value',
                    style: TextStyles.basicTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildImage(
              index: index,
              indexImage: 0,
              files: files,
              order: order,
            ),
            _buildImage(
              index: index,
              indexImage: 1,
              files: files,
              order: order,
              margin: const EdgeInsets.only(left: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage({
    required int index,
    required int indexImage,
    required RxList<XFile> files,
    required ItemOrderModel order,
    EdgeInsetsGeometry? margin,
  }) {
    if (indexImage == 1 && files.isEmpty) {
      return const SizedBox.shrink();
    }

    if (files.isNotEmpty && indexImage < files.length) {
      return SizedBox(
        height: 60,
        width: 60,
        child: CustomImage().displayImage(
          path: files[indexImage].path,
          isPadding: false,
          onTapRemove: () => controller.removeImageInAllProduct(
            indexOrder: index,
            indexImage: indexImage,
            files: files,
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      child: InkWell(
        onTap: () => controller.addImageInAllProduct(index: index),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            color: const Color(0xFFffd8ab),
            strokeWidth: 1.5,
            dashPattern: const [5, 3.5],
            strokeCap: StrokeCap.round,
            radius: const Radius.circular(7),
          ),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: const Color(0xFFfffdfa),
            ),
            child: Center(
              child: Icon(
                Icons.camera_alt_outlined,
                size: 20,
                color: const Color(0xFFfa913c),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
