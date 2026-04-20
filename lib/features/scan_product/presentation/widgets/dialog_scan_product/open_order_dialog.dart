import 'package:cv_rejo/features/scan_product/presentation/controllers/scan_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> openPesanan({required ScanProductController controller}) async {
  return Get.dialog(
    barrierDismissible: false,
    AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: const Center(
        child: Text(
          'Pesanan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
      ),
      actionsPadding: EdgeInsets.only(top: 20, bottom: 20, right: 20),
      contentPadding: const EdgeInsets.fromLTRB(20.0, 26.0, 20.0, 20.0),
      content: ListView.builder(
        shrinkWrap: true,
        itemCount:
            controller
                .detailOrderController
                .orderDetail
                .value
                .orderDetails
                ?.length ??
            0,
        itemBuilder: (context, index) {
          final orderDetail = controller
              .detailOrderController
              .orderDetail
              .value
              .orderDetails?[index];
          String quantityText;

          // Periksa peran pengguna yang sedang login
          if (controller.detailOrderController.userModel.value.jabatan == 'packing') {
            quantityText = '${orderDetail?.checker1.qty}';
          } else {
            quantityText = '${orderDetail?.pic.qty} / ${orderDetail?.qty}';
          }

          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            color: index.isOdd ? Colors.white : Colors.grey.shade200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}.',
                      style: const TextStyle(
                        color: Color(0xFF171717),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ' ${orderDetail?.item}',
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      quantityText,
                      style: const TextStyle(
                        color: Color(0xFF171717),
                        fontSize: 13,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Tutup dialog
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Warna teks & ikon
            backgroundColor: Colors.redAccent[100], // Warna latar belakang
            disabledForegroundColor: Colors.grey, // Warna saat disabled
            disabledBackgroundColor: Colors.blue[100],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          child: const Text('Tutup'),
        ),
      ],
    ),
  );
}
