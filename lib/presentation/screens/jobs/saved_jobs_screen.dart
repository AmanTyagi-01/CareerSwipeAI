import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/utils/app_utils.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/job_provider.dart';

class SavedJobsScreen extends ConsumerWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final savedJobsAsync = user != null
        ? ref.watch(savedJobsProvider(user.id))
        : const AsyncValue<List<dynamic>>.data([]);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('Saved Opportunities', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: savedJobsAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return _buildPosterSampleJobs(context);
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _buildJobCard(context, job, user?.id ?? '', ref)
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: index * 60))
                    .slideY(begin: 0.1, end: 0);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
          error: (error, _) => Center(
            child: Text('Error: $error', style: const TextStyle(color: Color(0xFFEF4444))),
          ),
        ),
      ),
    );
  }

  Widget _buildPosterSampleJobs(BuildContext context) {
    final sampleSaved = [
      {
        'id': 'saved-1',
        'title': 'Software Engineer',
        'company': 'Google',
        'location': 'Bengaluru · Remote',
        'salary': '₹18 - 32 LPA',
        'tags': ['Full-time', 'Flutter', 'AI'],
      },
      {
        'id': 'saved-2',
        'title': 'Frontend Developer',
        'company': 'Amazon',
        'location': 'Hyderabad · Hybrid',
        'salary': '₹16 - 28 LPA',
        'tags': ['Full-time', 'React', 'AWS'],
      },
      {
        'id': 'saved-3',
        'title': 'AI / ML Engineer',
        'company': 'Microsoft',
        'location': 'Noida · Remote',
        'salary': '₹20 - 35 LPA',
        'tags': ['Full-time', 'PyTorch', 'Azure'],
      },
      {
        'id': 'saved-4',
        'title': 'Backend Systems Engineer',
        'company': 'Netflix',
        'location': 'Mumbai · Hybrid',
        'salary': '₹24 - 42 LPA',
        'tags': ['Full-time', 'Go', 'Distributed'],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: sampleSaved.length,
      itemBuilder: (context, index) {
        final job = sampleSaved[index];
        final tags = job['tags'] as List<String>;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF121622),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF232A3B)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/jobs/details'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              (job['company'] as String).substring(0, 1),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['title'] as String,
                                style: const TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                job['company'] as String,
                                style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                job['location'] as String,
                                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.bookmark_rounded, color: Color(0xFF38BDF8), size: 24),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          spacing: 6,
                          children: tags.map((t) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E2638),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(t, style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11)),
                            );
                          }).toList(),
                        ),
                        Text(
                          job['salary'] as String,
                          style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: index * 60)).slideY(begin: 0.05, end: 0);
      },
    );
  }

  Widget _buildJobCard(BuildContext context, dynamic job, String userId, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.push('/jobs/details/${job.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppUtils.getInitials(job.company),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(color: Color(0xFFF1F5F9), fontWeight: FontWeight.bold, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            job.company,
                            style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            job.location ?? (job.isRemote ? 'Remote' : 'India'),
                            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_rounded, color: Color(0xFF38BDF8)),
                      onPressed: () {
                        ref.read(jobNotifierProvider.notifier).unsaveJob(userId, job.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppUtils.formatSalary(job.minSalary, job.maxSalary, job.currency ?? 'INR'),
                      style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Text(
                      AppUtils.formatRelativeTime(job.postedAt ?? DateTime.now()),
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
