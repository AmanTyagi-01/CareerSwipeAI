import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/resume_model.dart';
import '../../../data/models/job_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/resume_provider.dart';
import '../../../presentation/providers/job_provider.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/glass_card.dart';
import '../../../presentation/widgets/common/loading_indicator.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: userAsync.when(
            data: (user) => _buildContent(context, user, isDark, ref),
            loading: () => const Center(child: AppLoadingIndicator(message: 'Loading your dashboard...')),
            error: (error, _) => _buildErrorState(context, error, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.darkTextSecondary),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(currentUserProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, UserModel? user, bool isDark, WidgetRef ref) {
    // Watch user's resumes and applications dynamically
    final resumesAsync = user != null 
        ? ref.watch(userResumesProvider(user.id)) 
        : const AsyncValue<List<ResumeModel>>.data([]);
    final applicationsAsync = user != null 
        ? ref.watch(appliedJobsProvider(user.id)) 
        : const AsyncValue<List<JobApplicationModel>>.data([]);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, user, isDark),
          const SizedBox(height: 20),
          _buildQuickStats(context, user, isDark, ref),
          const SizedBox(height: 20),
          _buildPremiumFeaturesRow(context),
          const SizedBox(height: 20),
          resumesAsync.when(
            data: (resumes) => _buildResumeScoreCard(context, resumes, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading resumes: $e')),
          ),
          const SizedBox(height: 20),
          resumesAsync.when(
            data: (resumes) => _buildAtsScoreProgressionChart(context, resumes, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading chart: $e')),
          ),
          const SizedBox(height: 20),
          applicationsAsync.when(
            data: (applications) => _buildJobApplicationsChart(context, applications, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error loading chart: $e')),
          ),
          const SizedBox(height: 20),
          _buildRecentActivity(context, isDark),
          const SizedBox(height: 20),
          _buildCareerInsights(context, isDark),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserModel? user, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.displayName ?? 'Career Seeker',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => context.push('/profile/notifications'),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkElevated : AppTheme.lightElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn()
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildQuickStats(BuildContext context, UserModel? user, bool isDark, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.description,
            label: 'Resume Score',
            value: '82',
            sublabel: 'Good',
            color: AppTheme.primaryColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.work,
            label: 'Jobs Viewed',
            value: '47',
            sublabel: 'This week',
            color: AppTheme.accentColor,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.favorite,
            label: 'Saved',
            value: '${user?.savedJobIds.length ?? 0}',
            sublabel: 'Jobs',
            color: AppTheme.warningColor,
            isDark: isDark,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 100))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatCard(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required String sublabel,
    required Color color,
    required bool isDark,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFeaturesRow(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium AI Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFeatureButton(
                context,
                title: 'Skill Gap',
                subtitle: 'Match requirements',
                icon: Icons.analytics_outlined,
                color: AppTheme.accentColor,
                route: '/resume/skill-gap',
              ),
              const SizedBox(width: 12),
              _buildFeatureButton(
                context,
                title: 'Interview Prep',
                subtitle: 'Flip flashcards',
                icon: Icons.question_answer_outlined,
                color: AppTheme.primaryColor,
                route: '/resume/interview-prep',
              ),
              const SizedBox(width: 12),
              _buildFeatureButton(
                context,
                title: 'PDF Template',
                subtitle: 'Preview layouts',
                icon: Icons.picture_as_pdf_outlined,
                color: AppTheme.successColor,
                route: '/resume/pdf-preview',
              ),
              const SizedBox(width: 12),
              _buildFeatureButton(
                context,
                title: 'Career AI Coach',
                subtitle: 'Ask anything',
                icon: Icons.auto_awesome_rounded,
                color: AppTheme.primaryColor,
                route: '/career-assistant',
              ),
              const SizedBox(width: 12),
              _buildFeatureButton(
                context,
                title: 'Internships',
                subtitle: 'Discover stipends',
                icon: Icons.school_outlined,
                color: AppTheme.accentColor,
                route: '/internships',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureButton(BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeScoreCard(BuildContext context, List<ResumeModel> resumes, bool isDark) {
    final activeResume = resumes.isEmpty 
        ? null 
        : resumes.firstWhere((r) => r.isActive, orElse: () => resumes.first);
        
    final score = activeResume?.atsScore ?? 82.0;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Resume Health',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/resume/upload'),
                child: const Text('Improve'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 4,
                          centerSpaceRadius: 35,
                          sections: [
                            PieChartSectionData(
                              value: score,
                              color: AppTheme.successColor,
                              radius: 25,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 100 - score,
                              color: isDark ? AppTheme.darkElevated : AppTheme.lightElevated,
                              radius: 25,
                              showTitle: false,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            score.toStringAsFixed(0),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.successColor,
                            ),
                          ),
                          Text(
                            '/100',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildScoreBar(context, 'ATS Score', score / 100, AppTheme.successColor, isDark),
                    const SizedBox(height: 12),
                    _buildScoreBar(context, 'Keywords', (activeResume?.atsBreakdown['Keywords'] ?? 72.0) / 100, AppTheme.accentColor, isDark),
                    const SizedBox(height: 12),
                    _buildScoreBar(context, 'Formatting', (activeResume?.atsBreakdown['Formatting'] ?? 91.0) / 100, AppTheme.primaryColor, isDark),
                    const SizedBox(height: 12),
                    _buildScoreBar(context, 'Content', (activeResume?.atsBreakdown['Readability'] ?? 78.0) / 100, AppTheme.warningColor, isDark),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildScoreBar(BuildContext context, String label, double value, Color color, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              ),
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: isDark ? AppTheme.darkElevated : AppTheme.lightElevated,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildAtsScoreProgressionChart(BuildContext context, List<ResumeModel> resumes, bool isDark) {
    final sortedResumes = List<ResumeModel>.from(resumes);
    sortedResumes.sort((a, b) => a.uploadedAt?.compareTo(b.uploadedAt ?? DateTime.now()) ?? 0);

    final List<FlSpot> spots = [];
    if (sortedResumes.isEmpty) {
      spots.addAll([
        const FlSpot(0, 55),
        const FlSpot(1, 62),
        const FlSpot(2, 70),
        const FlSpot(3, 82),
      ]);
    } else {
      for (int i = 0; i < sortedResumes.length; i++) {
        spots.add(FlSpot(i.toDouble(), sortedResumes[i].atsScore));
      }
    }

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ATS Score Progression',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          'v${(value.toInt() + 1)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: max(3.0, (spots.length - 1).toDouble()),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.accentColor],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: AppTheme.primaryColor,
                          strokeWidth: 2,
                          strokeColor: isDark ? AppTheme.darkSurface : Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withValues(alpha: 0.2),
                          AppTheme.primaryColor.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobApplicationsChart(BuildContext context, List<JobApplicationModel> applications, bool isDark) {
    int applied = 0;
    int interviewing = 0;
    int offers = 0;
    int rejected = 0;

    if (applications.isEmpty) {
      // High fidelity default values for SaaS dashboard representation
      applied = 12;
      interviewing = 4;
      offers = 2;
      rejected = 1;
    } else {
      for (final app in applications) {
        if (app.status == 'pending' || app.status == 'reviewing') {
          applied++;
        } else if (app.status == 'interview') {
          interviewing++;
        } else if (app.status == 'offered') {
          offers++;
        } else if (app.status == 'rejected') {
          rejected++;
        }
      }
    }

    final double maxVal = max(4.0, [applied, interviewing, offers, rejected].reduce(max).toDouble() + 2.0);

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Applications Analytics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(fontSize: 10, fontWeight: FontWeight.bold);
                        switch (value.toInt()) {
                          case 0: return const Text('Applied', style: style);
                          case 1: return const Text('Interview', style: style);
                          case 2: return const Text('Offers', style: style);
                          case 3: return const Text('Rejected', style: style);
                          default: return const Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [BarChartRodData(toY: applied.toDouble(), color: AppTheme.primaryColor, width: 16, borderRadius: BorderRadius.circular(4))],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [BarChartRodData(toY: interviewing.toDouble(), color: AppTheme.accentColor, width: 16, borderRadius: BorderRadius.circular(4))],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [BarChartRodData(toY: offers.toDouble(), color: AppTheme.successColor, width: 16, borderRadius: BorderRadius.circular(4))],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [BarChartRodData(toY: rejected.toDouble(), color: AppTheme.errorColor, width: 16, borderRadius: BorderRadius.circular(4))],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/jobs/applied'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActivityItem(
            context,
            icon: Icons.check_circle,
            color: AppTheme.successColor,
            title: 'Applied to Senior Flutter Developer',
            subtitle: 'TechCorp Inc.',
            time: '2 hours ago',
            isDark: isDark,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildActivityItem(
            context,
            icon: Icons.favorite,
            color: AppTheme.errorColor,
            title: 'Saved Product Designer role',
            subtitle: 'DesignStudio',
            time: '5 hours ago',
            isDark: isDark,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildActivityItem(
            context,
            icon: Icons.analytics,
            color: AppTheme.primaryColor,
            title: 'Resume analysis completed',
            subtitle: 'Score: 82/100',
            time: '1 day ago',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareerInsights(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Career Insights',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightCard(
            context,
            icon: Icons.trending_up,
            color: AppTheme.successColor,
            title: 'High Demand Skills',
            description: 'Flutter, React Native, and Cloud Architecture are trending in your field.',
            isDark: isDark,
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            context,
            icon: Icons.attach_money,
            color: AppTheme.warningColor,
            title: 'Salary Benchmark',
            description: 'Your target role pays 15% above market average in your location.',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkElevated.withValues(alpha: 0.5) : AppTheme.lightElevated.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
