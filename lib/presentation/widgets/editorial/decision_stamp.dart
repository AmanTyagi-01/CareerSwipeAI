// lib/presentation/widgets/editorial/decision_stamp.dart
//
// Editorial Decision Stamp component adhering strictly to:
// - 4px radius (Tier 1)
// - 1.5px solid border
// - labelStamp typography (Inter 11px uppercase, tracking 0.08em)
// - 'INTERESTED': Deep Spruce Green (#1E4B38)
// - 'PASS': Muted Slate (#636A70)

import 'package:flutter/material.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

enum StampType { interested, pass, custom }

class DecisionStamp extends StatelessWidget {
  final String label;
  final StampType type;
  final Color? color;
  final Color? backgroundColor;
  final double angle; // Subtle rotation for physical stamp realism

  const DecisionStamp({
    super.key,
    required this.label,
    this.type = StampType.interested,
    this.color,
    this.backgroundColor,
    this.angle = 0.0,
  });

  const DecisionStamp.interested({super.key, this.angle = -0.05, this.color, this.backgroundColor})
      : label = 'INTERESTED',
        type = StampType.interested;

  const DecisionStamp.pass({super.key, this.angle = 0.05, this.color, this.backgroundColor})
      : label = 'PASS',
        type = StampType.pass;

  @override
  Widget build(BuildContext context) {
    Color stampColor;
    Color stampBg;

    switch (type) {
      case StampType.interested:
        stampColor = EditorialColors.stampInterested;
        stampBg = EditorialColors.stampInterestedBg;
        break;
      case StampType.pass:
        stampColor = EditorialColors.stampPass;
        stampBg = EditorialColors.stampPassBg;
        break;
      case StampType.custom:
        stampColor = color ?? EditorialColors.primary;
        stampBg = backgroundColor ?? stampColor.withValues(alpha: 0.08);
        break;
    }

    final Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: stampBg,
        borderRadius: EditorialRadii.roundedSm,
        border: Border.all(
          color: stampColor,
          width: 1.5,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: EditorialTypography.labelStamp(color: stampColor),
      ),
    );

    if (angle != 0.0) {
      return Transform.rotate(
        angle: angle,
        child: content,
      );
    }

    return content;
  }
}
