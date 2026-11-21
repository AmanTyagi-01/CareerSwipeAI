import 'package:flutter/material.dart';

/// The official CareerSwipe AI brand logo widget.
/// Renders the signature geometric delta "A" ribbon emblem in
/// vibrant violet-to-cyan gradient with optional neon glow.
class AppBrandLogo extends StatelessWidget {
  final double size;
  final bool showGlow;
  final bool animated;

  const AppBrandLogo({
    super.key,
    this.size = 48,
    this.showGlow = true,
    this.animated = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showGlow)
            Container(
              width: size * 0.85,
              height: size * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.45),
                    blurRadius: size * 0.45,
                    spreadRadius: size * 0.1,
                  ),
                  BoxShadow(
                    color: const Color(0xFF06B6D4).withValues(alpha: 0.35),
                    blurRadius: size * 0.35,
                    spreadRadius: size * 0.05,
                  ),
                ],
              ),
            ),
          CustomPaint(
            size: Size(size, size),
            painter: _BrandLogoPainter(),
          ),
        ],
      ),
    );
  }
}

class _BrandLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer ribbon gradient (violet to cyan)
    final gradient1 = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFA78BFA), // light violet
        Color(0xFF7C3AED), // vivid violet
        Color(0xFF4F46E5), // indigo
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Crossbar / foreground ribbon gradient (cyan to teal)
    final gradient2 = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        Color(0xFF06B6D4), // cyan
        Color(0xFF38BDF8), // sky
        Color(0xFFA78BFA), // violet
      ],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final paint1 = Paint()
      ..shader = gradient1
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final paint2 = Paint()
      ..shader = gradient2
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Left apex down-stroke of the stylized delta "A"
    final leftPath = Path()
      ..moveTo(w * 0.50, h * 0.10)
      ..lineTo(w * 0.15, h * 0.86)
      ..lineTo(w * 0.35, h * 0.86)
      ..lineTo(w * 0.50, h * 0.45)
      ..close();

    // Right apex down-stroke of the stylized delta "A"
    final rightPath = Path()
      ..moveTo(w * 0.50, h * 0.10)
      ..lineTo(w * 0.50, h * 0.45)
      ..lineTo(w * 0.65, h * 0.86)
      ..lineTo(w * 0.85, h * 0.86)
      ..close();

    // The forward dynamic cross-wing ribbon (gives the 'Swipe' feel)
    final swipeWing = Path()
      ..moveTo(w * 0.22, h * 0.64)
      ..lineTo(w * 0.78, h * 0.52)
      ..lineTo(w * 0.84, h * 0.64)
      ..lineTo(w * 0.32, h * 0.76)
      ..close();

    canvas.drawPath(leftPath, paint1);
    canvas.drawPath(rightPath, paint1);
    canvas.drawPath(swipeWing, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
