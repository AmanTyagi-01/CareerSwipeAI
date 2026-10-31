import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';

class InterviewPrepScreen extends ConsumerStatefulWidget {
  const InterviewPrepScreen({super.key});

  @override
  ConsumerState<InterviewPrepScreen> createState() => _InterviewPrepScreenState();
}

class _InterviewPrepScreenState extends ConsumerState<InterviewPrepScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'Technical Interview',
    'HR Interview',
    'Behavioral Questions',
    'Company Specific',
  ];

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
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('AI Interview Prep', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return const Center(
                child: Text('Please log in to practice interview questions.', style: TextStyle(color: Color(0xFF94A3B8))),
              );
            }
            final resumesAsync = ref.watch(userResumesProvider(user.id));
            return resumesAsync.when(
              data: (_) => _buildPrepContent(context),
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
              error: (_, __) => _buildPrepContent(context),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
          error: (_, __) => _buildPrepContent(context),
        ),
      ),
    );
  }

  Widget _buildPrepContent(BuildContext context) {
    final currentQ = _questions[_currentIndex];

    return Column(
      children: [
        // Category Pills (from poster)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: List.generate(_categories.length, (index) {
              final isSelected = _selectedCategoryIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => setState(() => _selectedCategoryIndex = index),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
                          : const Color(0xFF121622),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF232A3B),
                      ),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFF1F5F9) : const Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),

        const SizedBox(height: 12),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${_questions.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFF1F5F9)),
                  ),
                  Text(
                    '${((_currentIndex + 1) / _questions.length * 100).toInt()}% Done',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF38BDF8), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _questions.length,
                  backgroundColor: const Color(0xFF1E2638),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Flip Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FlipCardWidget(
              key: ValueKey(_currentIndex),
              front: _buildCardFront(currentQ),
              back: _buildCardBack(currentQ),
            ),
          ),
        ),

        // Navigation bottom bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFCBD5E1),
                  side: const BorderSide(color: Color(0xFF232A3B)),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _currentIndex > 0 ? () => setState(() => _currentIndex--) : null,
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
                label: const Text('Previous'),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                  ),
                ),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_currentIndex < _questions.length - 1) {
                      setState(() => _currentIndex++);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Interview Prep complete! Great job!'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                      setState(() => _currentIndex = 0);
                    }
                  },
                  icon: Icon(_currentIndex == _questions.length - 1 ? Icons.check_circle_rounded : Icons.arrow_forward_rounded, size: 16),
                  label: Text(_currentIndex == _questions.length - 1 ? 'Finish' : 'Next Question'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardFront(Map<String, String> currentQ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF232A3B)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
            ),
            child: Text(
              currentQ['category'] ?? '',
              style: const TextStyle(
                color: Color(0xFF8B5CF6),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            currentQ['question'] ?? '',
            style: const TextStyle(
              color: Color(0xFFF1F5F9),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2638),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded, color: Color(0xFF38BDF8), size: 16),
                SizedBox(width: 8),
                Text(
                  'Tap card to reveal AI answer model',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Map<String, String> currentQ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'AI SUGGESTED RESPONSE',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 20),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                currentQ['answer'] ?? '',
                style: const TextStyle(
                  color: Color(0xFFF1F5F9),
                  height: 1.55,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const Divider(color: Color(0xFF232A3B)),
          const SizedBox(height: 6),
          const Center(
            child: Text(
              'Tap card to flip back to question',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 11),
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
      duration: const Duration(milliseconds: 500),
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
              ..setEntry(3, 2, 0.001)
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
