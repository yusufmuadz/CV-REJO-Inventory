import 'package:flutter/material.dart';

import 'watermark_painter.dart';

class WatermarkOverlay extends StatelessWidget {
  final String version;
  final Widget child;

  const WatermarkOverlay({
    super.key,
    required this.child,
    this.version = 'v7.0.0',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        IgnorePointer(
          child: CustomPaint(
            painter: WatermarkPainter(
              text: version,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.15),
            ),
          ),
        ),
      ],
    );
  }
}
