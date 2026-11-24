import 'package:flutter/material.dart';
import '../../../config/theme.dart';

/// CareerSwipe AI Brand Emblem (Editorial Utility)
///
/// Features:
/// - Crisp geometric delta "A" monogram in Spruce Green palette (#1E4B38)
/// - Subtly elevated on tactile paper surface
/// - Clean vector geometry with zero artificial neon blur
class AppBrandLogo extends StatelessWidget {
  final double size;
  final bool showGlow;
  final bool animated;

  const AppBrandLogo({
    super.key,
    this.size = 48,
    this.showGlow = false,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark
            ? EditorialColors.darkSurface
            : EditorialColors.paperSurface,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: isDark
              ? EditorialColors.darkHairline
              : EditorialColors.paperHairline,
          width: 1.0,
        ),
        boxShadow: isDark
            ? EditorialElevation.paperCardDark
            : EditorialElevation.paperCard,
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.65, size * 0.65),
          painter: _BrandLogoPainter(),
        ),
      ),
    );
  }
}

class _BrandLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Spruce green gradient (primary to dark spruce)
    final gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        EditorialColors.primary,
        EditorialColors.primaryDark,
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Left apex down-stroke of the stylized delta "A"
    final leftPath = Path()
      ..moveTo(w * 0.50, h * 0.10)
      ..lineTo(w * 0.15, h * 0.88)
      ..lineTo(w * 0.38, h * 0.88)
      ..lineTo(w * 0.50, h * 0.48)
      ..close();

    // Right apex down-stroke
    final rightPath = Path()
      ..moveTo(w * 0.50, h * 0.10)
      ..lineTo(w * 0.85, h * 0.88)
      ..lineTo(w * 0.62, h * 0.88)
      ..lineTo(w * 0.50, h * 0.48)
      ..close();

    // Horizontal bridge / chevron crossbar in sage (#8BBAA2)
    final bridgePath = Path()
      ..moveTo(w * 0.28, h * 0.68)
      ..lineTo(w * 0.72, h * 0.68)
      ..lineTo(w * 0.64, h * 0.56)
      ..lineTo(w * 0.36, h * 0.56)
      ..close();

    final bridgePaint = Paint()
      ..color = EditorialColors.onPrimaryContainer
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);
    canvas.drawPath(bridgePath, bridgePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
