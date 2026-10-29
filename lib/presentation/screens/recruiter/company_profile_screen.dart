import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class CompanyProfileScreen extends ConsumerWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final companyName = user?.industry?.isNotEmpty == true ? user!.industry! : 'Aman Traders Tech';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Company Header Card
              GlassCard(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppElevation.darkCardShadow(intensity: 0.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.apartment_rounded, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      companyName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI & Next-Gen Career Discovery Platform',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkSuccess.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(color: AppColors.darkSuccess.withValues(alpha: 0.4)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline_rounded, color: AppColors.darkSuccess, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Verified Employer',
                            style: TextStyle(color: AppColors.darkSuccess, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Company Details
              GlassCard(
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.language_rounded,
                      title: 'Website',
                      value: 'https://careerswipe.ai',
                      isDark: isDark,
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.location_on_outlined,
                      title: 'Headquarters',
                      value: 'Bengaluru, Karnataka, India',
                      isDark: isDark,
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.people_outline_rounded,
                      title: 'Company Size',
                      value: '11-50 employees',
                      isDark: isDark,
                    ),
                    const Divider(),
                    _buildInfoTile(
                      icon: Icons.category_outlined,
                      title: 'Industry',
                      value: 'Technology & Human Resources AI',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Recruiter Management Actions
              GlassCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.analytics_outlined, color: AppColors.darkPrimary),
                      title: const Text('Hiring Analytics', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => context.push('/recruiter/analytics'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.group_add_outlined, color: AppColors.darkSecondary),
                      title: const Text('Team Members', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Team management accessible to organization admin')),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.receipt_long_outlined, color: AppColors.darkWarning),
                      title: const Text('Billing & Subscription', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recruiter Enterprise Active Plan')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.darkPrimary),
          const SizedBox(width: AppSpacing.md),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

