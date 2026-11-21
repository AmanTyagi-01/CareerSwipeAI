// lib/presentation/widgets/editorial/editorial_text_field.dart
//
// Editorial Text Input adhering strictly to:
// - Height: 44px
// - Radius: 8px (Tier 2)
// - Background: White (#FFFFFF) in light, #1E2022 in dark
// - Border: 1px hairline (#E5E5E2)
// - Focus: 1.5px solid Spruce Green (#1E4B38), zero glow halos

import 'package:flutter/material.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

class EditorialTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final bool autofocus;
  final bool readOnly;

  const EditorialTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.autofocus = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? EditorialColors.darkTextPrimary
        : EditorialColors.paperTextPrimary;
    final hintColor = isDark
        ? EditorialColors.darkPlaceholder
        : EditorialColors.paperPlaceholder;

    final Widget field = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines,
      autofocus: autofocus,
      readOnly: readOnly,
      style: EditorialTypography.bodyMd(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: EditorialTypography.bodyMd(color: hintColor),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      ),
    );

    if (label != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label!,
            style: EditorialTypography.labelMd(
              color: isDark
                  ? EditorialColors.darkTextSecondary
                  : EditorialColors.paperTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: EditorialSpacing.spaceSm),
          field,
        ],
      );
    }

    return field;
  }
}
