import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeBoxWidget extends StatelessWidget {
  final HomeController controller;

  const HomeBoxWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _boxItem(
            title: 'List Pesanan',
            value: controller.totalOrder.toString(),
            begin: Alignment(0.95, -0.31),
            end: Alignment(-0.95, 0.31),
            colors: [
              const Color(0xFFFFCA42),
              const Color(0xFFF0B215),
              const Color(0xFFE0AE2E),
            ],
            icon: Icon(
              Icons.fact_check_outlined,
              color: Colors.white,
              size: 24,
            ),
            onTap: () => controller.routeTo(),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _boxItem(
            title: 'List History',
            value: controller.totalOrderHistory.toString(),
            begin: Alignment(0.94, 0.34),
            end: Alignment(-0.94, -0.34),
            colors: [const Color(0xFF00B478), const Color(0xFF48ECB6)],
            icon: Icon(
              Icons.inventory_2_outlined,
              color: Colors.white,
              size: 24,
            ),
            onTap: () {
              Get.toNamed(Routes.LIST_HISTORY_ORDER);
            },
          ),
        ),
      ],
    );
  }

  Widget _boxItem({
    required String title,
    required String value,
    required AlignmentGeometry begin,
    required AlignmentGeometry end,
    required List<Color> colors,
    required Widget icon,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 91,
        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(begin: begin, end: end, colors: colors),
        ),
        child: Stack(
          children: [
            Positioned(top: 0, right: 0, child: icon),
            Positioned(
              top: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: 0.50,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.50,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
