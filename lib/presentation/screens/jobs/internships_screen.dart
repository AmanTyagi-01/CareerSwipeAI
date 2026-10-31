import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InternshipsScreen extends ConsumerStatefulWidget {
  const InternshipsScreen({super.key});

  @override
  ConsumerState<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends ConsumerState<InternshipsScreen> {
  String _selectedFilter = 'All';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _sampleInternships = [
    {
      'id': 'intern-1',
      'title': 'AI & ML Engineering Intern',
      'company': 'Google DeepMind',
      'location': 'Bengaluru, India',
      'workMode': 'Hybrid',
      'duration': '6 Months',
      'stipend': '₹80,000 / month',
      'skills': ['Python', 'PyTorch', 'Transformers', 'Math'],
      'deadline': 'Nov 30, 2026',
      'initial': 'G',
    },
    {
      'id': 'intern-2',
      'title': 'Mobile Flutter Developer Intern',
      'company': 'Microsoft',
      'location': 'Hyderabad, India',
      'workMode': 'Remote',
      'duration': '3 Months',
      'stipend': '₹65,000 / month',
      'skills': ['Flutter', 'Dart', 'State Management', 'REST'],
      'deadline': 'Dec 15, 2026',
      'initial': 'M',
    },
    {
      'id': 'intern-3',
      'title': 'Product Design & UI/UX Intern',
      'company': 'Swiggy',
      'location': 'Bengaluru, India',
      'workMode': 'On-site',
      'duration': '6 Months',
      'stipend': '₹40,000 / month',
      'skills': ['Figma', 'Prototyping', 'User Research'],
      'deadline': 'Dec 1, 2026',
      'initial': 'S',
    },
    {
      'id': 'intern-4',
      'title': 'Cloud & DevOps Intern',
      'company': 'Amazon AWS',
      'location': 'Gurugram, India',
      'workMode': 'Hybrid',
      'duration': '6 Months',
      'stipend': '₹75,000 / month',
      'skills': ['Docker', 'AWS', 'Linux', 'CI/CD'],
      'deadline': 'Dec 10, 2026',
      'initial': 'A',
    },
  ];

  List<String> get _filters => ['All', 'Remote', 'Hybrid', 'On-site'];

  List<Map<String, dynamic>> get _filteredInternships {
    if (_selectedFilter == 'All') return _sampleInternships;
    return _sampleInternships
        .where((i) => i['workMode'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text(
          'Internships',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF1F5F9)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Color(0xFFF1F5F9)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded, color: Color(0xFFF1F5F9)),
            onPressed: () => context.push('/jobs/saved'),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF0A0E17),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Color(0xFFF1F5F9)),
                decoration: InputDecoration(
                  hintText: 'Search internships, skills, or companies...',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: const Color(0xFF121622),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF232A3B)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF232A3B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),
            const SizedBox(height: 12),

            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _selectedFilter == filter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                              )
                            : null,
                        color: isSelected ? null : const Color(0xFF121622),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : const Color(0xFF232A3B),
                        ),
                      ),
                      child: Text(
                        filter,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 12),

            // Internship cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: _filteredInternships.length,
                itemBuilder: (context, index) {
                  final intern = _filteredInternships[index];
                  return _buildInternshipCard(context, intern, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInternshipCard(
      BuildContext context, Map<String, dynamic> intern, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/jobs/details/${intern['id']}'),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF121622),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF232A3B)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company logo placeholder
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        intern['initial'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intern['title'] as String,
                          style: const TextStyle(
                            color: Color(0xFFF1F5F9),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          intern['company'] as String,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Duration badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      intern['duration'] as String,
                      style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Location + work mode
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 4),
                  Text(
                    '${intern['location']}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2035),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      intern['workMode'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B5CF6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Skills chips
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: (intern['skills'] as List<String>).map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2035),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF232A3B)),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFF232A3B), height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intern['stipend'] as String,
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 11, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 4),
                          Text(
                            'Deadline: ${intern['deadline']}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Apply button
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push('/jobs/details/${intern['id']}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 + index * 60)).slideY(begin: 0.1, end: 0);
  }
}
