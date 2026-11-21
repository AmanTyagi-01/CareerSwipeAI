import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/resume_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';

class SkillGapScreen extends ConsumerStatefulWidget {
  const SkillGapScreen({super.key});

  @override
  ConsumerState<SkillGapScreen> createState() => _SkillGapScreenState();
}

class _SkillGapScreenState extends ConsumerState<SkillGapScreen> {
  String _selectedRole = 'Senior Flutter Developer';

  final Map<String, List<String>> _roleSkills = {
    'Senior Flutter Developer': [
      'Flutter',
      'Dart',
      'Firebase',
      'State Management',
      'CI/CD',
      'Unit Testing',
      'GraphQL',
      'Native iOS/Android'
    ],
    'Product Designer': [
      'Figma',
      'UI/UX',
      'Prototyping',
      'User Research',
      'Design Systems',
      'HTML/CSS',
      'Micro-interactions'
    ],
    'Full Stack Engineer': [
      'React',
      'Node.js',
      'TypeScript',
      'AWS',
      'GraphQL',
      'Docker',
      'Database Design',
      'REST APIs'
    ],
  };

  final List<Map<String, String>> _recommendedCourses = [
    {
      'title': 'Data Structures & Algorithms',
      'level': 'Beginner · 6 hours',
      'platform': 'LeetCode / Coursera',
    },
    {
      'title': 'System Design Fundamentals',
      'level': 'Intermediate · 8 hours',
      'platform': 'Educative / YouTube',
    },
    {
      'title': 'Modern Web & State Architectures',
      'level': 'Intermediate · 10 hours',
      'platform': 'Frontend Masters',
    },
    {
      'title': 'Applied Machine Learning & LLMs',
      'level': 'Advanced · 12 hours',
      'platform': 'DeepLearning.AI',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('Skill Development & Gaps',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(
                child: Text('Please log in to view skill gap analysis.',
                    style: TextStyle(color: Color(0xFF94A3B8))),
              );
            }
            final resumesAsync = ref.watch(userResumesProvider(user.id));
            return resumesAsync.when(
              data: (resumes) {
                final activeResume = resumes.isEmpty
                    ? null
                    : resumes.firstWhere((r) => r.isActive,
                        orElse: () => resumes.first);

                return _buildAnalysisContent(context, activeResume);
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
              error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: Color(0xFFEF4444)))),
            );
          },
          loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
          error: (e, _) => Center(
              child: Text('Error: $e',
                  style: const TextStyle(color: Color(0xFFEF4444)))),
        ),
      ),
    );
  }

  Widget _buildAnalysisContent(BuildContext context, ResumeModel? resume) {
    final targetSkills = _roleSkills[_selectedRole] ?? [];
    final userSkills = (resume?.skills != null && resume!.skills.isNotEmpty)
        ? resume.skills
        : const [
            'Flutter',
            'Dart',
            'Firebase',
            'State Management',
            'REST APIs'
          ];

    final matchingSkills = targetSkills
        .where((s) => userSkills.any((u) => u.toLowerCase() == s.toLowerCase()))
        .toList();
    final missingSkills = targetSkills
        .where(
            (s) => !userSkills.any((u) => u.toLowerCase() == s.toLowerCase()))
        .toList();

    final matchPercentage = targetSkills.isEmpty
        ? 0.0
        : (matchingSkills.length / targetSkills.length) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Target Role Selector Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF121622),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232A3B)),
            ),
            child: Row(
              children: [
                const Icon(Icons.work_outline_rounded,
                    color: Color(0xFF8B5CF6), size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRole,
                      dropdownColor: const Color(0xFF121622),
                      style: const TextStyle(
                          color: Color(0xFFF1F5F9),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Color(0xFF94A3B8)),
                      items: _roleSkills.keys.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null)
                          setState(() => _selectedRole = newValue);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),

          const SizedBox(height: 20),

          // Score Ring Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF121622),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF232A3B)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Role Compatibility Fit',
                  style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 18),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CircularProgressIndicator(
                        value: matchPercentage / 100,
                        strokeWidth: 10,
                        backgroundColor: const Color(0xFF1E2638),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF38BDF8)),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${matchPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF1F5F9),
                          ),
                        ),
                        const Text(
                          'Skill Match',
                          style:
                              TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (matchPercentage >= 75
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B))
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (matchPercentage >= 75
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B))
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    matchPercentage >= 75
                        ? 'Strong Competitive Profile'
                        : 'Skill Gaps Detected',
                    style: TextStyle(
                      color: matchPercentage >= 75
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 100.ms)
              .scale(begin: const Offset(0.95, 0.95)),

          const SizedBox(height: 24),

          // Matching Skills
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF10B981), size: 18),
              const SizedBox(width: 8),
              Text(
                'Matching Skills (${matchingSkills.length})',
                style: const TextStyle(
                    color: Color(0xFFF1F5F9),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: matchingSkills.map((skill) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.35)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, size: 14, color: Color(0xFF10B981)),
                    const SizedBox(width: 6),
                    Text(
                      skill,
                      style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ).animate().fadeIn(delay: 150.ms),

          const SizedBox(height: 24),

          // Missing Skills & Gap Analysis
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFF59E0B), size: 18),
              const SizedBox(width: 8),
              Text(
                'High-Priority Missing Skills (${missingSkills.length})',
                style: const TextStyle(
                    color: Color(0xFFF1F5F9),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...missingSkills.map((skill) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
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
                        skill,
                        style: const TextStyle(
                            color: Color(0xFFF1F5F9),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '+15% ATS impact',
                          style: TextStyle(
                              color: Color(0xFFF59E0B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete a dedicated hands-on project or add certified experience with $skill to boost interview invites.',
                    style: const TextStyle(
                        color: Color(0xFF94A3B8), fontSize: 12, height: 1.3),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // Recommended Courses (from poster)
          const Text(
            'Recommended Courses',
            style: TextStyle(
                color: Color(0xFFF1F5F9),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._recommendedCourses.map((course) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF121622),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF232A3B)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Color(0xFF8B5CF6), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title']!,
                          style: const TextStyle(
                              color: Color(0xFFF1F5F9),
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${course['level']} · ${course['platform']}',
                          style: const TextStyle(
                              color: Color(0xFF94A3B8), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF64748B), size: 14),
                ],
              ),
            );
          }),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
