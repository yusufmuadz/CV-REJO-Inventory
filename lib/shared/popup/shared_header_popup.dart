import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SharedHeaderPopup extends StatelessWidget {
  final String title;

  const SharedHeaderPopup({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 35),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        InkWell(
          onTap: () => Get.back(),
          child: Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF3F4F6),
            ),
            child: Icon(Icons.close, size: 20, color: const Color(0xFF4B5563)),
          ),
        ),
      ],
    );
  }
}
