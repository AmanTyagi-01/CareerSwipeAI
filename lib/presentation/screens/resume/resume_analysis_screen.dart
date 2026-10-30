import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// ATS Analysis Screen matching Poster 1 Screen 8 & Poster 2 Screen 5:
/// - Header: "ATS Score"
/// - Giant Glowing Circular Gauge: 78 / 100 with "Good Match" teal badge
/// - Tabs: Overview | Skills | Suggestions
/// - Strengths section: [✓] Relevant technical skills, [✓] Good project experience, [✓] Quantified achievements
/// - Improvements section: [!] Add more measurable results, [!] Include more relevant keywords, [!] Improve summary section
/// - Bottom CTA: "View Detailed Report"
class ResumeAnalysisScreen extends ConsumerStatefulWidget {
  final String? analysisId;

  const ResumeAnalysisScreen({super.key, this.analysisId});

  @override
  ConsumerState<ResumeAnalysisScreen> createState() => _ResumeAnalysisScreenState();
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
          'ATS Score',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('ATS scores recalculated with latest models!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Giant Glowing Circular Gauge: 78 / 100
                Center(
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.2),
                          blurRadius: 32,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        const SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: 0.78,
                            strokeWidth: 10,
                            backgroundColor: Color(0xFF1E2436),
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                          ),
                        ),
                        // Number & Badge
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '78',
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1,
                                  ),
                                ),
                                Text(
                                  '/100',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                ),
                              ),
                              child: const Text(
                                'Good Match',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.easeOutBack),

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
                    labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Skills'),
                      Tab(text: 'Suggestions'),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Strengths Section
                _buildSectionHeader('Strengths', const Color(0xFF10B981)),
                const SizedBox(height: 10),
                _buildPointItem(
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF10B981),
                  text: 'Relevant technical skills',
                ),
                _buildPointItem(
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF10B981),
                  text: 'Good project experience',
                ),
                _buildPointItem(
                  icon: Icons.check_circle_rounded,
                  iconColor: const Color(0xFF10B981),
                  text: 'Quantified achievements',
                ),

                const SizedBox(height: 24),

                // Improvements Section
                _buildSectionHeader('Improvements', const Color(0xFFF59E0B)),
                const SizedBox(height: 10),
                _buildPointItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  text: 'Add more measurable results',
                ),
                _buildPointItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  text: 'Include more relevant keywords',
                ),
                _buildPointItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  text: 'Improve summary section',
                ),

                const SizedBox(height: 110), // Padding for sticky bottom CTA
              ],
            ),
          ),

          // Bottom Action: "View Detailed Report"
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              height: 52,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Detailed ATS Report generated with PDF export ready!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Center(
                    child: Text(
                      'View Detailed Report',
                      style: TextStyle(
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
    );
  }

  Widget _buildSectionHeader(String title, Color accent) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
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
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E2436)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFFCBD5E1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
