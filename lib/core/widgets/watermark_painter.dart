import 'package:flutter/material.dart';

class WatermarkPainter extends CustomPainter {
  final String text;
  final Color color;

  WatermarkPainter({required this.text, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: color,
          decoration: TextDecoration.none,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    const horizontalGap = 100.0;
    const verticalGap = 120.0;

    canvas.save();

    canvas.translate(size.width / 2, size.height / 2);

    canvas.rotate(-0.45);

    for (double y = -size.height; y < size.height; y += verticalGap) {
      for (
        double x = -size.width;
        x < size.width;
        x += textPainter.width + horizontalGap
      ) {
        textPainter.paint(canvas, Offset(x, y));
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant WatermarkPainter oldDelegate) {
    return oldDelegate.text != text || oldDelegate.color != color;
  }
}
