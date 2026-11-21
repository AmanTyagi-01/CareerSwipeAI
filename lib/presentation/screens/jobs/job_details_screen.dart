import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/job_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/job_provider.dart';

/// Job Details Screen matching Poster 1 Screen 6 & Poster 2 Screen 8:
/// - Hero company architectural header banner
/// - Floating company badge
/// - Title: "Software Engineer", "Amazon"
/// - Tags: Full Time, Remote, ₹12-35 LPA
/// - Tabs: Overview | Requirements | Company
/// - Sticky bottom bar: [ Save ] outline button + [ Apply Now ] gradient button
class JobDetailsScreen extends ConsumerStatefulWidget {
  final String? jobId;

  const JobDetailsScreen({super.key, this.jobId});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSaved = false;
  bool _isApplied = false;

  static final JobModel _defaultJob = JobModel(
    id: 'amazon-sde-1',
    title: 'Software Engineer',
    company: 'Amazon',
    location: 'Bengaluru, India · Remote',
    minSalary: 1200000,
    maxSalary: 3500000,
    currency: 'INR',
    jobType: 'Full Time',
    experienceLevel: '3-5 years',
    isRemote: true,
    description: '''We are looking for a talented Software Engineer to join our team, lead architecture across cloud platforms, and deliver world-class experiences to hundreds of millions of customers worldwide.

You will have the opportunity to work with cutting-edge distributed computing technologies, optimize system performance, and drive architectural standards.''',
    requirements: const [
      "Bachelor's degree in Computer Science or related STEM field",
      '3+ years of professional software development experience',
      'Strong DSA (Data Structures & Algorithms) and system design skills',
      'Proficiency in at least one modern language (Python, Java, Go, TypeScript)',
      'Experience building scalable cloud services on AWS or GCP',
      'Demonstrated understanding of CI/CD and unit testing methodologies',
    ],
    skills: const ['Python', 'React', 'System Design', 'AWS', 'Distributed Systems'],
    postedAt: DateTime.now().subtract(const Duration(hours: 6)),
  );

  JobModel _resolveJob() {
    if (widget.jobId != null && widget.jobId!.isNotEmpty) {
      final jobsAsync = ref.watch(jobsProvider(null));
      final found = jobsAsync.value?.where((j) => j.id == widget.jobId).firstOrNull;
      if (found != null) return found;
    }
    return _defaultJob;
  }

  void _apply(JobModel job) async {
    final user = ref.read(currentUserProvider).value;
    if (user != null) {
      await ref.read(jobServiceProvider).applyForJob(
            user.id,
            job.id,
            resumeUrl: user.resumeUrl,
          );
    }
    setState(() => _isApplied = true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Application successfully submitted! 🎉'),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleSave(JobModel job) async {
    final user = ref.read(currentUserProvider).value;
    final newSaved = !_isSaved;
    setState(() => _isSaved = newSaved);
    if (user != null) {
      if (newSaved) {
        await ref.read(jobServiceProvider).saveJob(user.id, job.id);
      } else {
        await ref.read(jobServiceProvider).unsaveJob(user.id, job.id);
      }
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newSaved ? 'Saved to opportunities! ⭐' : 'Removed from saved jobs.'),
        backgroundColor: newSaved ? const Color(0xFF8B5CF6) : const Color(0xFF64748B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

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
    final job = _resolveJob();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Banner with Company Badge
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: const Color(0xFF0A0E17),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                      color: _isSaved ? const Color(0xFF8B5CF6) : Colors.white,
                    ),
                    onPressed: () => _toggleSave(job),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Architectural ambient gradient banner
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF312E81), Color(0xFF1E1B4B), Color(0xFF0F172A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      // Soft gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, const Color(0xFF0A0E17).withValues(alpha: 0.9)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Company Logo
                      Positioned(
                        left: 20,
                        bottom: 16,
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2333),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                                blurRadius: 14,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              job.company.isNotEmpty ? job.company[0].toUpperCase() : 'J',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF9900),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title, Subtitle, Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${job.company} · ${job.location}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Tags Row
                      Row(
                        children: [
                          _buildChip(job.jobType ?? 'Full Time', const Color(0xFF8B5CF6)),
                          const SizedBox(width: 8),
                          if (job.isRemote) ...[
                            _buildChip('Remote', const Color(0xFF38BDF8)),
                            const SizedBox(width: 8),
                          ],
                          _buildChip('₹12-35 LPA', const Color(0xFF10B981)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tab Bar: Overview | Requirements | Company
                      Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF121622),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF1E2436)),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: const Color(0xFF94A3B8),
                          labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Requirements'),
                            Tab(text: 'Company'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tab Content
                      SizedBox(
                        height: 380,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildOverviewTab(job),
                            _buildRequirementsTab(job),
                            _buildCompanyTab(job),
                          ],
                        ),
                      ),

                      const SizedBox(height: 100), // Spacing for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Sticky Bottom Bar: [ Save ] + [ Apply Now ]
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E17).withValues(alpha: 0.95),
                border: const Border(top: BorderSide(color: Color(0xFF1E2436))),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Save Button
                    OutlinedButton(
                      onPressed: () => _toggleSave(job),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF232A3B)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                            color: _isSaved ? const Color(0xFF8B5CF6) : Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isSaved ? 'Saved' : 'Save',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Apply Now Button
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                              blurRadius: 18,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: _isApplied ? null : () => _apply(job),
                            child: Center(
                              child: Text(
                                _isApplied ? 'Applied ✓' : 'Apply Now',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(JobModel job) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Text(
          'Job Description',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          job.description,
          style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), height: 1.5),
        ),
        const SizedBox(height: 20),
        const Text(
          'Skills Required',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: job.skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2436),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A334A)),
              ),
              child: Text(
                skill,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFCBD5E1)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRequirementsTab(JobModel job) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const Text(
          'Key Requirements',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 12),
        ...job.requirements.map((req) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.circle, size: 6, color: Color(0xFF8B5CF6)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    req,
                    style: const TextStyle(fontSize: 13, color: Color(0xFFCBD5E1), height: 1.4),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCompanyTab(JobModel job) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Text(
          'About ${job.company}',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          (job.shortDescription != null && job.shortDescription!.isNotEmpty)
              ? job.shortDescription!
              : job.description,
          style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), height: 1.5),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFF8B5CF6), size: 18),
            const SizedBox(width: 8),
            Text(job.location ?? 'Remote', style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
