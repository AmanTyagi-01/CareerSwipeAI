import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Recruiter Candidate Pipeline Screen matching Reference Design (Image 2):
/// - Top 4 Funnel Metric Cards (Applied, Screened, Interview, Hired)
/// - Search, Filter, and Sort Controls
/// - Interactive Candidate Table / List with Stage Tags, AI Match %, Star Ratings
/// - Quick stage transition dialog
class ApplicantPipelineScreen extends StatefulWidget {
  final String? jobId;
  const ApplicantPipelineScreen({super.key, this.jobId});

  @override
  State<ApplicantPipelineScreen> createState() =>
      _ApplicantPipelineScreenState();
}

class _ApplicantPipelineScreenState extends State<ApplicantPipelineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  // Rich pipeline matching Image 2 reference data
  final List<Map<String, dynamic>> _candidates = [
    {
      'id': 'cand-1',
      'name': 'Archana',
      'role': 'Backend Developer',
      'stage': 'Offer',
      'score': 85,
      'rating': 4,
      'appliedOn': '10 Jul, 02:00 PM',
      'location': 'San Francisco, CA',
      'experience': '4 yrs at Datadog · Go/K8s',
      'skills': ['Go', 'Kubernetes', 'Kafka', 'PostgreSQL'],
    },
    {
      'id': 'cand-2',
      'name': 'Jamal',
      'role': 'Frontend Developer',
      'stage': 'Offer',
      'score': 90,
      'rating': 5,
      'appliedOn': '12 Jul, 11:00 AM',
      'location': 'New York, NY',
      'experience': '3.5 yrs at Stripe · React/TypeScript',
      'skills': ['React', 'TypeScript', 'Next.js', 'Tailwind'],
    },
    {
      'id': 'cand-3',
      'name': 'Sofia',
      'role': 'Product Manager',
      'stage': 'Offer',
      'score': 88,
      'rating': 4,
      'appliedOn': '13 Jul, 09:30 AM',
      'location': 'Austin, TX',
      'experience': '5 yrs Product at Figma',
      'skills': ['Agile', 'Roadmapping', 'User Research', 'Analytics'],
    },
    {
      'id': 'cand-4',
      'name': 'Leo',
      'role': 'UX Designer',
      'stage': 'Offer',
      'score': 92,
      'rating': 5,
      'appliedOn': '14 Jul, 01:00 PM',
      'location': 'Chicago, IL',
      'experience': '3 yrs Design Systems at Airbnb',
      'skills': ['Figma', 'Prototyping', 'Design Tokens', 'Research'],
    },
    {
      'id': 'cand-5',
      'name': 'Amira',
      'role': 'Data Scientist',
      'stage': 'Interview',
      'score': 84,
      'rating': 4,
      'appliedOn': '15 Jul, 03:00 PM',
      'location': 'Seattle, WA',
      'experience': 'M.S. Data Science · PyTorch/ML',
      'skills': ['Python', 'PyTorch', 'Pandas', 'SQL'],
    },
    {
      'id': 'cand-6',
      'name': 'Daniel',
      'role': 'System Analyst',
      'stage': 'Interview',
      'score': 78,
      'rating': 3,
      'appliedOn': '16 Jul, 10:00 AM',
      'location': 'Los Angeles, CA',
      'experience': '3 yrs Enterprise Systems',
      'skills': ['System Design', 'APIs', 'AWS', 'Security'],
    },
    {
      'id': 'cand-7',
      'name': 'Nina',
      'role': 'DevOps Engineer',
      'stage': 'Interview',
      'score': 91,
      'rating': 5,
      'appliedOn': '17 Jul, 11:30 AM',
      'location': 'Miami, FL',
      'experience': '4 yrs Infrastructure at Cloudflare',
      'skills': ['Terraform', 'CI/CD', 'Docker', 'K8s'],
    },
    {
      'id': 'cand-8',
      'name': 'Ethan',
      'role': 'Software Tester',
      'stage': 'Screening',
      'score': 83,
      'rating': 4,
      'appliedOn': '18 Jul, 02:30 PM',
      'location': 'Boston, MA',
      'experience': 'QA Lead at FinTech Inc',
      'skills': ['Selenium', 'Cypress', 'Automation', 'Jest'],
    },
    {
      'id': 'cand-9',
      'name': 'Maya',
      'role': 'Mobile Developer',
      'stage': 'On Hold',
      'score': 75,
      'rating': 3,
      'appliedOn': '19 Jul, 12:00 PM',
      'location': 'Dallas, TX',
      'experience': '2 yrs Flutter/Dart Freelance',
      'skills': ['Flutter', 'Dart', 'Firebase', 'REST APIs'],
    },
    {
      'id': 'cand-10',
      'name': 'Clara',
      'role': 'Data Analyst',
      'stage': 'Hired',
      'score': 86,
      'rating': 4,
      'appliedOn': '21 Jul, 04:00 PM',
      'location': 'Denver, CO',
      'experience': 'Former Analyst at McKinsey',
      'skills': ['SQL', 'Tableau', 'Python', 'BI'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateStage(String candidateId, String newStage) {
    setState(() {
      final index = _candidates.indexWhere((c) => c['id'] == candidateId);
      if (index != -1) {
        _candidates[index]['stage'] = newStage;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Candidate stage updated to "$newStage"'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _candidates.where((c) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (c['name'] as String).toLowerCase();
      final role = (c['role'] as String).toLowerCase();
      final loc = (c['location'] as String).toLowerCase();
      return name.contains(q) || role.contains(q) || loc.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Candidate Pipeline',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Manage your candidates efficiently',
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded,
                color: Color(0xFF38BDF8)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add Candidate dialog opened'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF38BDF8),
          indicatorWeight: 3,
          labelColor: const Color(0xFFF1F5F9),
          unselectedLabelColor: const Color(0xFF94A3B8),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          isScrollable: true,
          tabs: [
            Tab(text: 'All (${filtered.length})'),
            Tab(
                text:
                    'Screening (${filtered.where((c) => c['stage'] == 'Screening').length})'),
            Tab(
                text:
                    'Interview (${filtered.where((c) => c['stage'] == 'Interview').length})'),
            Tab(
                text:
                    'Offer (${filtered.where((c) => c['stage'] == 'Offer').length})'),
            Tab(
                text:
                    'Hired (${filtered.where((c) => c['stage'] == 'Hired').length})'),
            Tab(
                text:
                    'On Hold (${filtered.where((c) => c['stage'] == 'On Hold').length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // 4 Top Metric Cards matching Image 2
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                    child: _buildMetricCard(
                        'Applied Job',
                        '${_candidates.length}',
                        Icons.work_outline,
                        const Color(0xFF38BDF8))),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildMetricCard(
                        'Screened',
                        '${_candidates.where((c) => c['stage'] == 'Screening').length}',
                        Icons.filter_alt_outlined,
                        const Color(0xFF818CF8))),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildMetricCard(
                        'Interview',
                        '${_candidates.where((c) => c['stage'] == 'Interview').length}',
                        Icons.videocam_outlined,
                        const Color(0xFFFBBF24))),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildMetricCard(
                        'Hired',
                        '${_candidates.where((c) => c['stage'] == 'Hired').length}',
                        Icons.check_circle_outline,
                        const Color(0xFF34D399))),
              ],
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search candidate name, role, or location...',
                hintStyle:
                    const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                prefixIcon: const Icon(Icons.search,
                    color: Color(0xFF64748B), size: 18),
                filled: true,
                fillColor: const Color(0xFF121622),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E2436))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E2436))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF38BDF8))),
              ),
            ),
          ),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCandidateList(filtered),
                _buildCandidateList(
                    filtered.where((c) => c['stage'] == 'Screening').toList()),
                _buildCandidateList(
                    filtered.where((c) => c['stage'] == 'Interview').toList()),
                _buildCandidateList(
                    filtered.where((c) => c['stage'] == 'Offer').toList()),
                _buildCandidateList(
                    filtered.where((c) => c['stage'] == 'Hired').toList()),
                _buildCandidateList(
                    filtered.where((c) => c['stage'] == 'On Hold').toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String count, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E2436)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: accent, size: 16),
              Text(
                count,
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return const Center(
        child: Text('No applicants found in this stage.',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final c = list[index];
        final matchScore = c['score'] as int;
        final stage = c['stage'] as String;
        final rating = c['rating'] as int;

        Color stageColor;
        switch (stage) {
          case 'Offer':
            stageColor = const Color(0xFF34D399);
            break;
          case 'Interview':
            stageColor = const Color(0xFFFBBF24);
            break;
          case 'Screening':
            stageColor = const Color(0xFF38BDF8);
            break;
          case 'Hired':
            stageColor = const Color(0xFFA78BFA);
            break;
          default:
            stageColor = const Color(0xFF94A3B8);
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF121622),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF1E2436)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _showStageActionSheet(c),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF1E293B),
                          child: Text(
                            (c['name'] as String).substring(0, 1),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    c['name'] as String,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  // Star Rating
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        Icons.star,
                                        size: 11,
                                        color: i < rating
                                            ? const Color(0xFFFBBF24)
                                            : const Color(0xFF334155),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${c['role']} · ${c['location']}',
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF94A3B8)),
                              ),
                            ],
                          ),
                        ),
                        // AI Score Pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF10B981).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.35)),
                          ),
                          child: Text(
                            '$matchScore%',
                            style: const TextStyle(
                              color: Color(0xFF10B981),
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Stage pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: stageColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: stageColor.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            stage,
                            style: TextStyle(
                              color: stageColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Text(
                          'Applied: ${c['appliedOn']}',
                          style: const TextStyle(
                              color: Color(0xFF64748B), fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStageActionSheet(Map<String, dynamic> candidate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        final stages = ['Screening', 'Interview', 'Offer', 'Hired', 'On Hold'];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage ${candidate['name']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 16),
                ),
                Text(
                  'Current Stage: ${candidate['stage']} · Score: ${candidate['score']}%',
                  style:
                      const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text('Transition Stage:',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: stages.map((st) {
                    final isCurrent = candidate['stage'] == st;
                    return ActionChip(
                      backgroundColor: isCurrent
                          ? const Color(0xFF38BDF8)
                          : const Color(0xFF1E293B),
                      label: Text(
                        st,
                        style: TextStyle(
                          color: isCurrent ? Colors.black : Colors.white,
                          fontWeight:
                              isCurrent ? FontWeight.w800 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _updateStage(candidate['id'] as String, st);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.calendar_today,
                        size: 16, color: Colors.white),
                    label: const Text('Schedule Interview',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.push('/recruiter/interview-scheduling',
                          extra: candidate['name']);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
