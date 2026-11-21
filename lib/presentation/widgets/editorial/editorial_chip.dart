// lib/presentation/widgets/editorial/editorial_chip.dart
//
// CareerSwipe AI — Editorial Utility Chip / Tag Component
// Tier 1 Geometry (4px radius, 0.25rem vertical x 0.5rem horizontal padding)
// Strictly adheres to editorial_utility/DESIGN.md.

import 'package:flutter/material.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

enum EditorialChipVariant {
  neutral,
  matched,
  selected,
  outline,
}

class EditorialChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final EditorialChipVariant variant;
  final VoidCallback? onTap;
  final bool isSelected;
  final Widget? trailing;

  const EditorialChip({
    super.key,
    required this.label,
    this.icon,
    this.variant = EditorialChipVariant.neutral,
    this.onTap,
    this.isSelected = false,
    this.trailing,
  });

  /// Factory for skill match chip (with green check circle)
  factory EditorialChip.matched({
    Key? key,
    required String label,
    VoidCallback? onTap,
  }) {
    return EditorialChip(
      key: key,
      label: label,
      icon: Icons.check_circle_outline,
      variant: EditorialChipVariant.matched,
      onTap: onTap,
    );
  }

  /// Factory for neutral metadata chip
  factory EditorialChip.metadata({
    Key? key,
    required String label,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return EditorialChip(
      key: key,
      label: label,
      icon: icon,
      variant: EditorialChipVariant.neutral,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveVariant = isSelected ? EditorialChipVariant.selected : variant;

    Color bgColor;
    Color textColor;
    Border? border;

    switch (effectiveVariant) {
      case EditorialChipVariant.matched:
        bgColor = isDark
            ? EditorialColors.primaryContainer.withValues(alpha: 0.2)
            : const Color(0x1A1E4B38); // 10% Spruce
        textColor = isDark ? EditorialColors.onPrimaryContainer : EditorialColors.primary;
        border = Border.all(
          color: isDark
              ? EditorialColors.primaryContainer.withValues(alpha: 0.4)
              : EditorialColors.primary.withValues(alpha: 0.3),
          width: 1.0,
        );
        break;

      case EditorialChipVariant.selected:
        bgColor = isDark ? EditorialColors.primaryContainer : EditorialColors.primary;
        textColor = EditorialColors.onPrimary;
        border = null;
        break;

      case EditorialChipVariant.outline:
        bgColor = Colors.transparent;
        textColor = isDark ? EditorialColors.darkTextPrimary : EditorialColors.paperTextPrimary;
        border = Border.all(
          color: isDark ? EditorialColors.darkHairline : EditorialColors.paperHairline,
          width: 1.0,
        );
        break;

      case EditorialChipVariant.neutral:
        bgColor = isDark ? EditorialColors.darkContainerMid : const Color(0xFFF2F2EE);
        textColor = isDark ? EditorialColors.darkTextSecondary : EditorialColors.paperTextSecondary;
        border = null;
        break;
    }

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 13.0,
            color: textColor,
          ),
          const SizedBox(width: EditorialSpacing.spaceXs),
        ],
        Text(
          label,
          style: EditorialTypography.labelMd(
            color: textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: EditorialSpacing.spaceXs),
          trailing!,
        ],
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: EditorialRadii.roundedSm, // Tier 1: 4px
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            vertical: 4.0, // 0.25rem
            horizontal: 8.0, // 0.5rem
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: EditorialRadii.roundedSm,
            border: border,
          ),
          child: content,
        ),
      ),
    );
  }
}
