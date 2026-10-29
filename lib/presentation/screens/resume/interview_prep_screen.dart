import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class InterviewPrepScreen extends ConsumerStatefulWidget {
  const InterviewPrepScreen({super.key});

  @override
  ConsumerState<InterviewPrepScreen> createState() => _InterviewPrepScreenState();
}

class _InterviewPrepScreenState extends ConsumerState<InterviewPrepScreen> {
  final List<Map<String, String>> _questions = [
    {
      'category': 'Technical - Flutter/Dart',
      'question': 'How does Flutter render UI elements, and what is the relationship between Widgets, Elements, and RenderObjects?',
      'answer': 'Flutter uses a three-tree architecture:\n1. Widget Tree: Lightweight, immutable configurations of UI.\n2. Element Tree: Manages the lifecycle and coordinates between widget changes and rendering.\n3. RenderObject Tree: Controls size, layout, and painting.\n\nTip: Mention that Elements are the actual nodes in the tree, while Widgets are instructions to build them.',
    },
    {
      'category': 'Technical - State Management',
      'question': 'Why choose Riverpod over Provider, and how does it handle dependency injection synchronously/asynchronously?',
      'answer': 'Riverpod resolves compile-time safety concerns of Provider. It does not rely on BuildContext, meaning providers can be declared globally and accessed anywhere. It handles async data elegantly via FutureProvider/StreamProvider and maintains a clean caching model.\n\nTip: Emphasize that Riverpod solves Provider\'s ProviderNotFoundException at compile time.',
    },
    {
      'category': 'Behavioral - Leadership',
      'question': 'Tell me about a time you had to deal with a technical disagreement on your mobile development team.',
      'answer': 'Use the STAR method:\n- Situation: Disagreeing on architecture (e.g. MVVM vs Clean Architecture).\n- Task: We needed to align quickly to meet product deadlines.\n- Action: Set up a spike to write mock implementations of both, measured development speed and readability, and documented the trade-offs.\n- Result: Adopted a hybrid approach that satisfied both performance requirements and developer velocity.\n\nTip: Keep the response professional and focus on data-driven decision making.',
    },
    {
      'category': 'Behavioral - Problem Solving',
      'question': 'Describe a complex performance issue you resolved in a Flutter application.',
      'answer': 'Use the STAR method:\n- Situation: High memory usage and frame drops (jank) during list scrolling.\n- Task: Diagnose and optimize the UI to maintain 60/120 FPS.\n- Action: Profiled the app using Flutter DevTools. Identified heavy image sizes and unnecessary rebuilds. Added RepaintBoundary, optimized image caching, and cached list item widgets.\n- Result: Reduced frame drops by 80% and lowered memory usage by 40MB.\n\nTip: Reference specific DevTools like CPU Profiler and Flutter Performance overlay.',
    },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Interview Prep'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.transparent],
            ),
          ),
        ),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: userAsync.when(
            data: (user) {
              if (user == null) {
                return const Center(child: Text('Please log in to prepare for interviews.'));
              }
              // Fetch user resumes to check if they have uploaded one
              final resumesAsync = ref.watch(userResumesProvider(user.id));
              return resumesAsync.when(
                data: (resumes) {
                  final activeResume = resumes.isEmpty 
                      ? null 
                      : resumes.firstWhere((r) => r.isActive, orElse: () => resumes.first);

                  if (activeResume == null) {
                    return _buildNoResumeState(context);
                  }

                  return _buildPrepContent(context);
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResumeState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: GlassCard(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.question_answer_outlined,
                  size: 80,
                  color: AppTheme.primaryColor.withValues(alpha: 0.8),
                ),
                const SizedBox(height: 24),
                Text(
                  'No Resume Uploaded',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Upload your resume to receive custom AI-generated interview prep questions tailored specifically to your experience and project accomplishments.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Go to Resume Upload'),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
      ),
    );
  }

  Widget _buildPrepContent(BuildContext context) {
    final currentQ = _questions[_currentIndex];

    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white10 
                : Colors.black12,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            borderRadius: BorderRadius.circular(8),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Question ${_currentIndex + 1} of ${_questions.length}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 20),
        
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FlipCardWidget(
              key: ValueKey(_currentIndex),
              front: _buildCardFront(currentQ),
              back: _buildCardBack(currentQ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: _currentIndex > 0 
                    ? () => setState(() => _currentIndex--) 
                    : null,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: _currentIndex < _questions.length - 1 
                    ? () => setState(() => _currentIndex++) 
                    : () {
                        // Reset or show completion
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Interview Prep session complete!')),
                        );
                        setState(() => _currentIndex = 0);
                      },
                child: Text(_currentIndex == _questions.length - 1 ? 'Finish' : 'Next'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCardFront(Map<String, String> currentQ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              currentQ['category'] ?? '',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            currentQ['question'] ?? '',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Text(
                'Tap to reveal AI Guide',
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Map<String, String> currentQ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.successColor.withValues(alpha: 0.2)),
                ),
                child: const Text(
                  'AI SUGGESTED RESPONSE',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.check_circle_outline, color: AppTheme.successColor),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                currentQ['answer'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tap to return to question',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class FlipCardWidget extends StatefulWidget {
  final Widget front;
  final Widget back;

  const FlipCardWidget({required this.front, required this.back, super.key});

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final transformValue = _controller.value * pi;
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(transformValue),
            alignment: Alignment.center,
            child: transformValue < pi / 2
                ? widget.front
                : Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}
