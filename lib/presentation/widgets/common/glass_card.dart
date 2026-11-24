import 'package:flutter/material.dart';
import '../../../config/theme.dart';

/// Editorial Utility Paper Card
///
/// Replaces the legacy frosted-glass container with the blueprint's
/// tactile paper card:
/// - 16px radius (Tier 3: EditorialRadii.roundedLg)
/// - 1px hairline stroke (EditorialColors.paperHairline / darkHairline)
/// - Flat paper surface with subtle tactile paper depth
/// - Clean tap feedback via InkWell
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 0,
    this.opacity = 1.0,
    this.borderColor,
    this.backgroundColor,
    this.boxShadow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderRadius = borderRadius ?? EditorialRadii.roundedLg;
    final effectiveBorderColor = borderColor ??
        (isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline);
    final effectiveBgColor = backgroundColor ??
        (isDark ? EditorialColors.darkSurface : EditorialColors.paperSurface);
    final effectiveShadow = boxShadow ??
        (isDark
            ? EditorialElevation.paperCardDark
            : EditorialElevation.paperCard);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveShadow,
        border: Border.all(
          color: effectiveBorderColor,
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveBorderRadius,
            splashColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : EditorialColors.primary.withValues(alpha: 0.05),
            highlightColor: isDark
                ? Colors.white.withValues(alpha: 0.02)
                : EditorialColors.primary.withValues(alpha: 0.02),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
