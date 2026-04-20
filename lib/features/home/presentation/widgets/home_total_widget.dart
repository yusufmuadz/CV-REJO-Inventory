import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeTotalWidget extends StatelessWidget {
  final HomeController controller;
  const HomeTotalWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildContent(
          title: 'Total Pesanan Minggu Ini',
          value: controller.totalOrder.toString(),
          total: '120',
        ),
        const SizedBox(width: 30),
        _buildContent(
          title: 'Picking Minggu ini'.capitalizeFirst!,
          value: controller.totalOrderHistory.toString(),
          total: '50',
        ),
      ],
    );
  }

  Widget _buildContent({
    required String title,
    required String value,
    required String total,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF737D93),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            height: 0.12,
            letterSpacing: 0.50,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            // Obx(() {
            //   final totalRow = 0 ??
            //       0;
            //   return
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF212325),
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0.06,
                letterSpacing: 0.50,
              ),
            ),
            // }),
            const SizedBox(width: 5),
            Text(
              '/$total',
              style: TextStyle(
                color: Color(0xE5939393),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0.16,
                letterSpacing: 0.50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
