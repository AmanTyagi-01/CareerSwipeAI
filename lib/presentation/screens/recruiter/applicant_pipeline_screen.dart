import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      'experience': '3 years at TCS · B.Tech CSE',
      'match': 92,
      'skills': ['Flutter', 'Dart', 'Riverpod', 'Firebase'],
      'status': 'Shortlisted',
    },
    {
      'id': 'cand-2',
      'name': 'Priya Singh',
      'role': 'Frontend Developer',
      'experience': '2 years at Infosys · React/Vue',
      'match': 88,
      'skills': ['React', 'TypeScript', 'Tailwind', 'REST APIs'],
      'status': 'Applied',
    },
    {
      'id': 'cand-3',
      'name': 'Arjun Verma',
      'role': 'AI / ML Engineer',
      'experience': 'B.Tech CSE, IIT Delhi · PyTorch',
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
      'skills': ['Flutter', 'Android', 'Kotlin', 'State'],
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('Applicant Pipeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF8B5CF6),
          indicatorWeight: 3,
          labelColor: const Color(0xFFF1F5F9),
          unselectedLabelColor: const Color(0xFF94A3B8),
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          isScrollable: true,
          tabs: const [
            Tab(text: 'All (4)'),
            Tab(text: 'Applied (2)'),
            Tab(text: 'Shortlisted (1)'),
            Tab(text: 'Interview (1)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCandidateList(_candidates),
          _buildCandidateList(_candidates.where((c) => c['status'] == 'Applied').toList()),
          _buildCandidateList(_candidates.where((c) => c['status'] == 'Shortlisted').toList()),
          _buildCandidateList(_candidates.where((c) => c['status'] == 'Interview').toList()),
        ],
      ),
    );
  }

  Widget _buildCandidateList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('No applicants found in this stage.', style: TextStyle(color: Color(0xFF94A3B8))),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final c = list[index];
        final matchScore = c['match'] as int;
        final isHighFit = matchScore >= 80;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF121622),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF232A3B)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.push('/recruiter/candidate-details', extra: c['name']),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              (c['name'] as String).substring(0, 1),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c['name'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFF1F5F9)),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c['role'] as String,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF38BDF8), fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c['experience'] as String,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: (isHighFit ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (isHighFit ? const Color(0xFF10B981) : const Color(0xFFF59E0B)).withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            '$matchScore% Match',
                            style: TextStyle(
                              color: isHighFit ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: (c['skills'] as List<String>).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2638),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFF232A3B)),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Color(0xFF232A3B), height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Applicant marked as Rejected'), backgroundColor: Color(0xFFEF4444)),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                            side: const BorderSide(color: Color(0xFFEF4444), width: 0.8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Reject', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Applicant marked as Shortlisted'), backgroundColor: Color(0xFF10B981)),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF10B981),
                            side: const BorderSide(color: Color(0xFF10B981), width: 0.8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Shortlist', style: TextStyle(fontSize: 12)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              context.push('/recruiter/schedule-interview', extra: c['name']);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Interview', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
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
}
