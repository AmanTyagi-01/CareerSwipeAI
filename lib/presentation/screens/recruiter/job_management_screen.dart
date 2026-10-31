import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';

class JobManagementScreen extends ConsumerStatefulWidget {
  const JobManagementScreen({super.key});

  @override
  ConsumerState<JobManagementScreen> createState() => _JobManagementScreenState();
}

class _JobManagementScreenState extends ConsumerState<JobManagementScreen>
    with SingleTickerProviderStateMixin {
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
    final jobsAsync = ref.watch(recruiterJobsProvider(user?.id ?? ''));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        title: const Text('Job Management', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => context.push('/recruiter/create-job'),
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF8B5CF6)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          labelColor: const Color(0xFFF1F5F9),
          unselectedLabelColor: const Color(0xFF94A3B8),
          tabs: const [
            Tab(text: 'Active (5)'),
            Tab(text: 'Drafts (2)'),
            Tab(text: 'Closed (1)'),
          ],
        ),
      ),
      body: Container(
        color: const Color(0xFF0A0E17),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildJobList(jobsAsync, filterActive: true),
            _buildDraftsList(),
            _buildClosedList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/recruiter/create-job'),
        backgroundColor: const Color(0xFF8B5CF6),
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
          return const Center(
            child: Text('No active listings found.', style: TextStyle(color: Color(0xFF94A3B8))),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: activeJobs.length,
          itemBuilder: (context, index) {
            final job = activeJobs[index];
            final applicantCount = job.applyCount > 0 ? job.applyCount : (index * 28 + 12);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GestureDetector(
                onTap: () => context.push('/recruiter/pipeline', extra: job.id),
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
                          Expanded(
                            child: Text(
                              job.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFF1F5F9),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                            ),
                            child: const Text(
                              'Active',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A2035),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF232A3B)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF94A3B8)),
                                const SizedBox(width: 4),
                                Text(
                                  job.location.length > 20 ? '${job.location.substring(0, 20)}...' : job.location,
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              job.jobType,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF8B5CF6)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.people_alt_outlined, size: 14, color: Color(0xFF38BDF8)),
                                const SizedBox(width: 4),
                                Text(
                                  '$applicantCount Applicants',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Color(0xFF38BDF8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => context.push('/recruiter/pipeline', extra: job.id),
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF8B5CF6),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                ),
                                child: const Text('View', style: TextStyle(fontSize: 13)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF94A3B8)),
                                onPressed: () => _showJobOptions(context, job.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
      error: (e, _) => Center(child: Text('Error loading jobs: $e', style: const TextStyle(color: Color(0xFF94A3B8)))),
    );
  }

  Widget _buildDraftsList() {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        GestureDetector(
          onTap: () => context.push('/recruiter/create-job'),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF121622),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232A3B)),
            ),
            child: const ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Lead AI Architect (Draft)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9)),
              ),
              subtitle: Text(
                'Last edited yesterday',
                style: TextStyle(color: Color(0xFF94A3B8)),
              ),
              trailing: Icon(Icons.edit_note_rounded, color: Color(0xFF8B5CF6)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClosedList() {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF121622),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF232A3B)),
          ),
          child: const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Junior Flutter Engineer (Closed)',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9)),
            ),
            subtitle: Text(
              'Filled on Oct 15, 2026',
              style: TextStyle(color: Color(0xFF94A3B8)),
            ),
            trailing: Icon(Icons.archive_outlined, color: Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }

  void _showJobOptions(BuildContext context, String jobId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121622),
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.pause_circle_outline_rounded, color: Color(0xFFF59E0B)),
                title: const Text('Pause Listing', style: TextStyle(color: Color(0xFFF1F5F9))),
                onTap: () {
                  ref.read(jobNotifierProvider.notifier).updateJobStatus(jobId, false);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.archive_outlined, color: Color(0xFF94A3B8)),
                title: const Text('Close and Archive', style: TextStyle(color: Color(0xFFF1F5F9))),
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
