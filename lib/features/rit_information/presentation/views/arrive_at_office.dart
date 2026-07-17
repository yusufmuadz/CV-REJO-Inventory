import 'package:flutter/material.dart';

import '../../../../shared/text_field/textfield_shared.dart';
import '../controllers/rit_controller.dart';
import '../../../../shared/images/custom_image.dart';
import '../widgets/arrive_image_widget.dart';

class ArriveAtOffice extends StatelessWidget {
  final RitController controller;

  const ArriveAtOffice({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Masukkan Nama Penerima Berkas*',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.38,
          ),
        ),
        const SizedBox(height: 10),
        SharedTextField(
          controller: controller.recipientName,
          hintText: 'Masukkan nama penerima*',
          validator: (String? p1) {
            if (p1 == null || p1.isEmpty) {
              return 'Masukkan nama penerima terlebih dahulu';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ArriveImageWidget().buildContentImageArrive(
          title: 'KM kendaraan',
          mediaFileList: controller.mediaFileListKM,
          controller: controller,
        ),
        const SizedBox(height: 10),
        ArriveImageWidget().buildInputKM(controller: controller),
        const SizedBox(height: 10),
        ArriveImageWidget().buildContentImageArrive(
          title: 'kendaraan',
          isTransportation: true,
          maxImage: 4,
          mediaFileList: controller.mediaFileList,
          controller: controller,
        ),
        const SizedBox(height: 10),
        ArriveImageWidget().buildContentImageArrive(
          title: 'Tangki Bahan Bakar dan Foto Segel',
          mediaFileList: controller.mediaFileListTangki,
          controller: controller,
        ),
        const SizedBox(height: 10),
        CustomImage().buildContentImage(
          title: 'Invoice/Surat Jalan',
          mediaFileList: controller.mediaFileRecipientInvoice,
        ),
        const SizedBox(height: 10),
        CustomImage().buildContentImage(
          title: 'Bukti Transfer/Uang Cash Pembayaran',
          mediaFileList: controller.mediaFileRecipientMoney,
        ),
        const SizedBox(height: 10),
        CustomImage().buildContentImage(
          title: 'Penggunaan Uang Perjalanan',
          mediaFileList: controller.mediaFileRecipientMoneyRit,
        ),
        const SizedBox(height: 10),
        CustomImage().buildContentImage(
          title: 'Kotak Berkas',
          mediaFileList: controller.mediaFileRecipientBox,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
