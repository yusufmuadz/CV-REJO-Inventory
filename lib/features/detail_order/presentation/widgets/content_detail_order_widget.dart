import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/middlewares/app_role.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../rit_information/presentation/widgets/custom_image.dart';
import '../controllers/detail_order_controller.dart';

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
          isStatusDriver: controller.statusDriver.value == 'completed',
        ),
        _buildInfoPesanan(),
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

  Widget _buildInfoContent({
    required String title,
    required String value,
    required IconData icon,
    bool isPhone = false,
    bool isAddress = false,
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
            child: InkWell(
              onTap: () {
                if (isAddress) {
                  controller.onTapMaps();
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyles.basicTextStyle(
                            fontFamily:
                                GoogleFonts.hankenGrotesk().fontFamily ??
                                'Inter',
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
                  Visibility(
                    visible: isPhone,
                    child: InkWell(
                      onTap: () => controller.copyToClipboard(phone: value),
                      child: Icon(
                        Icons.copy,
                        size: 20,
                        color: const Color(0xFFEC4899),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isAddress,
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 20,
                      color: const Color(0xFFd5914d),
                    ),
                  ),
                ],
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
    bool isStatusDriver = false,
  }) {
    final isDriver = AppRole.isDriver && isStatusDriver;

    return _buildBoxStyle(
      vertical: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: controller.isFromHistory.value,
            child: _buildInfoContent(
              title: 'Penanggung Jawab PO',
              value: 'PENANGGUNG JAWAB PO',
              icon: Icons.groups_outlined,
            ),
          ),
          _buildInfoContent(
            title: 'Nama Penerima',
            value: namePenerima,
            icon: Icons.person_outline,
          ),
          Visibility(
            visible: isDriver,
            child: _buildInfoContent(
              isPhone: true,
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
            mgBottom: 16,
          ),
          Visibility(
            visible: isDriver,
            child: _buildInfoContent(
              isAddress: true,
              title: 'Alamat Pengiriman',
              value: 'Jl. Jend. Sudirman No. 1, Jakarta Selatan',
              icon: Icons.apartment,
              mgBottom: 16,
            ),
          ),
          _buildInfoContent(
            title: 'Catatan',
            value: '-',
            icon: Icons.description_outlined,
            mgBottom: 0,
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
          _buildTitleIconText(
            title: 'Pesanan',
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xFFE2E8F8)),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
              color: const Color(0xFFF0F3FF),
            ),
            child: _buildTitleIconList(),
          ),
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
                itemCount:
                    controller.orderDetail.value.orderDetails?.length ?? 0,
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
                  String setQty =
                      '${orderDetail?.pic.qty} / ${orderDetail?.qty}';
                  bool isChecked = orderDetail?.isChecked ?? false;

                  if (AppRole.isChecker1) {
                    setQty = '${orderDetail?.checker1.qty}';
                  }

                  if (!isChecked) {
                    if (AppRole.isChecker2) {
                      isChecked = orderDetail?.statusChecker2 ?? false;
                    } else if (AppRole.isDriver) {
                      isChecked = orderDetail?.statusDriver ?? false;
                    }
                  }

                  return InkWell(
                    onTap: () => _popupDetailItem(
                      idProduct: orderDetail?.barcode ?? '-',
                      nameProduct: orderDetail?.item ?? '-',
                      qty: orderDetail?.qty ?? '-',
                      location: orderDetail?.locationRack ?? '-',
                      color: orderDetail?.color ?? '-',
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
                                  '${orderDetail?.barcode}',
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
                                  'Lokasi: ${orderDetail?.locationRack}',
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
            // controller.selectedProduct(-1);
            return;
          }

          controller.selectedProduct(index);
        },
      ),
    );
  }

  Widget _buildTitleIconList() {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            'No.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF5D5E61),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Produk',
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF524439),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: Text(
            'Qty',
            textAlign: TextAlign.left,
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF5D5E61),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
            ),
          ),
        ),
        Visibility(
          visible: AppRole.isChecker2 || AppRole.isDriver,
          child: SizedBox(
            width: 30,
            // child: _buildCheckBox(check: false, index: -1),
          ),
        ),
      ],
    );
  }

  _popupDetailItem({
    required String idProduct,
    required String nameProduct,
    required String qty,
    required String location,
    required String color,
  }) {
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
      titleStyle: GoogleFonts.hankenGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF8A5012),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 1, height: 0, color: Color(0xFFE7EEFE)),
            _buildBoxIconText(
              title: 'Kode Produk',
              value: idProduct,
              icon: Icons.fingerprint_outlined,
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

            _buildBoxIconText(
              title: 'Lokasi Simpan (Rak)',
              value: location,
              icon: Icons.shelves,
              isBox: AppRole.isPIC,
            ),

            _buildBoxIconText(
              title: 'Warna Produk',
              value: color,
              icon: Icons.palette_outlined,
              isBox: !AppRole.isPIC,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxIconText({
    required String title,
    required String value,
    required IconData icon,
    bool isBox = false,
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
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF524439),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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

  Widget _buildPreviewImage() {
    // final path =
    //     '/data/user/0/com.example.cv_rejo/cache/scaled_3bc63cbc-36ea-48ea-8f5a-3f626ecb249e4335120780293089847.jpg';
    // final path2 =
    //     '/data/user/0/com.example.cv_rejo/cache/scaled_d3f88841-c36d-4287-9dff-51bc574d80b2295637012260647764.jpg';
    // final path3 =
    //     '/data/user/0/com.example.cv_rejo/cache/scaled_2c0f5da0-bafe-4356-bd48-ed3025c0f89f7908266508335097410.jpg';
    RxList<XFile> mediaFileList = <XFile>[
      // XFile(path),
      // XFile(path2),
      // XFile(path3),
    ].obs;

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
