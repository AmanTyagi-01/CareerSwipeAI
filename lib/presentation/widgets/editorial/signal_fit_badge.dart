// lib/presentation/widgets/editorial/signal_fit_badge.dart
//
// CareerSwipe AI — Editorial Utility Signal Fit Badge & Grounded Match Ledger
// Provides tactile proof-of-fit telemetry badges and expandable evidence cards.
// Strictly adheres to editorial_utility/DESIGN.md.

import 'package:flutter/material.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

class SignalFitBadge extends StatelessWidget {
  final double? score; // e.g., 94.8 or 0.948
  final String? customLabel;
  final bool isVerified;
  final VoidCallback? onTap;

  const SignalFitBadge({
    super.key,
    this.score,
    this.customLabel,
    this.isVerified = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final formattedScore = score != null
        ? (score! <= 1.0 ? '${(score! * 100).toStringAsFixed(1)}%' : '${score!.toStringAsFixed(1)}%')
        : null;

    final label = customLabel ??
        (formattedScore != null ? '$formattedScore SIGNAL MATCH' : 'VERIFIED MATCH');

    final baseColor = isDark ? EditorialColors.onPrimaryContainer : EditorialColors.primary;
    final bgColor = isDark
        ? EditorialColors.primaryContainer.withValues(alpha: 0.2)
        : EditorialColors.stampInterestedBg;

    return InkWell(
      onTap: onTap,
      borderRadius: EditorialRadii.roundedFull,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: EditorialRadii.roundedFull,
          border: Border.all(
            color: baseColor.withValues(alpha: 0.35),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Signal dot
            Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: isVerified ? EditorialColors.primary : EditorialColors.warning,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: EditorialTypography.labelStamp(color: baseColor),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inset Evidence Match Ledger Card
/// Used inside swipe decks and job details to display verified resume overlap.
class GroundedMatchLedger extends StatelessWidget {
  final String pointsRatio; // e.g. "6 / 7 Points"
  final String explanation;
  final VoidCallback? onSpecDetailsTap;

  const GroundedMatchLedger({
    super.key,
    required this.pointsRatio,
    required this.explanation,
    this.onSpecDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(EditorialSpacing.spaceSm),
      decoration: BoxDecoration(
        color: isDark ? EditorialColors.darkContainerMid : EditorialColors.paperSurface,
        borderRadius: EditorialRadii.roundedMd, // 8px radius
        border: Border.all(
          color: isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline,
          width: 1.0,
        ),
        boxShadow: isDark ? null : EditorialElevation.paperCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 16.0,
                    color: isDark
                        ? EditorialColors.onPrimaryContainer
                        : EditorialColors.primaryContainer,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    'GROUNDED MATCH LEDGER',
                    style: EditorialTypography.labelStamp(
                      color: isDark
                          ? EditorialColors.onPrimaryContainer
                          : EditorialColors.primaryContainer,
                    ),
                  ),
                ],
              ),
              Text(
                pointsRatio,
                style: EditorialTypography.labelMd(
                  color: isDark
                      ? EditorialColors.onPrimaryContainer
                      : EditorialColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Text(
            explanation,
            style: EditorialTypography.bodySm(
              color: isDark
                  ? EditorialColors.darkTextSecondary
                  : EditorialColors.paperTextSecondary,
            ),
          ),
          if (onSpecDetailsTap != null) ...[
            const SizedBox(height: 4.0),
            GestureDetector(
              onTap: onSpecDetailsTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tap to view full spec & evidence breakdown',
                    style: EditorialTypography.labelMd(
                      color: isDark
                          ? EditorialColors.darkTextSecondary
                          : EditorialColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 2.0),
                  Icon(
                    Icons.expand_less,
                    size: 16.0,
                    color: isDark
                        ? EditorialColors.darkTextSecondary
                        : EditorialColors.secondary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
