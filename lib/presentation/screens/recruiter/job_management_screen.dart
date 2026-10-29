import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class JobManagementScreen extends ConsumerStatefulWidget {
  const JobManagementScreen({super.key});

  @override
  ConsumerState<JobManagementScreen> createState() => _JobManagementScreenState();
}

class _JobManagementScreenState extends ConsumerState<JobManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final jobsAsync = ref.watch(recruiterJobsProvider(user?.id ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Management', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => context.push('/recruiter/create-job'),
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.darkPrimary),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.darkPrimary,
          labelColor: isDark ? Colors.white : AppColors.lightTextPrimary,
          unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          tabs: const [
            Tab(text: 'Active (5)'),
            Tab(text: 'Drafts (2)'),
            Tab(text: 'Closed (1)'),
          ],
        ),
      ),
      body: AnimatedBackground(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildJobList(jobsAsync, filterActive: true),
            _buildDraftsList(isDark),
            _buildClosedList(isDark),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/recruiter/create-job'),
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Job', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildJobList(AsyncValue<List<dynamic>> jobsAsync, {required bool filterActive}) {
    return jobsAsync.when(
      data: (jobs) {
        final activeJobs = jobs.where((j) => j.isActive == filterActive).toList();

        if (activeJobs.isEmpty) {
          return const Center(child: Text('No active listings found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: activeJobs.length,
          itemBuilder: (context, index) {
            final job = activeJobs[index];
            final applicantCount = job.applyCount > 0 ? job.applyCount : (index * 28 + 12);

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: GlassCard(
                onTap: () => context.push('/recruiter/pipeline', extra: job.id),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            job.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.darkSuccess.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                            border: Border.all(color: AppColors.darkSuccess.withValues(alpha: 0.4)),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(color: AppColors.darkSuccess, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      job.company,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.people_alt_outlined, size: 16, color: AppColors.darkPrimary),
                            const SizedBox(width: 6),
                            Text(
                              '$applicantCount Applicants',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => context.push('/recruiter/pipeline', extra: job.id),
                              child: const Text('View Pipeline'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert_rounded, size: 18),
                              onPressed: () => _showJobOptions(context, job.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading jobs: $e')),
    );
  }

  Widget _buildDraftsList(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        GlassCard(
          child: ListTile(
            title: const Text('Lead AI Architect (Draft)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Last edited yesterday', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            trailing: const Icon(Icons.edit_note_rounded),
            onTap: () => context.push('/recruiter/create-job'),
          ),
        ),
      ],
    );
  }

  Widget _buildClosedList(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        GlassCard(
          child: ListTile(
            title: const Text('Junior Flutter Engineer (Closed)', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Filled on Oct 15, 2026', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            trailing: const Icon(Icons.archive_outlined),
          ),
        ),
      ],
    );
  }

  void _showJobOptions(BuildContext context, String jobId) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.pause_circle_outline_rounded),
                title: const Text('Pause Listing'),
                onTap: () {
                  ref.read(jobNotifierProvider.notifier).updateJobStatus(jobId, false);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined),
                title: const Text('Close and Archive'),
                onTap: () {
                  ref.read(jobNotifierProvider.notifier).updateJobStatus(jobId, false);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

