import 'package:flutter/material.dart';
import '../../../config/theme.dart';

/// Primary Call-To-Action Button (Editorial Utility)
///
/// Features:
/// - Spruce Green background (#1E4B38)
/// - Pure White typography (#FFFFFF, Inter w600)
/// - Tier 2 radius (8px: EditorialRadii.roundedMd)
/// - Flat tactile elevation (0dp)
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.0,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: EditorialColors.primary,
          foregroundColor: EditorialColors.onPrimary,
          disabledBackgroundColor:
              EditorialColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: EditorialRadii.roundedMd,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style:
                          EditorialTypography.labelLg(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Secondary / Outlined Button (Editorial Utility)
///
/// Replaces the legacy glass button with a tactile paper outlined button:
/// - 1px structural hairline border (#E5E5E2 / #2F3235)
/// - Paper container or surface fill
/// - Tier 2 radius (8px: EditorialRadii.roundedMd)
/// - Inter w600 typography
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? width;
  final double? height;
  final Widget? icon;
  final Color? textColor;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.height,
    this.icon,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTextColor = textColor ??
        (isDark
            ? EditorialColors.darkTextPrimary
            : EditorialColors.paperTextPrimary);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.0,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark
              ? EditorialColors.darkContainerLow
              : EditorialColors.paperSurface,
          foregroundColor: effectiveTextColor,
          elevation: 0,
          side: BorderSide(
            color: isDark
                ? EditorialColors.darkHairline
                : EditorialColors.paperHairline,
            width: 1.0,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: EditorialRadii.roundedMd,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: EditorialTypography.labelLg(
                          color: effectiveTextColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Social Provider Auth Button (Editorial Utility)
///
/// Features:
/// - 1px structural hairline border
/// - Paper container background
/// - Tier 2 radius (8px)
/// - Inter w600 label
class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final String iconPath;
  final Color? backgroundColor;
  final Color? textColor;

  const SocialButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.iconPath,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTextColor = textColor ??
        (isDark
            ? EditorialColors.darkTextPrimary
            : EditorialColors.paperTextPrimary);

    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Image.asset(
          iconPath,
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.account_circle_outlined,
            size: 20,
            color: effectiveTextColor,
          ),
        ),
        label: Text(
          text,
          style: EditorialTypography.labelLg(color: effectiveTextColor),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ??
              (isDark
                  ? EditorialColors.darkContainerLow
                  : EditorialColors.paperSurface),
          foregroundColor: effectiveTextColor,
          elevation: 0,
          side: BorderSide(
            color: isDark
                ? EditorialColors.darkHairline
                : EditorialColors.paperHairline,
            width: 1.0,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: EditorialRadii.roundedMd,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    );
  }
}
