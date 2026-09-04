import 'package:flutter/material.dart';

import 'watermark_painter.dart';

class WatermarkOverlay extends StatelessWidget {
  final String version;
  final Widget child;

  const WatermarkOverlay({
    super.key,
    required this.child,
    this.version = 'v9.0.0',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          bottom: 80,
          right: 0,
          left: 0,
          child: Center(
            child: Text(
              version,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.15),
              ),
            ),
          ),
        ),
        // IgnorePointer(
        //   child: CustomPaint(
        //     painter: WatermarkPainter(
        //       text: version,
        //       color: Theme.of(
        //         context,
        //       ).colorScheme.onSurface.withValues(alpha: 0.15),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
