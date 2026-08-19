import 'package:flutter/material.dart';

import '../theme/text_styles.dart';

class Watermark extends StatelessWidget {
  final Widget child;

  const Watermark({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        child,

        IgnorePointer(
          child: Center(
            child: Transform.rotate(
              angle: -0.5,
              child: Text(
                'INVENTORY',
                style: TextStyles.basicTextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  decorationColor: Colors.transparent,
                  color: colorScheme.onSurface.withValues(alpha: 0.04),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
