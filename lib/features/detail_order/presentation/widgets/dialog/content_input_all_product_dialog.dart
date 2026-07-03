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

class ContentInputAllProductDialog extends StatelessWidget {
  final bool isLoadingProduct;
  final List<ItemOrderModel> orderDetails;

  const ContentInputAllProductDialog({
    super.key,
    required this.isLoadingProduct,
    required this.orderDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingProduct) {
      return SizedBox(height: 50, width: 50, child: const LoadingView());
    }

    return ListView.separated(
      itemCount: orderDetails.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final order = orderDetails[index];

        return _buildContentProduct(index: index, order: order);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
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

    return Container(
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
          _buildImage(index: index, files: files, order: order),
          const SizedBox(width: 10),
          _buildImage(index: index, files: files, order: order),
        ],
      ),
    );
  }

  Widget _buildImage({
    required int index,
    required RxList<XFile> files,
    required ItemOrderModel order,
  }) {
    if (files.isNotEmpty) {
      return CustomImage().displayImage(
        path: files[0].path,
        isPreview: true,
        onTapRemove: () => CustomImage().removeImage(0, null, files),
      );
    }

    return InkWell(
      onTap: () {
        CustomImage().selectImage(null, files);

        final updatedOrder = order.copyWith(mediaFileList: files);

        final updateList = List<ItemOrderModel>.from(orderDetails);

        updateList[index] = updatedOrder;
      },
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: const Color(0xFFffd8ab),
          strokeWidth: 1.5,
          padding: EdgeInsets.all(3),
          dashPattern: const [5, 3.5],
          strokeCap: StrokeCap.round,
          radius: const Radius.circular(7),
        ),
        child: Container(
          height: 40,
          width: 40,
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
    );
  }
}
