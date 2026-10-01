import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;

  static bool debugDisableAnimations = false;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.particleCount = 20,
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

    final count = AnimatedBackground.debugDisableAnimations ? 0 : widget.particleCount;

    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        duration: Duration(seconds: 3 + _random.nextInt(5)),
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
        size: 2 + _random.nextDouble() * 4,
        speed: 0.2 + _random.nextDouble() * 0.5,
        opacity: 0.1 + _random.nextDouble() * 0.3,
        color: _random.nextBool() 
          ? const Color(0xFF6366F1) 
          : const Color(0xFF06B6D4),
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
    return Stack(
      children: [
        // Gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: Theme.of(context).brightness == Brightness.dark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [const Color(0xFFF8FAFC), const Color(0xFFEEF2FF), const Color(0xFFF8FAFC)],
            ),
          ),
        ),
        // Animated particles
        ...List.generate(_animations.length, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              final particle = _particles[index];
              final offset = _animations[index].value * particle.speed;

              return Positioned(
                left: (particle.x + offset * 0.1) * MediaQuery.of(context).size.width,
                top: (particle.y + offset * 0.15) * MediaQuery.of(context).size.height,
                child: Container(
                  width: particle.size,
                  height: particle.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: particle.color.withValues(
                      alpha: particle.opacity * (0.5 + 0.5 * sin(_animations[index].value * pi * 2)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: particle.color.withValues(alpha: particle.opacity * 0.5),
                        blurRadius: particle.size * 2,
                        spreadRadius: particle.size * 0.5,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
        // Main content
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
