import 'package:flutter/material.dart';

import '../controllers/ending_order_controller.dart';

class FieldInputWidget extends StatelessWidget {
  final EndingOrderController controller;

  const FieldInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Keterangan',
              style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 0,
                letterSpacing: 0.48,
              ),
              children: [
                TextSpan(
                  text: '(opsional)',
                  style: TextStyle(
                      color: Color(0xFF171717),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      letterSpacing: 0.48,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            maxLines: 4,
            controller: controller.fieldController,
            style: const TextStyle(
              color: Color(0xFF171717),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: 'Masukkan keterangan tambahan jika diperlukan',
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
