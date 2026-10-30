import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Applications Tracker Screen matching Poster 1 Screen 9 & Poster 2 Screen 9:
/// - Title: "My Applications"
/// - Filter Tabs: [ All ] | Applied | Interview | Offers
/// - Application Cards:
///   1. Google: Software Engineer — "Applied - 3 days ago" (Teal)
///   2. Microsoft: Product Intern — "Interview Scheduled" (Sky Blue)
///   3. Amazon: Frontend Developer — "Under Review" (Amber)
///   4. Swiggy: Product Manager — "Rejected" (Coral)
class AppliedJobsScreen extends ConsumerStatefulWidget {
  const AppliedJobsScreen({super.key});

  @override
  ConsumerState<AppliedJobsScreen> createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends ConsumerState<AppliedJobsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Applied', 'Interview', 'Offers'];

  final List<Map<String, dynamic>> _applications = [
    {
      'company': 'Google',
      'role': 'Software Engineer',
      'location': 'Bengaluru, India · Remote',
      'status': 'Applied - 3 days ago',
      'statusColor': const Color(0xFF10B981),
      'logoColor': const Color(0xFF4285F4),
      'logoText': 'G',
      'type': 'Full Time',
      'filterCategory': 'Applied',
    },
    {
      'company': 'Microsoft',
      'role': 'Product Intern',
      'location': 'Noida, India · On-site',
      'status': 'Interview Scheduled',
      'statusColor': const Color(0xFF38BDF8),
      'logoColor': const Color(0xFF00A4EF),
      'logoText': 'M',
      'type': 'Internship',
      'filterCategory': 'Interview',
    },
    {
      'company': 'Amazon',
      'role': 'Frontend Developer',
      'location': 'Hyderabad, India · Hybrid',
      'status': 'Under Review',
      'statusColor': const Color(0xFFF59E0B),
      'logoColor': const Color(0xFFFF9900),
      'logoText': 'a',
      'type': 'Full Time',
      'filterCategory': 'Applied',
    },
    {
      'company': 'Swiggy',
      'role': 'Product Manager',
      'location': 'Bengaluru, India · Remote',
      'status': 'Rejected',
      'statusColor': const Color(0xFFEF4444),
      'logoColor': const Color(0xFFFC8019),
      'logoText': 'S',
      'type': 'Full Time',
      'filterCategory': 'Applied',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final activeFilter = _filters[_selectedFilterIndex];
    final filteredApps = activeFilter == 'All'
        ? _applications
        : _applications.where((app) => app['filterCategory'] == activeFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        title: const Text(
          'My Applications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Tabs: All | Applied | Interview | Offers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, idx) {
                    final isSelected = _selectedFilterIndex == idx;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedFilterIndex = idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF121622),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF232A3B),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                                    blurRadius: 10,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          _filters[idx],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Application Cards List
            Expanded(
              child: filteredApps.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, color: Color(0xFF64748B), size: 48),
                          SizedBox(height: 12),
                          Text(
                            'No applications in this category yet',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredApps.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, idx) {
                        final app = filteredApps[idx];
                        return _buildCard(context, app);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> app) {
    final statusColor = app['statusColor'] as Color;
    final logoColor = app['logoColor'] as Color;

    return InkWell(
      onTap: () => context.push('/jobs/details', extra: app['role']),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF121622),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF232A3B)),
        ),
        child: Row(
          children: [
            // Company Logo Badge
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: logoColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: logoColor.withValues(alpha: 0.4)),
              ),
              child: Center(
                child: Text(
                  app['logoText'] as String,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: logoColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Role and Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app['company'] as String,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    app['role'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      app['status'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 20),
          ],
        ),
      ),
    );
  }
}
