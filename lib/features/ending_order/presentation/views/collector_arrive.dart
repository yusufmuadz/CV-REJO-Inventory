import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

import '../../../../shared/text_field/textfield_shared.dart';
import '../../../../shared/images/custom_image.dart';
import '../../../../utils/thousand_formatter.dart';
import '../controllers/ending_order_controller.dart';
import '../controllers/enums/enum_button.dart';

class CollectorArrive extends StatelessWidget {
  final EndingOrderController controller;
  const CollectorArrive({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Visibility(
            visible:
                controller.statusButton.value == EnumButtonEndingOrder.savePO,
            child: _buildFirstContent(),
          ),
          Visibility(
            visible:
                controller.statusButton.value ==
                EnumButtonEndingOrder.saveCollectorInv,
            child: _buildSecondContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstContent() {
    return Column(
      children: [
        CustomImage().buildContentImage(
          maxImage: 1,
          title: 'Toko',
          mediaFileList: controller.mediaFileFrontMerchant,
        ),
        const SizedBox(height: 10),
        CustomImage().buildContentImage(
          maxImage: 1,
          title: 'Bukti Tagihan',
          mediaFileList: controller.mediaFileList,
        ),
      ],
    );
  }

  Widget _buildSecondContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusPaymentInvoice(),
        const SizedBox(height: 10),
        _buildShow(),
      ],
    );
  }

  Widget _buildShow() {
    if (controller.statusPaymentInv.value) {
      return _buildPaymentType(
        mediaFileList: controller.mediaFileListPaymentType,
      );
    }

    return _buildWithoutPayment();
  }

  Widget _buildStatusPaymentInvoice() {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status Pembayaran',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.48,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFf4f4f5)),
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF8F9FA),
            ),
            child: Row(
              children: [
                _buildButtonStatus(
                  title: 'Ada',
                  icon: Icons.payments_outlined,
                  isPayment: controller.statusPaymentInv.value,
                  onTap: () {
                    controller.statusPaymentInv.value = true;
                    controller.resetInv();
                  },
                ),
                const SizedBox(width: 10),
                _buildButtonStatus(
                  title: 'Tidak Ada',
                  icon: Icons.money_off_outlined,
                  isPayment: !controller.statusPaymentInv.value,
                  onTap: () {
                    controller.statusPaymentInv.value = false;
                    controller.resetInv();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithoutPayment() {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldNote(
            title: 'Keterangan*',
            textEditingController: controller.fieldController,
          ),
          const SizedBox(height: 15),
          _buildFieldNote(
            isOptional: true,
            title: 'Keterangan Tambahan',
            textEditingController: controller.fieldReasonInvController,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentType({required RxList<XFile> mediaFileList}) {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jenis Pembayaran',
            style: GoogleFonts.hankenGrotesk(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.48,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFf4f4f5)),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: DropdownButton<String>(
                isExpanded: true,
                value: controller.selectedPaymentType.value,
                hint: const Text('Pilih Jenis Pembayaran'),
                underline: Container(),
                items: controller.paymentTypeList
                    .map(
                      (payment) => DropdownMenuItem<String>(
                        value: payment,
                        child: Text(
                          payment,
                          style: GoogleFonts.hankenGrotesk(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.50,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  controller.selectedPaymentType.value = value ?? '';
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          SharedTextField(
            controller: controller.fieldController,
            keyboardType: TextInputType.number,
            hintText: 'Masukkan nominal',
            inputFormatters: [ThousandsSeparatorInputFormatter()],
            prefixIcon: Icon(
              CupertinoIcons.money_dollar,
              color: const Color(0xFFfa913c),
            ),
            validator: (String? p1) {
              if (p1 == null || p1.isEmpty) {
                return 'Masukkan nominal pembayaran terlebih dahulu';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          CustomImage().buildContentImage(
            title: 'Bukti Pembayaran',
            isShadow: false,
            mediaFileList: mediaFileList,
          ),
        ],
      ),
    );
  }

  Widget _buildButtonStatus({
    required String title,
    required IconData icon,
    required bool isPayment,
    required Function() onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isPayment ? Colors.white : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isPayment
                    ? const Color(0xFF006E2F)
                    : const Color(0xFF6D7B6C),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: isPayment
                      ? const Color(0xFF006E2F)
                      : const Color(0xFF6D7B6C),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  // letterSpacing: 0.50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldNote({
    bool isOptional = false,
    required String title,
    required TextEditingController textEditingController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            style: TextStyle(
              color: Color(0xFF171717),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 0,
              letterSpacing: 0.48,
            ),
            children: [
              if (isOptional)
                TextSpan(
                  text: '(opsional)',
                  style: TextStyle(
                    color: Color(0xFF171717),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: 0.48,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          maxLines: 4,
          controller: textEditingController,
          style: const TextStyle(
            color: Color(0xFF171717),
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: isOptional
                ? 'Masukkan keterangan jika diperlukan'
                : 'Wajib masukkan keterangan*',
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoxStyle({required Widget child, bool isShadow = true}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFf4f4f5)),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: !isShadow
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
      ),
      child: child,
    );
  }
}
