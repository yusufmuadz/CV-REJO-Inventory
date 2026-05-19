import 'package:cv_rejo/features/detail_order/presentation/controllers/detail_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../gen/assets.gen.dart';

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
        _buildInfoCustomer(
          username: controller.orderDetail.value.customer.name,
          namePenerima: controller.orderDetail.value.customer.name,
          tanggalPesanan: controller.orderDetail.value.date.transaction,
          tanggalBatas: controller.orderDetail.value.date.delivery,
          district: controller.orderDetail.value.customer.district,
        ),
        _buildInfoPesanan(),
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

  Widget _buildInfoContent({
    required String title,
    required String value,
    required IconData icon,
    double mgBottom = 16,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: mgBottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconStyle(icon: icon),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.basicTextStyle(
                    fontFamily:
                        GoogleFonts.hankenGrotesk().fontFamily ?? 'Inter',
                    fontSize: 12,
                    color: const Color(0xFF857467),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyles.basicTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF151C27),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCustomer({
    required String username,
    required String namePenerima,
    String tanggalPesanan = '',
    String tanggalBatas = '',
    String district = '',
  }) {
    return _buildBoxStyle(
      vertical: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoContent(
            title: 'Nama Penerima',
            value: namePenerima,
            icon: Icons.person_outline,
          ),
          Visibility(
            visible: AppRole.isDriver,
            child: _buildInfoContent(
              title: 'Nomor Telepon',
              value: '081234567890',
              icon: Icons.phone_outlined,
            ),
          ),
          _buildInfoContent(
            title: 'Tanggal Pesanan Masuk',
            value: tanggalBatas,
            icon: Icons.calendar_month_outlined,
          ),
          _buildInfoContent(
            title: 'KOTA/KABUPATEN',
            value: district,
            icon: Icons.location_on_outlined,
            mgBottom: AppRole.isDriver ? 16 : 0,
          ),
          Visibility(
            visible: AppRole.isDriver,
            child: _buildInfoContent(
              title: 'Alamat Pengiriman',
              value: 'Jl. Jend. Sudirman No. 1, Jakarta Selatan',
              icon: Icons.apartment,
              mgBottom: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPesanan() {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconStyle(icon: Icons.inventory_2_outlined),
              const SizedBox(width: 8),
              Text(
                'Pesanan',
                style: TextStyles.basicTextStyle(
                  fontSize: 16,
                  fontFamily: GoogleFonts.hankenGrotesk().fontFamily ?? 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 0,
                  color: Color(0xFF151C27),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => ListView.separated(
              itemCount: controller.orderDetail.value.orderDetails?.length ?? 0,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 13),
              itemBuilder: (context, index) {
                final orderDetail =
                    controller.orderDetail.value.orderDetails?[index];
                String setQty = '${orderDetail?.pic.qty} / ${orderDetail?.qty}';

                if (AppRole.isChecker1) {
                  setQty = '${orderDetail?.checker1.qty}';
                }

                return Row(
                  children: [
                    Text(
                      '${index + 1}.',
                      style: TextStyles.basicTextStyle(
                        fontSize: 16,
                        fontFamily:
                            GoogleFonts.hankenGrotesk().fontFamily ?? 'Inter',
                        color: Color(0xFF524439),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${orderDetail?.item}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.basicTextStyle(
                          fontSize: 15,
                          fontFamily:
                              GoogleFonts.hankenGrotesk().fontFamily ?? 'Inter',

                          color: Color(0xFF151C27),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      setQty,
                      style: TextStyles.basicTextStyle(
                        fontSize: 16,
                        fontFamily:
                            GoogleFonts.hankenGrotesk().fontFamily ?? 'Inter',

                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Visibility(
                      visible:
                          AppRole.isChecker2 ||
                          AppRole
                              .isDriver, // visible: AppRole.isChecker2 || AppRole.isDriver,
                      child: _buildCheckBox(
                        check: orderDetail?.isChecked ?? false,
                        index: index,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBox({required bool check, required int index}) {
    if ((controller.statusChecker2.value == 'completed' &&
            !controller.isSelect.value) ||
        (AppRole.isDriver && !controller.isSelect.value) ||
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
          // if (AppRole.isDriver) {
          //   controller.dialogService.showErrorSnackbar(
          //     title: 'Warning!',
          //     'Coming Soon',
          //   );
          //   return;
          // }
          controller.selectedProduct(index);
        },
      ),
    );
  }
}
