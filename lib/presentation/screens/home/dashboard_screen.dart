import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/job_provider.dart';

/// Candidate Home Dashboard matching Poster 1 Screen 4 & Poster 2 Screen 6:
/// - User avatar with green online badge + "Good Morning, Aman!"
/// - Notification bell with badge
/// - Search bar ("Search jobs, internships...") with filter button
/// - Horizontal filter pills: [ All ], Remote, Full Time, Internship
/// - 3-Metric KPI bar: 12 Applied | 5 Saved | 3 Interviews
/// - ATS Quick Score Card (78/100, Good Match)
/// - "Recommended for You" job list: Google, Amazon, Microsoft, Swiggy
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Remote', 'Full Time', 'Internship'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final userName = user?.displayName?.split(' ').first ?? 'Aman';
    final appliedJobsAsync =
        user != null ? ref.watch(appliedJobsProvider(user.id)) : null;
    final appliedCount = appliedJobsAsync?.value?.length ?? 12;
    final savedCount = user?.savedJobIds.length ?? 5;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Avatar + "Good Morning, Aman!" + Notification Bell
              _buildHeader(context, userName),

              const SizedBox(height: 20),

              // 2. Search Bar + Filter Icon
              _buildSearchBar(context),

              const SizedBox(height: 16),

              // 3. Filter Pills: [ All ], Remote, Full Time, Internship
              _buildFilterPills(),

              const SizedBox(height: 20),

              // 4. 3-Metric KPI Bar: 12 Applied | 5 Saved | 3 Interviews
              _buildKpiBar(context, appliedCount, savedCount),

              const SizedBox(height: 20),

              // 5. ATS Quick Banner: "78/100 - Good Match"
              _buildAtsBanner(context),

              const SizedBox(height: 24),

              // 6. "Recommended for You" Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommended for You',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/jobs/swipe'),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 7. Recommended Job Cards List
              _buildJobCard(
                context,
                company: 'Google',
                title: 'Software Engineer',
                location: 'Bengaluru, India · Remote',
                salary: '₹12-25 LPA',
                type: 'Full Time',
                logoColor: const Color(0xFF4285F4),
                logoText: 'G',
                skills: ['Python', 'React', 'System Design'],
                isSaved: true,
              ),

              const SizedBox(height: 12),

              _buildJobCard(
                context,
                company: 'Amazon',
                title: 'Frontend Developer',
                location: 'Hyderabad, India · Hybrid',
                salary: '₹10-20 LPA',
                type: 'Full Time',
                logoColor: const Color(0xFFFF9900),
                logoText: 'a',
                skills: ['Flutter', 'TypeScript', 'Redux'],
                isSaved: false,
              ),

              const SizedBox(height: 12),

              _buildJobCard(
                context,
                company: 'Microsoft',
                title: 'AI/ML Intern',
                location: 'Noida, India · On-site',
                salary: '₹80k/month',
                type: 'Internship',
                logoColor: const Color(0xFF00A4EF),
                logoText: 'M',
                skills: ['PyTorch', 'LLMs', 'NLP'],
                isSaved: true,
              ),

              const SizedBox(height: 12),

              _buildJobCard(
                context,
                company: 'Swiggy',
                title: 'Product Manager',
                location: 'Bengaluru, India · Remote',
                salary: '₹18-30 LPA',
                type: 'Full Time',
                logoColor: const Color(0xFFFC8019),
                logoText: 'S',
                skills: ['Product Strategy', 'Analytics', 'Agile'],
                isSaved: false,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // --- Header ---------------------------------------------------------------
  Widget _buildHeader(BuildContext context, String userName) {
    return Row(
      children: [
        // Avatar with green online dot
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)],
                ),
                border: Border.all(color: const Color(0xFF2A334A), width: 1.5),
              ),
              child: Center(
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'A',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0A0E17), width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),

        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Morning,',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$userName!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),

        // Notification Icon with red dot
        InkWell(
          onTap: () => context.push('/profile/notifications'),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF121622),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF232A3B)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Search Bar -----------------------------------------------------------
  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search jobs, internships...',
                hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded,
                color: Color(0xFF8B5CF6), size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // --- Filter Pills ---------------------------------------------------------
  Widget _buildFilterPills() {
    return SizedBox(
      height: 34,
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF7C3AED)
                    : const Color(0xFF121622),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF232A3B),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color:
                              const Color(0xFF7C3AED).withValues(alpha: 0.35),
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
    );
  }

  // --- 3-Metric KPI Bar -----------------------------------------------------
  Widget _buildKpiBar(BuildContext context, int appliedCount, int savedCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF232A3B)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricItem(
              count: '$appliedCount',
              label: 'Applied',
              countColor: const Color(0xFF38BDF8),
              onTap: () => context.push('/jobs/applied'),
            ),
          ),
          Container(width: 1, height: 36, color: const Color(0xFF232A3B)),
          Expanded(
            child: _buildMetricItem(
              count: '$savedCount',
              label: 'Saved',
              countColor: const Color(0xFFA78BFA),
              onTap: () => context.push('/profile/saved-jobs'),
            ),
          ),
          Container(width: 1, height: 36, color: const Color(0xFF232A3B)),
          Expanded(
            child: _buildMetricItem(
              count: '3',
              label: 'Interviews',
              countColor: const Color(0xFF34D399),
              onTap: () => context.push('/resume/interview-prep'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String count,
    required String label,
    required Color countColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: countColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  // --- ATS Quick Banner -----------------------------------------------------
  Widget _buildAtsBanner(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/resume/analysis'),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF121622)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: const Row(
          children: [
            // Mini circular indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CircularProgressIndicator(
                    value: 0.78,
                    strokeWidth: 4.5,
                    backgroundColor: Color(0xFF232A3B),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
                Text(
                  '78',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'ATS Resume Score',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.bolt, color: Color(0xFFFBBF24), size: 16),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Good Match · 3 suggestions available',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF34D399),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Color(0xFF94A3B8), size: 16),
          ],
        ),
      ),
    );
  }

  // --- Job Card -------------------------------------------------------------
  Widget _buildJobCard(
    BuildContext context, {
    required String company,
    required String title,
    required String location,
    required String salary,
    required String type,
    required Color logoColor,
    required String logoText,
    required List<String> skills,
    required bool isSaved,
  }) {
    return InkWell(
      onTap: () => context.push('/jobs/details', extra: title),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF121622),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF232A3B)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Company Logo Badge
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: logoColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: logoColor.withValues(alpha: 0.4)),
                  ),
                  child: Center(
                    child: Text(
                      logoText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: logoColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Job Title & Company
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bookmark icon
                IconButton(
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_outline_rounded,
                    color: isSaved
                        ? const Color(0xFF8B5CF6)
                        : const Color(0xFF64748B),
                    size: 22,
                  ),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Tags row: Salary, Type, Skills
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2436),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    salary,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2436),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Quick Apply',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
