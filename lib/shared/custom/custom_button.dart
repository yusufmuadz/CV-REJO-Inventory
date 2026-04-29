import 'package:flutter/material.dart';

class CustomButton {
  /// ===== BASIC BUTTON =====
  static Widget basicButton({
    required String title,
    required Color color,
    required VoidCallback onPressed,
    Size? minimumSize,
    Color? shadowColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize,
        foregroundColor: Colors.white,
        backgroundColor: color,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ===== DOUBLE BUTTON =====
  static Widget doubleButton({
    required String title1,
    required String title2,
    required Color color1,
    required Color color2,
    required VoidCallback onPressed1,
    required VoidCallback onPressed2,
    bool visible1 = true,
    bool visible2 = true,
    bool visibleSpace = true,
    Size? minimumSize,
    Color? shadowColor,
  }) {
    return Row(
      children: [
        Visibility(
          visible: visible1,
          child: Expanded(
            child: basicButton(
              title: title1,
              color: color1,
              onPressed: onPressed1,
              shadowColor: shadowColor,
              minimumSize: minimumSize,
            ),
          ),
        ),
        Visibility(visible: visibleSpace, child: const SizedBox(width: 10)),
        Visibility(
          visible: visible2,
          child: Expanded(
            child: basicButton(
              title: title2,
              color: color2,
              onPressed: onPressed2,
              shadowColor: shadowColor,
              minimumSize: minimumSize,
            ),
          ),
        ),
      ],
    );
  }

  /// ===== BOTTOM BAR STYLE =====
  static Widget bottomBarStyle({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
