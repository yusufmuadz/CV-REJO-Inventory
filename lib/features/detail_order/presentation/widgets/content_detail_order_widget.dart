import 'package:cv_rejo/features/detail_order/presentation/controllers/detail_order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        // _buildBody(
        //   title: 'No Resi',
        //   value: controller.orderDetail.value.courier.waybillNumber,
        //   pengiriman: controller.orderDetail.value.courier.service,
        // ),
        // _buildBody(
        //   title: 'No Pesanan',
        //   value: controller.orderDetail.value.invoice.replaceAll('SL', 'SO'),
        // ),
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

  Widget _buildBody({
    required String title,
    required String value,
    String pengiriman = '',
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.basicTextStyle(
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ),
              SizedBox(
                width: 135,
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: TextStyles.basicTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF171717),
                  ),
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
    required String image,
    double mgBottom = 16,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: mgBottom),
      child: Row(
        children: [
          SizedBox(width: 20, height: 20, child: Image.asset(image)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyles.basicTextStyle(color: const Color(0xFF7C7C7C)),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 135,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyles.basicTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF171717),
              ),
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildInfoContent(
          //   title: 'Username',
          //   value: username,
          //   image: Assets.icons.cardMember.path,
          // ),
          _buildInfoContent(
            title: 'Nama Penerima',
            value: namePenerima,
            image: Assets.icons.person2.path,
          ),
          _buildInfoContent(
            title: 'Tanggal Pesanan Masuk',
            value: tanggalBatas,
            image: Assets.icons.dateIn.path,
          ),
          _buildInfoContent(
            title: 'KOTA/KABUPATEN',
            value: district,
            image: Assets.icons.district.path,
            mgBottom: 0,
          ),
          // _buildInfoContent(
          //   title: 'Tanggal Batas Pengiriman',
          //   value: tanggalBatas,
          //   image: Assets.icons.dateOrder.path,
          //   mgBottom: 0,
          // ),
        ],
      ),
    );
  }

  Widget _buildInfoPesanan() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppTheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(Assets.icons.orderan.path),
              ),
              const SizedBox(width: 8),
              Text(
                'Pesanan',
                style: TextStyles.basicTextStyle(
                  color: Color(0xFF171717),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 0,
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
                    Text('${index + 1}.', style: TextStyles.basicTextStyle()),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${orderDetail?.item}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.basicTextStyle(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      setQty,
                      style: TextStyles.basicTextStyle(
                        fontWeight: FontWeight.w600,
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
        controller.routeFrom.value == 'listHistoryOrder') {
      return SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: Checkbox(
        visualDensity: VisualDensity(horizontal: -4, vertical: -4),
        value: check,
        onChanged: (value) {
          if (AppRole.isDriver) {
            controller.dialogService.showErrorSnackbar(
              title: 'Warning!',
              'Coming Soon',
            );
            return;
          }
          controller.selectedProduct(index);
        },
      ),
    );
  }
}
