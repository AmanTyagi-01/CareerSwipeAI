import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class HiringAnalyticsScreen extends StatelessWidget {
  const HiringAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiring Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary KPI Row
              Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      title: 'Total Applications',
                      val: '312',
                      isDark: isDark,
                      accent: AppColors.darkPrimary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildMetric(
                      title: 'Active Roles',
                      val: '24',
                      isDark: isDark,
                      accent: AppColors.darkSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      title: 'Interview Stage',
                      val: '18',
                      isDark: isDark,
                      accent: AppColors.darkWarning,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildMetric(
                      title: 'Accepted Offers',
                      val: '7',
                      isDark: isDark,
                      accent: AppColors.darkSuccess,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Bar Chart: Applications Over Time
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Applications Over Time (Weekly)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 60,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const titles = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6'];
                                  final idx = value.toInt();
                                  if (idx >= 0 && idx < titles.length) {
                                    return Text(titles[idx], style: const TextStyle(fontSize: 11));
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                          barGroups: [
                            _barGroup(0, 32),
                            _barGroup(1, 45),
                            _barGroup(2, 28),
                            _barGroup(3, 52),
                            _barGroup(4, 48),
                            _barGroup(5, 58),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Top Candidate Acquisition Sources
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Top Acquisition Sources', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: AppSpacing.md),
                    _buildSourceProgress('LinkedIn Jobs', 0.45, '45%', AppColors.darkPrimary),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSourceProgress('Direct CareerSwipe AI', 0.25, '25%', AppColors.darkSecondary),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSourceProgress('Naukri / Job Portals', 0.20, '20%', AppColors.darkWarning),
                    const SizedBox(height: AppSpacing.sm),
                    _buildSourceProgress('Employee Referrals', 0.10, '10%', AppColors.darkSuccess),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: AppColors.primaryGradient,
          width: 16,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildMetric({
    required String title,
    required String val,
    required bool isDark,
    required Color accent,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: accent),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceProgress(String name, double val, String pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            Text(pct, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: val,
          backgroundColor: color.withValues(alpha: 0.15),
          color: color,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}

