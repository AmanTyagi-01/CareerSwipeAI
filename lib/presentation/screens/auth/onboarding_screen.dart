import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';

/// Onboarding Screen matching the exact visual designs in the posters:
/// - Screen 1: Hero Welcome "Build Your Career with AI" with 3D glowing hologram card,
///   "Get Started" gradient CTA, and "I already have an account".
/// - Screen 2: "Choose Your Role" with selectable "I'm a Job Seeker" vs. "I'm a Recruiter" cards.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  UserType _selectedRole = UserType.talent;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToRoleSelection() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _completeOnboarding() {
    // Save selected role and navigate to login/signup
    ref.read(selectedUserTypeProvider.notifier).state = _selectedRole;
    context.go('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Stack(
        children: [
          // Ambient background glow
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
              ),
            ),
          ),

          SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (_) {},
              children: [
                _buildHeroStep(),
                _buildRoleSelectionStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 1: Hero Welcome (Poster 1 Screen 2) -----------------------------
  Widget _buildHeroStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => context.go('/auth/login'),
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Spacer(),

          // 3D Isometric Hologram Hero Card
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E2235), Color(0xFF121622)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.22),
                  blurRadius: 36,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Cyan grid circle
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                ),
                // Glowing central AI node
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                // Floating candidate avatars
                Positioned(
                  left: 36,
                  top: 48,
                  child: _buildFloatingBadge(Icons.person, const Color(0xFF8B5CF6)),
                ),
                Positioned(
                  right: 36,
                  top: 56,
                  child: _buildFloatingBadge(Icons.business_center, const Color(0xFF06B6D4)),
                ),
                Positioned(
                  bottom: 32,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E17).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2A334A)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, color: Color(0xFF38BDF8), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'AI-Powered Match Engine',
                          style: TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: Curves.easeOutBack)
              .fadeIn(),

          const Spacer(),

          const Text(
            'Build Your Career with AI',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 12),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Find the right jobs, get AI insights and land your dream role.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF94A3B8),
                height: 1.4,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms),

          const Spacer(),

          // "Get Started" gradient CTA
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _goToRoleSelection,
                child: const Center(
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 500.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 14),

          // "I already have an account"
          TextButton(
            onPressed: () => context.go('/auth/login'),
            child: const Text(
              'I already have an account',
              style: TextStyle(
                color: Color(0xFFCBD5E1),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFloatingBadge(IconData icon, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2235),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  // --- Step 2: Role Selection (Poster 2 Screen 2) ---------------------------
  Widget _buildRoleSelectionStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
          const SizedBox(height: 16),

          const Text(
            'Choose Your Role',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),

          const Text(
            'How do you want to use CareerSwipe AI?',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 36),

          // Card 1: Job Seeker
          _buildRoleCard(
            type: UserType.talent,
            title: "I'm a Job Seeker",
            subtitle: 'Find jobs, internships and grow your career.',
            icon: Icons.person_search_rounded,
            badgeColor: const Color(0xFF8B5CF6),
          ),

          const SizedBox(height: 18),

          // Card 2: Recruiter
          _buildRoleCard(
            type: UserType.recruiter,
            title: "I'm a Recruiter",
            subtitle: 'Hire top talent and build your dream team.',
            icon: Icons.business_center_rounded,
            badgeColor: const Color(0xFF06B6D4),
          ),

          const Spacer(),

          // "Continue" gradient CTA
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _completeOnboarding,
                child: const Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required UserType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color badgeColor,
  }) {
    final isSelected = _selectedRole == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E2333) : const Color(0xFF121620),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B5CF6)
                : const Color(0xFF232A3B),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: badgeColor.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(icon, color: badgeColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF475569),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
