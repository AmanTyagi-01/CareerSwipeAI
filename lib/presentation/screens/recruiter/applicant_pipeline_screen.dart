import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class ApplicantPipelineScreen extends StatefulWidget {
  final String? jobId;
  const ApplicantPipelineScreen({super.key, this.jobId});

  @override
  State<ApplicantPipelineScreen> createState() => _ApplicantPipelineScreenState();
}

class _ApplicantPipelineScreenState extends State<ApplicantPipelineScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _candidates = [
    {
      'id': 'cand-1',
      'name': 'Rahul Sharma',
      'role': 'Senior Flutter Engineer',
      'experience': '3 years at TCS',
      'match': 92,
      'skills': ['Flutter', 'Dart', 'Riverpod', 'Firebase'],
      'status': 'Shortlisted',
    },
    {
      'id': 'cand-2',
      'name': 'Priya Singh',
      'role': 'Frontend Developer',
      'experience': '2 years at Infosys',
      'match': 88,
      'skills': ['React', 'TypeScript', 'Tailwind', 'REST'],
      'status': 'Applied',
    },
    {
      'id': 'cand-3',
      'name': 'Arjun Verma',
      'role': 'AI / ML Engineer',
      'experience': 'B.Tech CSE, IIT Delhi',
      'match': 85,
      'skills': ['Python', 'PyTorch', 'FastAPI', 'Docker'],
      'status': 'Interview',
    },
    {
      'id': 'cand-4',
      'name': 'Neha Patel',
      'role': 'Mobile App Developer',
      'experience': '1.5 years at StartupX',
      'match': 77,
      'skills': ['Flutter', 'Android', 'Kotlin'],
      'status': 'Applied',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Pipeline', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.darkPrimary,
          labelColor: isDark ? Colors.white : AppColors.lightTextPrimary,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All (4)'),
            Tab(text: 'Applied (2)'),
            Tab(text: 'Shortlisted (1)'),
            Tab(text: 'Interview (1)'),
          ],
        ),
      ),
      body: AnimatedBackground(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildCandidateList(_candidates),
            _buildCandidateList(_candidates.where((c) => c['status'] == 'Applied').toList()),
            _buildCandidateList(_candidates.where((c) => c['status'] == 'Shortlisted').toList()),
            _buildCandidateList(_candidates.where((c) => c['status'] == 'Interview').toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCandidateList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return const Center(child: Text('No applicants in this category.'));
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final c = list[index];
        final matchScore = c['match'] as int;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: GlassCard(
            onTap: () => context.push('/recruiter/candidate-details', extra: c['name']),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.darkPrimary.withValues(alpha: 0.15),
                      child: Text(
                        (c['name'] as String).substring(0, 1),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPrimary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            c['role'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            c['experience'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkSuccess.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        border: Border.all(color: AppColors.darkSuccess.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        '$matchScore% Match',
                        style: const TextStyle(color: AppColors.darkSuccess, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (c['skills'] as List<String>).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurfaceOverlay : AppColors.lightSurfaceOverlay,
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      child: Text(skill, style: const TextStyle(fontSize: 11)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Applicant marked as Rejected')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Reject'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: () {
                        context.push('/recruiter/schedule-interview', extra: c['name']);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text('Interview'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

