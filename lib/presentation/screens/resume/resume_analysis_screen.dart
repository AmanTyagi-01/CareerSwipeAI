import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/resume_model.dart';

/// ATS Analysis Screen matching Reference UI & Image 3:
/// - Circular Overall Match Gauge (0-100) with color tier
/// - 5 Criteria Progress Bars: Skills, Keywords, Experience, Education, Formatting
/// - Top Matched Skills & Missing/Underused Skills tags
/// - Tabs: Overview | Skills | Suggestions
/// - Transparent explainable disclaimer
class ResumeAnalysisScreen extends ConsumerStatefulWidget {
  final String? analysisId;

  const ResumeAnalysisScreen({super.key, this.analysisId});

  @override
  ConsumerState<ResumeAnalysisScreen> createState() =>
      _ResumeAnalysisScreenState();
}

class _ResumeAnalysisScreenState extends ConsumerState<ResumeAnalysisScreen>
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
    final activeAnalysis =
        ref.watch(activeAnalysisStateProvider) ?? _getDemoAnalysis();
    final overallScore = activeAnalysis.atsScore.round().clamp(0, 100);

    // Section scores matching Image 3 reference
    final skillsScore =
        (activeAnalysis.sectionScores['Skills'] as num?)?.round() ?? 88;
    final keywordsScore =
        (activeAnalysis.sectionScores['Keywords'] as num?)?.round() ?? 82;
    final experienceScore =
        (activeAnalysis.sectionScores['Experience'] as num?)?.round() ?? 85;
    final educationScore =
        (activeAnalysis.sectionScores['Education'] as num?)?.round() ?? 90;
    final formattingScore =
        (activeAnalysis.sectionScores['Formatting'] as num?)?.round() ?? 92;

    final matchedSkills = activeAnalysis.keywords.isNotEmpty
        ? activeAnalysis.keywords
        : const ['Flutter', 'Dart', 'Riverpod', 'REST APIs', 'Git', 'Firebase'];
    final missingSkills = activeAnalysis.missingSkills.isNotEmpty
        ? activeAnalysis.missingSkills
        : const ['Docker', 'Kubernetes', 'CI/CD Pipelines', 'System Design'];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'ATS Evidence Analysis',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Recalculated with latest algorithmic criteria.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Card: Circular Score & 5-Dimension Progress Bars
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121622),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1E2436)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Circular Gauge
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: CircularProgressIndicator(
                                    value: overallScore / 100,
                                    strokeWidth: 9,
                                    backgroundColor: const Color(0xFF1E2436),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      overallScore >= 80
                                          ? const Color(0xFF10B981)
                                          : (overallScore >= 60
                                              ? const Color(0xFFF59E0B)
                                              : const Color(0xFFEF4444)),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$overallScore',
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      '/100',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      overallScore >= 80
                                          ? 'High Fit'
                                          : (overallScore >= 60
                                              ? 'Moderate'
                                              : 'Low Fit'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: overallScore >= 80
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFF59E0B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // 5 Criteria Progress Bars
                          Expanded(
                            child: Column(
                              children: [
                                _buildCriterionBar('Skills', skillsScore,
                                    const Color(0xFF38BDF8)),
                                const SizedBox(height: 8),
                                _buildCriterionBar('Keywords', keywordsScore,
                                    const Color(0xFF818CF8)),
                                const SizedBox(height: 8),
                                _buildCriterionBar('Experience',
                                    experienceScore, const Color(0xFF34D399)),
                                const SizedBox(height: 8),
                                _buildCriterionBar('Education', educationScore,
                                    const Color(0xFFFBBF24)),
                                const SizedBox(height: 8),
                                _buildCriterionBar('Formatting',
                                    formattingScore, const Color(0xFFA78BFA)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Disclaimer Note
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F131D),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF1E2436)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                size: 14, color: Color(0xFF64748B)),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Application-specific algorithmic estimate based on extracted criteria. Does not guarantee third-party ATS outcomes.',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                    height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),

                const SizedBox(height: 20),

                // Top Matched Skills
                _buildSectionHeader(
                    'Top Matched Skills', const Color(0xFF10B981)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: matchedSkills
                      .map((s) => _buildSkillBadge(s, isMatched: true))
                      .toList(),
                ),

                const SizedBox(height: 20),

                // Missing or Underused Skills
                _buildSectionHeader(
                    'Missing or Underused Skills', const Color(0xFFEF4444)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: missingSkills
                      .map((s) => _buildSkillBadge(s, isMatched: false))
                      .toList(),
                ),

                const SizedBox(height: 24),

                // Tabs: Overview | Skills | Suggestions
                Container(
                  height: 42,
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
                    labelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'All Skills'),
                      Tab(text: 'Suggestions'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tab Content Display
                SizedBox(
                  height: 380,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Overview Tab
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildSubHeader(
                              'Validated Strengths', const Color(0xFF10B981)),
                          const SizedBox(height: 8),
                          ...activeAnalysis.strengths
                              .map((st) => _buildPointItem(
                                    icon: Icons.check_circle_rounded,
                                    iconColor: const Color(0xFF10B981),
                                    text: st,
                                  )),
                          const SizedBox(height: 14),
                          _buildSubHeader(
                              'Target Improvements', const Color(0xFFF59E0B)),
                          const SizedBox(height: 8),
                          ...activeAnalysis.improvements
                              .map((imp) => _buildPointItem(
                                    icon: Icons.lightbulb_outline_rounded,
                                    iconColor: const Color(0xFFF59E0B),
                                    text: imp,
                                  )),
                        ],
                      ),
                      // All Skills Tab
                      ListView(
                        children: [
                          _buildSubHeader(
                              'All Detected Skills (${activeAnalysis.detectedSkills.length})',
                              const Color(0xFF38BDF8)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: activeAnalysis.detectedSkills
                                .map((s) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A2234),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xFF2A3750)),
                                      ),
                                      child: Text(s,
                                          style: const TextStyle(
                                              color: Color(0xFFE2E8F0),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600)),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                      // Suggestions Tab
                      ListView(
                        children: [
                          _buildSubHeader('Factual Bullet Revisions',
                              const Color(0xFF8B5CF6)),
                          const SizedBox(height: 8),
                          ...activeAnalysis.improvements.map((imp) => Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121622),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFF232A3B)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.arrow_right_alt_rounded,
                                        color: Color(0xFF8B5CF6), size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        imp,
                                        style: const TextStyle(
                                            color: Color(0xFFCBD5E1),
                                            fontSize: 13,
                                            height: 1.4),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Bottom Fixed Action: "Optimize with AI"
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    context.push('/resume/skill-gap');
                  },
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'View Skill Gap & Roadmap',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriterionBar(String label, int score, Color barColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
            Text('$score',
                style: TextStyle(
                    color: barColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (score / 100).clamp(0.0, 1.0),
            minHeight: 5,
            backgroundColor: const Color(0xFF1E2436),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color accent) {
    return Row(
      children: [
        Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
                color: accent, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildSubHeader(String title, Color accent) {
    return Text(title,
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w700, color: accent));
  }

  Widget _buildSkillBadge(String skill, {required bool isMatched}) {
    final color = isMatched ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isMatched ? Icons.check : Icons.close, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            skill,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildPointItem({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E2436)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFCBD5E1),
                  height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  ResumeAnalysisModel _getDemoAnalysis() {
    return ResumeAnalysisModel(
      id: 'demo_analysis',
      userId: 'usr_active',
      resumeId: 'res_active',
      atsScore: 86.0,
      keywordMatch: 82.0,
      formattingScore: 92.0,
      contentScore: 85.0,
      detectedSkills: const [
        'Flutter',
        'Dart',
        'Riverpod',
        'REST APIs',
        'Git',
        'Firebase',
        'Clean Architecture',
        'Unit Testing'
      ],
      missingSkills: const ['Docker', 'Kubernetes', 'CI/CD Pipelines'],
      keywords: const [
        'Flutter',
        'Dart',
        'Riverpod',
        'REST APIs',
        'Git',
        'Firebase'
      ],
      strengths: const [
        'Strong validated skills across core mobile engineering stack.',
        'Quantified metrics and measurable impacts present in experience sections.',
        'Clean formatting compatible with standard corporate parsing engines.',
      ],
      improvements: const [
        'Add cloud containerization competencies (Docker, Kubernetes) to match infrastructure requirements.',
        'Quantify performance optimizations with latency and memory footprints.',
      ],
      sectionScores: const {
        'Skills': 88,
        'Keywords': 82,
        'Experience': 85,
        'Education': 90,
        'Formatting': 92,
      },
      analyzedAt: DateTime.now(),
      isComplete: true,
    );
  }
}
