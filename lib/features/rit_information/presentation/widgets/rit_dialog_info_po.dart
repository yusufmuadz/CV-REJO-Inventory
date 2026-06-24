import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/text_styles.dart';
import '../controllers/rit_controller.dart';
import '../controllers/enums/enum_rit.dart';

class RitDialogInfoPo {
  // ignore: non_constant_identifier_names
  void confirmPO({required RitController controller}) {
    controller.dialogService.defaultDialog(
      title: 'Konfirmasi Perubahan',
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      onPressed2: () {
        controller.buttonRIT.value = EnumButtonRIT.buttonTakeOff;
        Get.back();
        controller.dialogService.showSuccessSnackbar('Berhasil Mengubah PO');
      },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            child: Container(
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
                itemCount: controller.orders.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  height: 16,
                  color: Color(0xFFE2E8F8),
                ),
                itemBuilder: (context, index) {
                  final order = controller.orders[index];

                  return Padding(
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
                                order.orderNo,
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
                                'Alamat Pengiriman: ${order.district}',
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
                      ],
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

  Widget _buildTitleIconList() {
    return Row(
      children: [
        SizedBox(
          width: 30,
          child: Text(
            '#',
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
            'Nomor PO',
            style: GoogleFonts.hankenGrotesk(
              color: const Color(0xFF524439),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.48,
            ),
          ),
        ),
      ],
    );
  }
}
