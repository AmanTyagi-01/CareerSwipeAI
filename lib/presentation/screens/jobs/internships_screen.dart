import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class InternshipsScreen extends ConsumerWidget {
  const InternshipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sampleInternships = [
      {
        'id': 'intern-1',
        'title': 'AI & ML Engineering Intern',
        'company': 'Google DeepMind',
        'location': 'Bengaluru, India (Hybrid)',
        'duration': '6 Months',
        'stipend': '₹80,000 / month',
        'skills': ['Python', 'PyTorch', 'Transformers', 'Math'],
        'deadline': 'Nov 30, 2026',
      },
      {
        'id': 'intern-2',
        'title': 'Mobile Flutter Developer Intern',
        'company': 'Microsoft',
        'location': 'Hyderabad, India (Remote)',
        'duration': '3 Months',
        'stipend': '₹65,000 / month',
        'skills': ['Flutter', 'Dart', 'State Management', 'REST'],
        'deadline': 'Dec 15, 2026',
      },
      {
        'id': 'intern-3',
        'title': 'Product Design & UI/UX Intern',
        'company': 'Swiggy',
        'location': 'Bengaluru, India (On-site)',
        'duration': '6 Months',
        'stipend': '₹40,000 / month',
        'skills': ['Figma', 'Prototyping', 'User Research'],
        'deadline': 'Dec 1, 2026',
      },
      {
        'id': 'intern-4',
        'title': 'Cloud & DevOps Intern',
        'company': 'Amazon AWS',
        'location': 'Gurugram, India (Hybrid)',
        'duration': '6 Months',
        'stipend': '₹75,000 / month',
        'skills': ['Docker', 'AWS', 'Linux', 'CI/CD'],
        'deadline': 'Dec 10, 2026',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Internships', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded),
            onPressed: () => context.push('/jobs/saved'),
          ),
        ],
      ),
      body: AnimatedBackground(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search internships, skills, or companies...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Filter Chips
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(label: Text('All'), selected: true, selectedColor: AppColors.darkPrimary),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text('Remote'), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text('3 Months'), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text('6 Months'), selected: false),
                  SizedBox(width: 8),
                  ChoiceChip(label: Text('High Stipend'), selected: false),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Internships Cards
            ...sampleInternships.map((intern) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: GlassCard(
                  onTap: () => context.push('/jobs/details/${intern['id']}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              intern['title'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.darkSecondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(AppRadii.pill),
                              border: Border.all(color: AppColors.darkSecondary.withValues(alpha: 0.4)),
                            ),
                            child: Text(
                              intern['duration'] as String,
                              style: const TextStyle(color: AppColors.darkSecondary, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        intern['company'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled),
                          const SizedBox(width: 4),
                          Text(
                            intern['location'] as String,
                            style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            intern['stipend'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkSuccess, fontSize: 14),
                          ),
                          ElevatedButton(
                            onPressed: () => context.push('/jobs/details/${intern['id']}'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            ),
                            child: const Text('Apply Now'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

