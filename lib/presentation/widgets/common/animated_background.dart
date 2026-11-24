import 'package:flutter/material.dart';
import 'dart:math';
import '../../../config/theme.dart';

/// Editorial Utility Minimal Canvas Background
///
/// Replaces bright neon purple/cyan glowing particles with a clean,
/// archival paper (#FBFBFA / #F9F9F8) or rich charcoal (#121314) canvas
/// with optional subtle tonal atmosphere.
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;

  static bool debugDisableAnimations = false;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.particleCount = 12,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _animations = [];
    _particles = [];

    final count =
        AnimatedBackground.debugDisableAnimations ? 0 : widget.particleCount;

    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: 4 + _random.nextInt(6)),
        vsync: this,
      );

      final animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );

      _controllers.add(controller);
      _animations.add(animation);
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 2 + _random.nextDouble() * 3,
        speed: 0.1 + _random.nextDouble() * 0.3,
        opacity: 0.03 + _random.nextDouble() * 0.06,
        color: _random.nextBool()
            ? EditorialColors.primary
            : EditorialColors.secondary,
      ));

      controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Editorial paper canvas
        Container(
          color: isDark
              ? EditorialColors.darkBackground
              : EditorialColors.paperBackground,
        ),
        // Subtle tonal ambient particles
        if (_animations.isNotEmpty)
          ...List.generate(_animations.length, (index) {
            return AnimatedBuilder(
              animation: _animations[index],
              builder: (context, child) {
                final particle = _particles[index];
                final progress = _animations[index].value;

                return Positioned(
                  left: MediaQuery.of(context).size.width * particle.x,
                  top: MediaQuery.of(context).size.height *
                      (particle.y + progress * 0.08) %
                      MediaQuery.of(context).size.height,
                  child: Container(
                    width: particle.size,
                    height: particle.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: particle.color.withValues(
                        alpha: particle.opacity * (0.8 + progress * 0.2),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        widget.child,
      ],
    );
  }
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final Color color;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.color,
  });
}
