import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/middlewares/app_role.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../controllers/detail_order_controller.dart';
import '../dialog/detail_product_dialog.dart';

class ContentInfoOrderWidget extends StatelessWidget {
  final DetailOrderController controller;

  const ContentInfoOrderWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleIconText(title: 'Pesanan', icon: Icons.inventory_2_outlined),
        const SizedBox(height: 20),
        _buildTitleIconList(),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1, color: Color(0xFFE2E8F8)),
                right: BorderSide(width: 1, color: Color(0xFFE2E8F8)),
                left: BorderSide(width: 1, color: Color(0xFFE2E8F8)),
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              color: Colors.white,
            ),
            child: ListView.separated(
              itemCount: controller.orderDetail.value.orderDetails?.length ?? 0,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(
                thickness: 1,
                height: 23,
                color: Color(0xFFE2E8F8),
              ),
              itemBuilder: (context, index) {
                final orderDetail =
                    controller.orderDetail.value.orderDetails?[index];

                String title = orderDetail?.barcode ?? '';
                String value = 'Lokasi: ${orderDetail?.locationRack}';
                String setQty = '${orderDetail?.pic.qty} / ${orderDetail?.qty}';
                bool isChecked = orderDetail?.isChecked ?? false;

                if (AppRole.isChecker1) {
                  setQty = '${orderDetail?.checker1.qty}';
                }

                if (!isChecked) {
                  if (AppRole.isChecker2) {
                    isChecked = orderDetail?.statusChecker2 ?? false;
                  } else if (AppRole.isDriver) {
                    title = orderDetail?.item ?? '';
                    value = 'Warna: ${orderDetail?.color}';
                    isChecked = orderDetail?.statusDriver ?? false;
                  }
                }

                return InkWell(
                  onTap: () => DetailProductDialog().popupDetailItem(
                    orderDetail: orderDetail,
                    controller: controller,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            '${index + 1}.',
                            textAlign: TextAlign.center,
                            style: TextStyles.basicTextStyle(
                              fontSize: 14,
                              fontFamily:
                                  GoogleFonts.hankenGrotesk().fontFamily,
                              color: Color(0xFF524439),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.basicTextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.hankenGrotesk().fontFamily,
                                  color: Color(0xFF151C27),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                value,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.basicTextStyle(
                                  fontSize: 12,
                                  fontFamily:
                                      GoogleFonts.hankenGrotesk().fontFamily,
                                  color: Color(0xFF5D5E61),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 70,
                          child: Text(
                            setQty,
                            style: TextStyles.basicTextStyle(
                              fontSize: 14,
                              fontFamily:
                                  GoogleFonts.hankenGrotesk().fontFamily,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF8A5012),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: AppRole.isChecker2 || AppRole.isDriver,
                          child: SizedBox(
                            width: 30,
                            child: _buildCheckBox(
                              check: isChecked,
                              index: index,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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

  Widget _buildCheckBox({required bool check, required int index}) {
    if ((controller.statusChecker2.value == 'completed' &&
            !controller.isSelect.value) ||
        // (AppRole.isDriver && !controller.isSelect.value) ||
        controller.routeFrom.value == 'listHistoryOrder') {
      return SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Checkbox(
        value: check,
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (value) {
          if (check) return;

          if (index < 0) {
            controller.selectedProduct(index);
            return;
          }

          controller.selectedProduct(index);
        },
      ),
    );
  }

  Widget _buildTitleIconList() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xFFE2E8F8)),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
        color: const Color(0xFFF0F3FF),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              'No.',
              textAlign: TextAlign.center,
              style: TextStyles.basicTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.48,
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                color: const Color(0xFF5D5E61),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Produk',
              style: TextStyles.basicTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.48,
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                color: const Color(0xFF524439),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 70,
            child: Text(
              'Qty',
              textAlign: TextAlign.left,
              style: TextStyles.basicTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.48,
                fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                color: const Color(0xFF5D5E61),
              ),
            ),
          ),
          Visibility(
            visible: AppRole.isChecker2 || AppRole.isDriver,
            child: SizedBox(
              width: 30,
              child: Obx(() {
                final list = controller.orderDetail.value.orderDetails ?? [];
                final allChecked =
                    list.isNotEmpty &&
                    list.every((element) {
                      bool isChecked = element.isChecked;

                      if (!isChecked) {
                        if (AppRole.isChecker2) {
                          isChecked = element.statusChecker2;
                        } else if (AppRole.isDriver) {
                          isChecked = element.statusDriver;
                        }
                      }

                      return isChecked;
                    });

                return _buildCheckBox(check: allChecked, index: -1);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
