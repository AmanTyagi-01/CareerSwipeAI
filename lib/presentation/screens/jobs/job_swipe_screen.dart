import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../data/models/job_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/job_provider.dart';

/// Discover Opportunities / Job Swipe Screen matching Poster 1 Screen 5 & Poster 2 Screen 7:
/// - Search bar + Filter chips: [ All ], Remote, Full Time, Internship
/// - Large cinematic swipe card with hero cover image, company badge, tags, description, skills
/// - 3 Floating action buttons: [ ✕ Pass ] (Red), [ ★ Star/Save ] (Cyan), [ ♥ Like/Apply ] (Mint Green)
class JobSwipeScreen extends ConsumerStatefulWidget {
  const JobSwipeScreen({super.key});

  @override
  ConsumerState<JobSwipeScreen> createState() => _JobSwipeScreenState();
}

class _JobSwipeScreenState extends ConsumerState<JobSwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Remote', 'Full Time', 'Internship'];

  final List<JobModel> _mockJobs = [
    JobModel(
      id: 'job-1',
      title: 'Software Engineer',
      company: 'Amazon',
      location: 'Bengaluru, India · Remote',
      minSalary: 1200000,
      maxSalary: 3500000,
      currency: 'INR',
      jobType: 'Full Time',
      experienceLevel: '3-5 years',
      isRemote: true,
      description:
          'Join Amazon’s innovative cloud team building scalable distributed systems that serve hundreds of millions of users globally.',
      shortDescription:
          'Join Amazon’s innovative cloud team building scalable systems.',
      skills: const ['Python', 'React', 'System Design', 'AWS'],
      postedAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    JobModel(
      id: 'job-2',
      title: 'Senior Frontend Developer',
      company: 'Google',
      location: 'Hyderabad, India · Hybrid',
      minSalary: 1400000,
      maxSalary: 2800000,
      currency: 'INR',
      jobType: 'Full Time',
      experienceLevel: '4+ years',
      isRemote: false,
      description:
          'Craft intuitive, highly accessible web and mobile user interfaces across Google Workspace and Developer Platform tools.',
      shortDescription: 'Craft intuitive UI across Google developer tools.',
      skills: const ['Flutter', 'TypeScript', 'Web Architecture'],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    JobModel(
      id: 'job-3',
      title: 'AI/ML Research Intern',
      company: 'Microsoft',
      location: 'Noida, India · On-site',
      minSalary: 960000,
      maxSalary: 1200000,
      currency: 'INR',
      jobType: 'Internship',
      experienceLevel: '0-1 year',
      isRemote: false,
      description:
          'Work with the Microsoft Research India team applying foundation models and generative AI to multimodal enterprise tasks.',
      shortDescription:
          'Apply foundation models to generative enterprise tasks.',
      skills: const ['PyTorch', 'LLMs', 'Python', 'NLP'],
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _currentCardIndex = 0;

  bool _onSwipe(
      int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    final jobs = _getFilteredJobs();
    if (jobs.isEmpty) return true;
    final job = jobs[previousIndex % jobs.length];
    final user = ref.read(currentUserProvider).value;

    setState(() {
      _currentCardIndex = currentIndex ?? (previousIndex + 1);
    });

    if (direction == CardSwiperDirection.right) {
      if (user != null) {
        ref.read(jobServiceProvider).recordSwipe(user.id, job.id, 'apply');
        ref.read(jobServiceProvider).applyForJob(
              user.id,
              job.id,
              resumeUrl: user.resumeUrl,
            );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Applied to ${job.title} at ${job.company}! 🎯'),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (direction == CardSwiperDirection.left) {
      if (user != null) {
        ref.read(jobServiceProvider).recordSwipe(user.id, job.id, 'pass');
      }
    }
    return true;
  }

  List<JobModel> _getFilteredJobs() {
    final jobsAsync = ref.watch(jobsProvider(null));
    final sourceList = (jobsAsync.value != null && jobsAsync.value!.isNotEmpty)
        ? jobsAsync.value!
        : _mockJobs;

    switch (_selectedFilterIndex) {
      case 1: // Remote
        return sourceList.where((j) => j.isRemote).toList();
      case 2: // Full Time
        return sourceList
            .where((j) => j.jobType?.toLowerCase().contains('full') == true)
            .toList();
      case 3: // Internship
        return sourceList
            .where((j) => j.jobType?.toLowerCase().contains('intern') == true)
            .toList();
      default:
        return sourceList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Title & Filter Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Discover Opportunities',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.tune_rounded,
                            color: Color(0xFF8B5CF6)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        final isSelected = _selectedFilterIndex == idx;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedFilterIndex = idx),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF7C3AED)
                                  : const Color(0xFF121622),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : const Color(0xFF232A3B),
                              ),
                            ),
                            child: Text(
                              _filters[idx],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Swipe Deck
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (context) {
                    final displayJobs = _getFilteredJobs();
                    if (displayJobs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.work_off_outlined,
                                color: Color(0xFF64748B), size: 48),
                            const SizedBox(height: 12),
                            const Text(
                              'No opportunities found in this category',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8), fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _selectedFilterIndex = 0),
                              child: const Text('Reset Filter',
                                  style: TextStyle(color: Color(0xFF8B5CF6))),
                            ),
                          ],
                        ),
                      );
                    }
                    return CardSwiper(
                      controller: _controller,
                      cardsCount: displayJobs.length,
                      onSwipe: _onSwipe,
                      numberOfCardsDisplayed: displayJobs.length > 1 ? 2 : 1,
                      backCardOffset: const Offset(0, 18),
                      padding: const EdgeInsets.only(bottom: 12),
                      cardBuilder: (context, index, percentX, percentY) {
                        final job = displayJobs[index % displayJobs.length];
                        return _buildJobCard(context, job);
                      },
                    );
                  },
                ),
              ),
            ),

            // 3 Circular Action Buttons: [ X Pass ], [ ★ Star ], [ ♥ Like ]
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pass Button (Red)
                  _buildActionButton(
                    icon: Icons.close_rounded,
                    color: const Color(0xFFEF4444),
                    bgColor: const Color(0xFF2B151C),
                    borderColor: const Color(0xFFEF4444).withValues(alpha: 0.4),
                    size: 60,
                    iconSize: 28,
                    onTap: () => _controller.swipe(CardSwiperDirection.left),
                  ),

                  const SizedBox(width: 24),

                  // Superlike / Save Button (Cyan)
                  _buildActionButton(
                    icon: Icons.star_rounded,
                    color: const Color(0xFF38BDF8),
                    bgColor: const Color(0xFF0F243A),
                    borderColor: const Color(0xFF38BDF8).withValues(alpha: 0.4),
                    size: 50,
                    iconSize: 24,
                    onTap: () {
                      final jobs = _getFilteredJobs();
                      if (jobs.isNotEmpty) {
                        final job = jobs[_currentCardIndex % jobs.length];
                        final user = ref.read(currentUserProvider).value;
                        if (user != null) {
                          ref
                              .read(jobServiceProvider)
                              .recordSwipe(user.id, job.id, 'save');
                          ref.read(jobServiceProvider).saveJob(user.id, job.id);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Saved "${job.title}" to opportunities! ⭐'),
                            backgroundColor: const Color(0xFF0284C7),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        _controller.swipe(CardSwiperDirection.top);
                      }
                    },
                  ),

                  const SizedBox(width: 24),

                  // Apply / Like Button (Teal / Green)
                  _buildActionButton(
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFF10B981),
                    bgColor: const Color(0xFF0F2E22),
                    borderColor: const Color(0xFF10B981).withValues(alpha: 0.4),
                    size: 60,
                    iconSize: 28,
                    onTap: () => _controller.swipe(CardSwiperDirection.right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required Color borderColor,
    required double size,
    required double iconSize,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, color: color, size: iconSize),
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, JobModel job) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF232A3B), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Cover Banner with subtle gradient
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF312E81),
                  Color(0xFF0F172A),
                  Color(0xFF1E1B4B)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                // Glowing radial accent
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    ),
                  ),
                ),
                // Match score tag in top right
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0E17).withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF10B981)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, color: Color(0xFF10B981), size: 14),
                        SizedBox(width: 4),
                        Text(
                          '94% Fit',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Floating Company Logo Badge
                Positioned(
                  left: 20,
                  bottom: 14,
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2333),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFF38BDF8), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        job.company.isNotEmpty ? job.company[0] : 'J',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${job.company} · ${job.location}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tags: Job Type, Remote, Salary
                  Row(
                    children: [
                      _buildChip(
                          job.jobType ?? 'Full Time', const Color(0xFF8B5CF6)),
                      const SizedBox(width: 8),
                      if (job.isRemote) ...[
                        _buildChip('Remote', const Color(0xFF38BDF8)),
                        const SizedBox(width: 8),
                      ],
                      _buildChip('₹12-35 LPA', const Color(0xFF10B981)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Job Description',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    job.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'Skills Required',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: job.skills.take(4).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2436),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2A334A)),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE2E8F0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const Spacer(),

                  // Tap to View Full Details
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          context.push('/jobs/details', extra: job.id),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'View Full Details',
                            style: TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded,
                              size: 14, color: Color(0xFF8B5CF6)),
                        ],
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

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
