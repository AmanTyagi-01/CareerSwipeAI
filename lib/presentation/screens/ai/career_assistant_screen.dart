import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/animated_background.dart';

class CareerAssistantScreen extends ConsumerStatefulWidget {
  const CareerAssistantScreen({super.key});

  @override
  ConsumerState<CareerAssistantScreen> createState() => _CareerAssistantScreenState();
}

class _CareerAssistantScreenState extends ConsumerState<CareerAssistantScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am your CareerSwipe AI Career Coach. How can I help boost your career today? I can explain job descriptions, highlight missing resume skills, suggest projects, or conduct mock interview questions.',
      'time': 'Just now',
    },
  ];

  final List<String> _suggestedPrompts = [
    'How can I improve my resume?',
    'What skills are missing for Senior Flutter roles?',
    'Help me prepare for an interview',
    'Suggest a relevant portfolio project',
    'Explain the ATS scoring criteria',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? promptText]) {
    final text = promptText ?? _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'time': 'Just now',
      });
      if (promptText == null) _messageController.clear();
    });

    _scrollToBottom();

    // Generate grounded contextual response
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      String response = '';

      final lower = text.toLowerCase();
      if (lower.contains('improve') || lower.contains('resume')) {
        response = 'Here are 3 evidence-grounded ways to improve your resume:\n'
            '1. Quantify achievements: e.g. "Reduced app load time by 35% using selective widget rebuilds."\n'
            '2. Align keywords: Ensure your resume explicitly includes required skills like Riverpod, Clean Architecture, and REST APIs.\n'
            '3. Format clarity: Keep standard sections (Experience, Education, Projects, Skills) in a single-column layout for ATS readability.';
      } else if (lower.contains('interview') || lower.contains('prepare')) {
        response = 'Let\'s practice a technical interview question for Mobile Engineering:\n\n'
            'Q: How does Flutter\'s rendering pipeline work, and how do BuildContext and the Element tree manage state transitions under high load?\n\n'
            'Take a moment to draft your response, or tap below to see structural tips.';
      } else if (lower.contains('project') || lower.contains('portfolio')) {
        response = 'Recommended Portfolio Project for Mobile & AI:\n\n'
            'Title: On-Device AI Document Scanner & Classifier\n'
            'Tech Stack: Flutter, Riverpod, TensorFlow Lite / Google ML Kit\n'
            'Impact: Demonstrates high-performance UI, asynchronous background isolates, and real on-device model inference.';
      } else {
        response = 'Based on your profile, focusing on demonstrated projects with measurable impact and keeping your skills up-to-date with Flutter 3.x and AI integrations will put you in the top 10% of applicants.';
      }

      setState(() {
        _messages.add({
          'isUser': false,
          'text': response,
          'time': 'Just now',
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text('Career Assistant (AI)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add({
                  'isUser': false,
                  'text': 'Conversation reset. How can I help you today?',
                  'time': 'Just now',
                });
              });
            },
          ),
        ],
      ),
      body: AnimatedBackground(
        child: Column(
          children: [
            // Prompt Pills Carousel
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                scrollDirection: Axis.horizontal,
                itemCount: _suggestedPrompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final prompt = _suggestedPrompts[index];
                  return ActionChip(
                    label: Text(prompt, style: const TextStyle(fontSize: 12)),
                    backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
                    side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    onPressed: () => _sendMessage(prompt),
                  );
                },
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final m = _messages[index];
                  final isUser = m['isUser'] as bool;

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: isUser ? AppColors.primaryGradient : null,
                        color: isUser
                            ? null
                            : (isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(AppRadii.lg),
                          topRight: const Radius.circular(AppRadii.lg),
                          bottomLeft: Radius.circular(isUser ? AppRadii.lg : AppRadii.sm),
                          bottomRight: Radius.circular(isUser ? AppRadii.sm : AppRadii.lg),
                        ),
                        border: isUser ? null : Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        boxShadow: isUser ? AppElevation.darkCardShadow(intensity: 0.3) : null,
                      ),
                      child: Text(
                        m['text'] as String,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Ask anything about your career...',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadii.pill)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadii.pill),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filled(
                      style: IconButton.styleFrom(backgroundColor: AppColors.darkPrimary),
                      onPressed: () => _sendMessage(),
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
