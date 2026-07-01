import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../shared/text_field/textfield_shared.dart';
import '../../../rit_information/presentation/widgets/custom_image.dart';
import '../controllers/ending_order_controller.dart';
import '../widgets/info_item_widget.dart';

class DriverArrive extends StatelessWidget {
  final EndingOrderController controller;
  const DriverArrive({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // _buildContentImage(
        //   title: 'Armada Sampai',
        //   mediaFileList: controller.mediaFileList,
        // ),
        // const SizedBox(height: 10),
        // _buildContentImage(
        //   title: 'Toko',
        //   mediaFileList: controller.mediaFileFrontMerchant,
        // ),
        // const SizedBox(height: 10),
        _buildSelectInfoItem(mediaFileList: controller.mediaFileListAllItem),
        const SizedBox(height: 10),
        _buildSelectInfoInvoice(
          mediaFileList: controller.mediaFileListInfoInvoice,
        ),
        const SizedBox(height: 10),
        _buildPaymentType(mediaFileList: controller.mediaFileListPaymentType),
      ],
    );
  }

  Widget _buildSelectInfoItem({required RxList<XFile> mediaFileList}) {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Informasi Item',
                style: TextStyles.basicTextStyle(
                  fontSize: 15,
                  letterSpacing: 0.48,
                  color: Colors.black,
                  fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                ),
              ),
              InkWell(
                onTap: () => InfoItemWidget().allItem(controller: controller),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFFd5914d),
                  ),
                  child: Text(
                    'Lihat Semua',
                    style: TextStyles.basicTextStyle(
                      fontSize: 12,
                      letterSpacing: 0.48,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: GoogleFonts.hankenGrotesk().fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomImage().buildContentImage(
            title: 'All Item',
            isShadow: false,
            mediaFileList: mediaFileList,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectInfoInvoice({required RxList<XFile> mediaFileList}) {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serah Terima Invoice/Surat Jalan',
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
                value: controller.selectedInfoInvoice.value,
                hint: const Text('Pilih Info Invoice'),
                underline: Container(),
                items: controller.infoInvoiceList
                    .map(
                      (invoice) => DropdownMenuItem<String>(
                        value: invoice,
                        child: Text(
                          invoice,
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
                  controller.selectedInfoInvoice.value = value ?? '';
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            String title = 'Invoice';

            if (controller.selectedInfoInvoice.value != 'Lunas') {
              title = 'Surat Jalan';
            }

            return CustomImage().buildContentImage(
              title: title,
              isShadow: false,
              mediaFileList: mediaFileList,
            );
          }),
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
