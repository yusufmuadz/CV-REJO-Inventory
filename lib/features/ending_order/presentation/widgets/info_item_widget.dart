import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/text_styles.dart';
import '../controllers/ending_order_controller.dart';

class InfoItemWidget {
  void allItem({required EndingOrderController controller}) {
    controller.dialogService.defaultDialog(
      singleButton: true,
      title: 'Informasi Item',
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      titleButton1: 'Kembali',
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
                itemCount: controller.itemPO.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 12),
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  height: 16,
                  color: Color(0xFFE2E8F8),
                ),
                itemBuilder: (context, index) {
                  final order = controller.itemPO[index];

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
                                order.item,
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
                                'QTY: ${order.qty}',
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
            'Nama Item',
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
