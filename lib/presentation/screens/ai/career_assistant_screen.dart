import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      'text': 'Hello Aman! I am your CareerSwipe AI Career Coach. How can I accelerate your job hunt or interview prep today?',
      'time': 'Just now',
    },
  ];

  final List<String> _suggestedPrompts = [
    'How can I improve my resume?',
    'What skills are missing for Senior Flutter roles?',
    'Conduct a mock interview question',
    'Suggest portfolio projects for ATS ranking',
    'Explain how ATS scores are calculated',
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

    // Grounded AI response logic
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      String response = '';

      final lower = text.toLowerCase();
      if (lower.contains('improve') || lower.contains('resume')) {
        response = 'Here are 3 evidence-grounded resume optimizations:\n\n'
            '1. Quantify achievements: Replace "Worked on checkout flow" with "Redesigned payment checkout reducing drop-off by 22%".\n\n'
            '2. Align keywords: Ensure your resume explicitly includes required job keywords like Riverpod, Clean Architecture, and REST APIs.\n\n'
            '3. Single-column format: Keep standard sections (Experience, Education, Projects, Skills) in a single-column layout for ATS readability.';
      } else if (lower.contains('interview') || lower.contains('mock')) {
        response = 'Technical Interview Drill:\n\n'
            'Q: How does Flutter\'s rendering pipeline work, and what is the difference between Widget, Element, and RenderObject trees under high rebuild frequency?\n\n'
            'Structure your answer using the 3-tree explanation, highlighting that RenderObjects handle layout & painting while Elements handle lifecycle!';
      } else if (lower.contains('project') || lower.contains('portfolio')) {
        response = 'High-Impact Portfolio Project Idea:\n\n'
            'Title: Real-Time Offline-First Mobile Dashboard\n'
            'Tech Stack: Flutter 3.x, Riverpod 2.x, SQLite/Isar, WebSocket\n'
            'Impact: Highlights local caching, reactive streams, and resilient background synchronization.';
      } else {
        response = 'Your profile is currently rated 78/100 ("Good Match"). Adding 2 quantitative metric points and highlighting unit testing experience will elevate your profile to top 5% applicant standing.';
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            const Text(
              'Career Assistant (AI)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF94A3B8)),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add({
                  'isUser': false,
                  'text': 'Conversation reset. How can I help boost your career today?',
                  'time': 'Just now',
                });
              });
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Prompt suggestions
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _suggestedPrompts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final prompt = _suggestedPrompts[index];
                return InkWell(
                  onTap: () => _sendMessage(prompt),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121622),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF232A3B)),
                    ),
                    child: Text(
                      prompt,
                      style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),

          // Chat messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isUser = m['isUser'] as bool;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                            )
                          : null,
                      color: isUser ? null : const Color(0xFF121622),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                      border: isUser ? null : Border.all(color: const Color(0xFF232A3B)),
                      boxShadow: isUser
                          ? [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      m['text'] as String,
                      style: TextStyle(
                        color: isUser ? Colors.white : const Color(0xFFF1F5F9),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.05, end: 0);
              },
            ),
          ),

          // Input field bottom bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0A0E17),
              border: Border(top: BorderSide(color: Color(0xFF232A3B))),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF121622),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF232A3B)),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 14),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        decoration: const InputDecoration(
                          hintText: 'Ask anything about your career...',
                          hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _sendMessage(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
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
}
