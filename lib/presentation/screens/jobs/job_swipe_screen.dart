import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/models/job_model.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/job_provider.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/glass_card.dart';

class JobSwipeScreen extends ConsumerStatefulWidget {
  const JobSwipeScreen({super.key});

  @override
  ConsumerState<JobSwipeScreen> createState() => _JobSwipeScreenState();
}

class _JobSwipeScreenState extends ConsumerState<JobSwipeScreen> {
  final CardSwiperController _controller = CardSwiperController();


  // Mock job data
  final List<JobModel> _jobs = [
    JobModel(
      id: '1',
      title: 'Senior Flutter Developer',
      company: 'TechCorp Inc.',
      description: 'We are looking for an experienced Flutter developer to lead our mobile team. You will be responsible for architecting and building cross-platform applications.',
      shortDescription: 'Lead mobile development team building cross-platform apps',
      skills: const ['Flutter', 'Dart', 'Firebase', 'State Management', 'CI/CD'],
      experienceLevel: 'Senior',
      jobType: 'Full-time',
      location: 'San Francisco, CA',
      isRemote: true,
      minSalary: 140000,
      maxSalary: 180000,
      currency: 'USD',
      industry: 'Technology',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    JobModel(
      id: '2',
      title: 'Product Designer',
      company: 'DesignStudio',
      description: 'Join our award-winning design team to create beautiful and intuitive user experiences for mobile and web applications.',
      shortDescription: 'Create beautiful UX for mobile and web applications',
      skills: const ['Figma', 'UI/UX', 'Prototyping', 'User Research', 'Design Systems'],
      experienceLevel: 'Mid-Level',
      jobType: 'Full-time',
      location: 'New York, NY',
      isRemote: false,
      minSalary: 100000,
      maxSalary: 140000,
      currency: 'USD',
      industry: 'Design',
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    JobModel(
      id: '3',
      title: 'Full Stack Engineer',
      company: 'StartupXYZ',
      description: 'Build scalable web applications using modern technologies. Work with React, Node.js, and cloud infrastructure.',
      shortDescription: 'Build scalable web apps with React and Node.js',
      skills: const ['React', 'Node.js', 'TypeScript', 'AWS', 'GraphQL'],
      experienceLevel: 'Senior',
      jobType: 'Full-time',
      location: 'Austin, TX',
      isRemote: true,
      minSalary: 130000,
      maxSalary: 170000,
      currency: 'USD',
      industry: 'Technology',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    JobModel(
      id: '4',
      title: 'Mobile Engineer - iOS',
      company: 'AppWorks',
      description: 'Develop native iOS applications using Swift and SwiftUI. Collaborate with cross-functional teams to deliver high-quality products.',
      shortDescription: 'Develop native iOS apps with Swift and SwiftUI',
      skills: const ['Swift', 'SwiftUI', 'iOS', 'Core Data', 'Xcode'],
      experienceLevel: 'Mid-Level',
      jobType: 'Full-time',
      location: 'Seattle, WA',
      isRemote: true,
      minSalary: 120000,
      maxSalary: 160000,
      currency: 'USD',
      industry: 'Technology',
      postedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    JobModel(
      id: '5',
      title: 'DevOps Engineer',
      company: 'CloudScale',
      description: 'Manage and optimize cloud infrastructure. Implement CI/CD pipelines and ensure system reliability.',
      shortDescription: 'Manage cloud infrastructure and CI/CD pipelines',
      skills: const ['AWS', 'Docker', 'Kubernetes', 'Terraform', 'CI/CD'],
      experienceLevel: 'Senior',
      jobType: 'Full-time',
      location: 'Remote',
      isRemote: true,
      minSalary: 150000,
      maxSalary: 200000,
      currency: 'USD',
      industry: 'Technology',
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    final job = _jobs[previousIndex];
    final user = ref.read(currentUserProvider).value;

    if (user == null) return false;

    final action = direction == CardSwiperDirection.right 
        ? 'like' 
        : direction == CardSwiperDirection.left 
            ? 'dislike' 
            : 'skip';

    final jobNotifier = ref.read(jobNotifierProvider.notifier);
    jobNotifier.recordSwipe(user.id, job.id, action);

    if (direction == CardSwiperDirection.right) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved: ${job.title} at ${job.company}'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
    return true;
  }

  void _onUndo() {
    _controller.undo();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Jobs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => context.push('/jobs/saved'),
          ),
        ],
      ),
      body: AnimatedBackground(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _jobs.isNotEmpty
                    ? CardSwiper(
                        controller: _controller,
                        cardsCount: _jobs.length,
                        onSwipe: _onSwipe,
                        onUndo: (previousIndex, currentIndex, direction) => true,
                        numberOfCardsDisplayed: 2,
                        backCardOffset: const Offset(0, -20),
                        padding: const EdgeInsets.all(8),
                        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                          return _buildJobCard(context, _jobs[index], isDark);
                        },
                      )
                    : Center(
                        child: Text(
                          'No more jobs to show',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
              ),
            ),
            _buildActionButtons(context, isDark),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, JobModel job, bool isDark) {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with company info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.1),
                  AppTheme.accentColor.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      AppUtils.getInitials(job.company),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Job details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTag(context, job.jobType ?? 'Full-time', Icons.schedule, AppTheme.primaryColor, isDark),
                      const SizedBox(width: 8),
                      _buildTag(context, job.experienceLevel ?? 'Mid-Level', Icons.trending_up, AppTheme.accentColor, isDark),
                      if (job.isRemote) ...[
                        const SizedBox(width: 8),
                        _buildTag(context, 'Remote', Icons.home, AppTheme.successColor, isDark),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    job.shortDescription ?? job.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  if (job.minSalary != null || job.maxSalary != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.successColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_money, color: AppTheme.successColor, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            AppUtils.formatSalary(job.minSalary, job.maxSalary, job.currency ?? 'USD'),
                            style: const TextStyle(
                              color: AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Skills Required',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.skills.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        job.location ?? 'Location not specified',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        AppUtils.formatRelativeTime(job.postedAt ?? DateTime.now()),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // View Details button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => context.push('/jobs/details/${job.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            icon: Icons.close,
            color: AppTheme.errorColor,
            onPressed: () => _controller.swipe(CardSwiperDirection.left),
          ),
          _buildActionButton(
            context,
            icon: Icons.undo,
            color: AppTheme.infoColor,
            onPressed: _onUndo,
            size: 50,
          ),
          _buildActionButton(
            context,
            icon: Icons.favorite,
            color: AppTheme.successColor,
            onPressed: () => _controller.swipe(CardSwiperDirection.right),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 64,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size * 0.4),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Filter Jobs',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Job Type',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: AppConstants.jobTypes.map((type) {
                    return FilterChip(
                      label: Text(type),
                      onSelected: (selected) {},
                      selected: false,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Experience Level',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: AppConstants.experienceLevels.map((level) {
                    return FilterChip(
                      label: Text(level),
                      onSelected: (selected) {},
                      selected: false,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
