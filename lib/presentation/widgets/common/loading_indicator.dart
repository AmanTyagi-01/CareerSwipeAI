import 'package:flutter/material.dart';
import '../../../config/theme.dart';

/// Editorial Utility Loading Indicator
///
/// - Uses Spruce Green (#1E4B38) for circular indicator
/// - Inter typography for loading message
class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const AppLoadingIndicator({
    super.key,
    this.size = 40,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = color ?? EditorialColors.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 14),
          Text(
            message!,
            style: EditorialTypography.bodyMd(
              color: isDark
                  ? EditorialColors.darkTextSecondary
                  : EditorialColors.paperTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Editorial Utility Skeleton Loader
///
/// Subtle paper container skeleton with 8px radius
class SkeletonLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoading({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? EditorialColors.darkContainerMid
            : EditorialColors.paperContainerMid,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: const SizedBox(),
    );
  }
}
