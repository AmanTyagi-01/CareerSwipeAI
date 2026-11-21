// lib/presentation/widgets/editorial/editorial_card.dart
//
// Tactile paper card component with 16px radius, 1px solid hairline border,
// and physical paper drop shadow, exactly matching Stitch specifications.

import 'package:flutter/material.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

class EditorialCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final bool hasShadow;

  const EditorialCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(EditorialSpacing.spaceMd),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg =
        isDark ? EditorialColors.darkSurface : EditorialColors.paperSurface;
    final defaultBorder =
        isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline;
    final radius = borderRadius ?? EditorialRadii.roundedLg;

    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? defaultBorder,
          width: borderWidth,
        ),
        boxShadow: hasShadow
            ? (isDark
                ? EditorialElevation.paperCardDark
                : EditorialElevation.paperCard)
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: content,
        ),
      );
    }

    return content;
  }
}
