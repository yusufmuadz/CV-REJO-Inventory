import 'package:flutter/material.dart';

import '../../../../shared/text_field/textfield_shared.dart';
import '../controllers/rit_controller.dart';
import '../../../../shared/images/custom_image.dart';

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
        const SizedBox(height: 20),
        CustomImage().buildContentImage(
          title: 'Surat Jalan/Invoice',
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
      ],
    );
  }
}
