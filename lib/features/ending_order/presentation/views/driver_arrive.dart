import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/text_field/textfield_shared.dart';
import '../../../rit_information/presentation/widgets/custom_grid_image.dart';
import '../../../rit_information/presentation/widgets/custom_image.dart';
import '../controllers/ending_order_controller.dart';

class DriverArrive extends StatelessWidget {
  final EndingOrderController controller;
  const DriverArrive({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContentImage(
          title: 'All Item',
          mediaFileList: controller.mediaFileList,
        ),
        const SizedBox(height: 10),
        _buildContentImage(
          title: 'Depan Toko',
          mediaFileList: controller.mediaFileList,
        ),
        const SizedBox(height: 10),
        _buildSelectInfoInvoice(mediaFileList: controller.mediaFileList),
        const SizedBox(height: 10),
        _buildPaymentType(mediaFileList: controller.mediaFileList),
      ],
    );
  }

  Widget _buildSelectInfoInvoice({required RxList<XFile> mediaFileList}) {
    return _buildBoxStyle(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Serah Terima Invoice',
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
          _buildContentImage(
            title: 'Serah Terima',
            isShadow: false,
            mediaFileList: mediaFileList,
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
          _buildContentImage(
            title: 'Bukti Pembayaran',
            isShadow: false,
            mediaFileList: mediaFileList,
          ),
          // SharedTextField(
          //   controller: controller.fieldController,
          //   keyboardType: TextInputType.number,
          //   hintText: 'Contoh: 12345',
          //   prefixIcon: Icon(Icons.speed, color: const Color(0xFFfa913c)),
          //   validator: (String? p1) {
          //     if (p1 == null || p1.isEmpty) {
          //       return 'Masukkan KM Kendaraan';
          //     }
          //     return null;
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildContentImage({
    int? maxImage,
    bool isShadow = true,
    required String title,
    required RxList<XFile> mediaFileList,
  }) {
    return _buildBoxStyle(
      isShadow: isShadow,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: mediaFileList.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  children: [
                    Expanded(child: CustomImage().buildTitle(title: title)),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top: 10),
                      child: InkWell(
                        onTap: () => controller.clearAllImages(),
                        child: const Text(
                          'Hapus Semua',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: mediaFileList.isNotEmpty,
              child: CustomGridImage(
                maxImage: maxImage ?? 2,
                mediaFileList: mediaFileList,
                onAdd: () => controller.selectImage(ImageSource.camera),
                onRemove: (int index) => controller.removeImage(index),
              ),
            ),
            Visibility(
              visible: mediaFileList.isEmpty,
              child: Row(
                children: [
                  CustomImage().addImage(
                    onTap: () => controller.selectImage(ImageSource.camera),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: CustomImage().buildTitle(title: title)),
                ],
              ),
            ),
          ],
        ),
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
