// lib/presentation/widgets/editorial/facts_matrix_2x2.dart
//
// CareerSwipe AI — Editorial Utility Facts Matrix Component
// Structured 2x2 scannable data grid for role terms, compensation, and SLA telemetry.
// Strictly adheres to editorial_utility/DESIGN.md.

import 'package:flutter/material.dart';
import 'package:career_swipe_ai/theme/editorial_theme.dart';

class FactItem {
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? valueFontWeight;

  const FactItem({
    required this.label,
    required this.value,
    this.valueColor,
    this.valueFontWeight,
  });
}

class FactsMatrix2x2 extends StatelessWidget {
  final List<FactItem> items;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const FactsMatrix2x2({
    super.key,
    required this.items,
    this.padding,
    this.backgroundColor,
  }) : assert(items.length <= 4,
            'FactsMatrix2x2 accepts up to 4 items in a 2x2 grid');

  /// Convenience constructor for the standard CareerSwipe AI 4-fact block:
  /// Target Comp, Commitment/Hub, Seniority/Team, and Listing SLA.
  factory FactsMatrix2x2.standard({
    Key? key,
    required String targetComp,
    required String commitment,
    required String seniority,
    required String listingAge,
  }) {
    return FactsMatrix2x2(
      key: key,
      items: [
        FactItem(
          label: 'TARGET COMP',
          value: targetComp,
          valueFontWeight: FontWeight.w600,
        ),
        FactItem(
          label: 'COMMITMENT',
          value: commitment,
          valueFontWeight: FontWeight.w600,
        ),
        FactItem(
          label: 'SENIORITY',
          value: seniority,
        ),
        FactItem(
          label: 'LISTING AGE',
          value: listingAge,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark
        ? EditorialColors.darkContainerLow
        : EditorialColors.paperContainerLow;

    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      final item1 = items[i];
      final item2 = (i + 1 < items.length) ? items[i + 1] : null;

      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildCell(context, item1, isDark),
            ),
            const SizedBox(width: EditorialSpacing.spaceSm),
            Expanded(
              child: item2 != null
                  ? _buildCell(context, item2, isDark)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );

      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: EditorialSpacing.spaceSm));
      }
    }

    return Container(
      padding: padding ?? const EdgeInsets.all(EditorialSpacing.spaceSm),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: EditorialRadii.roundedMd, // Tier 2: 8px
        border: Border.all(
          color: isDark
              ? EditorialColors.darkHairline
              : EditorialColors.paperHairline,
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );
  }

  Widget _buildCell(BuildContext context, FactItem item, bool isDark) {
    final defaultTextColor = isDark
        ? EditorialColors.darkTextPrimary
        : EditorialColors.paperTextPrimary;
    final labelColor =
        isDark ? EditorialColors.darkTextTertiary : EditorialColors.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.label.toUpperCase(),
          style: EditorialTypography.labelStamp(color: labelColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2.0),
        Text(
          item.value,
          style: EditorialTypography.bodyMd(
            color: item.valueColor ?? defaultTextColor,
            fontWeight: item.valueFontWeight ?? FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
