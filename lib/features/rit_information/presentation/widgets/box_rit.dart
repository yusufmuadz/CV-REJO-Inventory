import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/rit_controller.dart';

class BoxRit extends StatelessWidget {
  final RitController controller;
  const BoxRit({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFf5f6f6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 33,
            width: 33,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFdaeafc),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: const Color(0xFF165be3),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Obx(
            () => Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RIT-${controller.isDistrictSelected.value}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat(
                      'dd MMMM yyyy',
                    ).format(DateTime.parse(controller.tanggalRit.value)),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF4d5461),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(width: 10),
          // Container(
          //   padding: const EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(7),
          //     color: const Color(0xFFd6f2dd),
          //   ),
          //   child: Text(
          //     'Selesai',
          //     style: _textStyle(
          //       fontSize: 12,
          //       fontWeight: FontWeight.w600,
          //       letterSpacing: 0.45,
          //       color: Color(0xFF69b47c),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  TextStyle _textStyle({
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color color = const Color(0xFF171717),
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'Inter',
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
