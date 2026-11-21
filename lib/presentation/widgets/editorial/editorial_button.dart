// lib/presentation/widgets/editorial/editorial_button.dart
//
// Editorial Action Button adhering strictly to:
// - Height: 48px
// - Radius: 8px (Tier 2)
// - Primary: Spruce Green (#1E4B38)
// - Secondary: 1px hairline border (#E5E5E2), transparent fill
// - Ghost: flat text with zero padding overhead

import 'package:flutter/material.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

enum EditorialButtonVariant { primary, secondary, danger, ghost }

class EditorialButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final EditorialButtonVariant variant;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isLoading;
  final double? width;
  final double height;

  const EditorialButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = EditorialButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.width,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color bg;
    Color fg;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case EditorialButtonVariant.primary:
        bg = EditorialColors.primary;
        fg = EditorialColors.onPrimary;
        break;
      case EditorialButtonVariant.secondary:
        bg = isDark ? EditorialColors.darkContainerLow : Colors.transparent;
        fg = isDark ? EditorialColors.darkTextPrimary : EditorialColors.paperTextPrimary;
        borderSide = BorderSide(
          color: isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline,
          width: 1.0,
        );
        break;
      case EditorialButtonVariant.danger:
        bg = EditorialColors.danger;
        fg = Colors.white;
        break;
      case EditorialButtonVariant.ghost:
        bg = Colors.transparent;
        fg = isDark ? EditorialColors.darkTextSecondary : EditorialColors.paperTextSecondary;
        break;
    }

    final buttonChild = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: EditorialSpacing.spaceSm),
              ],
              Text(
                label,
                style: EditorialTypography.labelLg(color: fg),
                overflow: TextOverflow.ellipsis,
              ),
              if (trailingIcon != null) ...[
                const SizedBox(width: EditorialSpacing.spaceSm),
                trailingIcon!,
              ],
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: EditorialRadii.roundedMd,
          side: borderSide,
        ),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: EditorialRadii.roundedMd,
          splashColor: EditorialColors.primaryActive.withValues(alpha: 0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: EditorialSpacing.spaceMd),
            child: Center(child: buttonChild),
          ),
        ),
      ),
    );
  }
}
