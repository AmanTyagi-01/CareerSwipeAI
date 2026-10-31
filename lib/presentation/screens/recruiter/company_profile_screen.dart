import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';

class CompanyProfileScreen extends ConsumerWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final companyName = user?.industry?.isNotEmpty == true ? user!.industry! : 'Aman Traders Tech';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('Company Profile', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF94A3B8)),
            onPressed: () => context.push('/profile/settings'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Company Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF121622),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF232A3B)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.apartment_rounded, color: Colors.white, size: 38),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      companyName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'AI & Next-Gen Talent Marketplace',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.35)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Verified Employer',
                            style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.1, end: 0),

              const SizedBox(height: 20),

              // Company Details
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF121622),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF232A3B)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(icon: Icons.language_rounded, title: 'Website', value: 'https://careerswipe.ai'),
                    const Divider(color: Color(0xFF232A3B), height: 20),
                    _buildInfoRow(icon: Icons.location_on_outlined, title: 'Headquarters', value: 'Bengaluru, India'),
                    const Divider(color: Color(0xFF232A3B), height: 20),
                    _buildInfoRow(icon: Icons.groups_outlined, title: 'Company Size', value: '11-50 employees'),
                    const Divider(color: Color(0xFF232A3B), height: 20),
                    _buildInfoRow(icon: Icons.business_center_outlined, title: 'Domain', value: 'Technology & AI'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Management Tiles
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF121622),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF232A3B)),
                ),
                child: Column(
                  children: [
                    _buildNavTile(
                      icon: Icons.analytics_outlined,
                      color: const Color(0xFF8B5CF6),
                      title: 'Hiring Analytics',
                      subtitle: 'Review conversion funnel and applicant sources',
                      onTap: () => context.push('/recruiter/analytics'),
                    ),
                    const Divider(color: Color(0xFF232A3B), height: 1),
                    _buildNavTile(
                      icon: Icons.group_add_outlined,
                      color: const Color(0xFF38BDF8),
                      title: 'Team Members (5)',
                      subtitle: 'Manage recruiters, hiring managers & reviewers',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('5 active team members in workspace')),
                        );
                      },
                    ),
                    const Divider(color: Color(0xFF232A3B), height: 1),
                    _buildNavTile(
                      icon: Icons.receipt_long_outlined,
                      color: const Color(0xFFF59E0B),
                      title: 'Billing & Invoices',
                      subtitle: 'Enterprise Unlimited Recruiter Plan',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Subscription active. Next billing in 28 days.')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF8B5CF6)),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFF1F5F9), fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
      ],
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 20),
          ],
        ),
      ),
    );
  }
}
