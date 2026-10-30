import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../widgets/common/app_brand_logo.dart';

/// Splash screen matching the visual blueprint in reference poster:
/// - Ethereal dark obsidian background (#0A0E17)
/// - Glowing 3D delta CareerSwipe AI ribbon logo
/// - Brand typography: "CareerSwipe AI"
/// - Tagline: "Your Career, Supercharged."
/// - Sub-tagline: "Find jobs, Build skills, Grow your career."
/// - Glowing bottom neon cosmic swirl ring
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasNavigated = false;
  Timer? _splashTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();

    // Give splash time to display animations then navigate
    _splashTimer = Timer(const Duration(milliseconds: 2500), _navigate);
  }

  void _navigate() {
    if (!mounted || _hasNavigated) return;
    final authState = ref.read(authProvider);
    if (authState.isLoading) return;

    _hasNavigated = true;
    authState.when(
      data: (user) {
        if (user != null) {
          context.go('/home');
        } else {
          context.go('/onboarding');
        }
      },
      loading: () {},
      error: (_, __) => context.go('/onboarding'),
    );
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (_, next) {
      if (!next.isLoading && !_hasNavigated) {
        _navigate();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Stack(
        children: [
          // Ambient neon glow in top center
          Positioned(
            top: -120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.18),
                ),
              ),
            ),
          ),

          // Central branding
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),

                // Glowing geometric delta logo
                const AppBrandLogo(size: 110, showGlow: true)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1), curve: Curves.easeOutBack)
                    .shimmer(duration: 1800.ms, delay: 500.ms),

                const SizedBox(height: 28),

                // Brand Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFE0E7FF), Color(0xFFA78BFA)],
                  ).createShader(bounds),
                  child: const Text(
                    'CareerSwipe AI',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 10),

                // Neon violet punchy hook
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                  ).createShader(bounds),
                  child: const Text(
                    'Your Career, Supercharged.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms),

                const SizedBox(height: 12),

                // Three-pillar subtitle
                const Text(
                  'Find jobs, Build skills, Grow your career.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 0.1,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 600.ms),

                const Spacer(flex: 2),

                // Glowing cosmic swirl orb at bottom
                Container(
                  width: 220,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(110)),
                    gradient: const RadialGradient(
                      center: Alignment.bottomCenter,
                      radius: 0.9,
                      colors: [
                        Color(0xFF38BDF8),
                        Color(0xFF8B5CF6),
                        Color(0x000A0E17),
                      ],
                      stops: [0.0, 0.45, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 900.ms)
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
