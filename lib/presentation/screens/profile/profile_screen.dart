import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/providers/auth_provider.dart';

/// Profile & Settings Screen matching Poster 1 Screen 10 & Poster 2 Screen 10:
/// - User Avatar with "Aman Tyagi", "Software Developer", and "Edit Profile" link
/// - Menu list:
///   1. Resume
///   2. Skills & Certifications
///   3. Experience
///   4. Education
///   5. Saved Jobs
///   6. Career Preferences / Insights
///   7. Theme (System Default / Dark / Light)
///   8. Notifications
///   9. Privacy & Security
///   10. Help & Support
///   11. Switch to Recruiter Mode / Sign Out
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final userName = user?.displayName ?? 'Aman Tyagi';
    final userRole = user?.experienceLevel ?? 'Software Developer';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        title: const Text(
          'Profile & Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // User Avatar & Name Card
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                            ),
                            border: Border.all(color: const Color(0xFF2A334A), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 2,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF0A0E17), width: 2.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      userRole,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => context.push('/profile/edit'),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Menu Options (Exact order from poster)
              _buildMenuItem(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Resume',
                onTap: () => context.push('/resume/upload'),
              ),
              _buildMenuItem(
                icon: Icons.verified_outlined,
                iconColor: const Color(0xFF38BDF8),
                title: 'Skills & Certifications',
                onTap: () => context.push('/resume/skills'),
              ),
              _buildMenuItem(
                icon: Icons.work_outline_rounded,
                iconColor: const Color(0xFF10B981),
                title: 'Experience',
                onTap: () => context.push('/profile/edit'),
              ),
              _buildMenuItem(
                icon: Icons.school_outlined,
                iconColor: const Color(0xFFF59E0B),
                title: 'Education',
                onTap: () => context.push('/profile/edit'),
              ),
              _buildMenuItem(
                icon: Icons.bookmark_outline_rounded,
                iconColor: const Color(0xFFA78BFA),
                title: 'Saved Jobs',
                onTap: () => context.push('/profile/saved-jobs'),
              ),
              _buildMenuItem(
                icon: Icons.trending_up_rounded,
                iconColor: const Color(0xFF06B6D4),
                title: 'Career Preferences',
                onTap: () => context.push('/ai/assistant'),
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFF1E2436), height: 1),
              const SizedBox(height: 16),

              _buildMenuItem(
                icon: Icons.dark_mode_outlined,
                iconColor: const Color(0xFF8B5CF6),
                title: 'Theme',
                trailingText: 'System >',
                onTap: () => context.push('/profile/settings'),
              ),
              _buildMenuItem(
                icon: Icons.notifications_none_rounded,
                iconColor: const Color(0xFFFBBF24),
                title: 'Notifications',
                onTap: () => context.push('/profile/notifications'),
              ),
              _buildMenuItem(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF38BDF8),
                title: 'Privacy & Security',
                onTap: () => context.push('/profile/settings'),
              ),
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                iconColor: const Color(0xFF94A3B8),
                title: 'Help & Support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support concierge available 24/7 at support@careerswipe.ai'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Switch to Recruiter Mode / Role Switch
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF121622),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF232A3B)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.swap_horiz_rounded, color: Color(0xFF8B5CF6), size: 24),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recruiter Mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Post jobs and discover candidates',
                            style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: user?.userType == UserType.recruiter,
                      activeThumbColor: const Color(0xFF8B5CF6),
                      onChanged: (val) async {
                        final newType = val ? UserType.recruiter : UserType.talent;
                        await ref.read(authNotifierProvider.notifier).updateRole(newType);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sign Out
              TextButton(
                onPressed: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (context.mounted) context.go('/auth/login');
                },
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                ] else ...[
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
