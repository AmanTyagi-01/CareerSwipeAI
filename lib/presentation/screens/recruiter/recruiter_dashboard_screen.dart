import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';

class RecruiterDashboardScreen extends ConsumerWidget {
  const RecruiterDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final displayName = user?.displayName?.split(' ').first ?? 'Recruiter';
    final companyName = user?.industry?.isNotEmpty == true ? user!.industry! : 'Aman Traders Tech';

    final applicantsAsync = ref.watch(jobApplicantsProvider(''));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Container(
        color: const Color(0xFF0A0E17),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(jobApplicantsProvider(''));
              ref.invalidate(recruiterJobsProvider(user?.id ?? ''));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                            child: const Icon(Icons.business_rounded, color: Color(0xFF8B5CF6), size: 28),
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Evening, $displayName!',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFF1F5F9),
                                ),
                              ),
                              Text(
                                companyName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => context.push('/profile/notifications'),
                        icon: const Icon(Icons.notifications_outlined, color: Color(0xFFF1F5F9)),
                      ),
                    ],
                  ).animate().fadeIn(duration: const Duration(milliseconds: 300)),

                  const SizedBox(height: 24.0),

                  // Overview Header with Range Tag
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFF1F5F9),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2035),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF232A3B)),
                        ),
                        child: const Text(
                          'Last 30 Days',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),

                  // 4 Metric KPI Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Active Jobs',
                          value: '24',
                          icon: Icons.work_outline_rounded,
                          accentColor: const Color(0xFF8B5CF6),
                          onTap: () => context.push('/recruiter/jobs'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Applicants',
                          value: '312',
                          icon: Icons.people_outline_rounded,
                          accentColor: const Color(0xFF38BDF8),
                          onTap: () => context.push('/recruiter/pipeline'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Hired',
                          value: '18',
                          icon: Icons.star_outline_rounded,
                          accentColor: const Color(0xFF10B981),
                          onTap: () => context.push('/recruiter/pipeline'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: _buildMetricCard(
                          context,
                          title: 'Offers',
                          value: '7',
                          icon: Icons.check_circle_outline_rounded,
                          accentColor: const Color(0xFFF59E0B),
                          onTap: () => context.push('/recruiter/pipeline'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32.0),

                  // Quick Action Banner: Post a Job
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post a Job or Internship',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Reach verified candidates matched by AI',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/recruiter/create-job'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF8B5CF6),
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ).animate().scale(delay: const Duration(milliseconds: 100)),

                  const SizedBox(height: 32.0),

                  // Recent Applications Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Applications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFF1F5F9),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/recruiter/pipeline'),
                        child: const Text('View All', style: TextStyle(color: Color(0xFF8B5CF6))),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  // Applicant List
                  applicantsAsync.when(
                    data: (apps) {
                      final candidates = [
                        {
                          'name': 'Rahul Sharma',
                          'role': 'Software Developer',
                          'status': 'Shortlisted',
                          'time': '2h ago',
                        },
                        {
                          'name': 'Priya Singh',
                          'role': 'Frontend Developer',
                          'status': 'Applied',
                          'time': '4h ago',
                        },
                        {
                          'name': 'Arjun Verma',
                          'role': 'Backend Developer',
                          'status': 'Interview',
                          'time': '1d ago',
                        },
                        {
                          'name': 'Neha Patel',
                          'role': 'Data Analyst',
                          'status': 'Applied',
                          'time': '2d ago',
                        },
                      ];

                      return Column(
                        children: candidates.map((c) {
                          final statusColor = _statusColor(c['status'] as String);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: GestureDetector(
                              onTap: () => context.push('/recruiter/candidate-details', extra: c['name']),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121622),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFF232A3B)),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                                      child: Text(
                                        (c['name'] as String).substring(0, 1),
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c['name'] as String,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFFF1F5F9),
                                            ),
                                          ),
                                          Text(
                                            c['role'] as String,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                                          ),
                                          child: Text(
                                            c['status'] as String,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          c['time'] as String,
                                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
                      ),
                    ),
                    error: (e, _) => Center(child: Text('Failed to load applicants: $e', style: const TextStyle(color: Color(0xFF94A3B8)))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Shortlisted':
        return const Color(0xFF38BDF8);
      case 'Interview':
        return const Color(0xFFF59E0B);
      case 'Rejected':
        return const Color(0xFFEF4444);
      case 'Applied':
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF121622),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF232A3B)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                Icon(icon, size: 18, color: accentColor),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
