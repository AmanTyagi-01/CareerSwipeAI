import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../data/models/resume_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class PdfPreviewScreen extends ConsumerStatefulWidget {
  const PdfPreviewScreen({super.key});

  @override
  ConsumerState<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends ConsumerState<PdfPreviewScreen> {
  String _selectedTemplate = 'Modern';

  final List<String> _templates = ['Modern', 'Minimalist', 'Executive'];

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume PDF Preview'),
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
                return const Center(child: Text('Please log in to preview your resume.'));
              }
              // Fetch user resumes to get the active one
              final resumesAsync = ref.watch(userResumesProvider(user.id));
              return resumesAsync.when(
                data: (resumes) {
                  final activeResume = resumes.isEmpty 
                      ? null 
                      : resumes.firstWhere((r) => r.isActive, orElse: () => resumes.first);

                  if (activeResume == null) {
                    return _buildNoResumeState(context);
                  }

                  return _buildPreviewContent(context, activeResume, user);
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
                  Icons.picture_as_pdf_outlined,
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
                  'Upload your resume to view a beautiful high-fidelity visual PDF template preview representation.',
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

  Widget _buildPreviewContent(BuildContext context, ResumeModel resume, dynamic user) {
    return Column(
      children: [
        // Template Selector Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const Text(
                'Template:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              ..._templates.map((template) {
                final isSelected = _selectedTemplate == template;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(template),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedTemplate = template;
                        });
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        
        // PDF Document Mock Card
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTemplateHeader(user),
                    const SizedBox(height: 20),
                    _buildTemplateBody(user, resume),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95)),
        ),
      ],
    );
  }

  Widget _buildTemplateHeader(dynamic user) {
    final name = user.displayName ?? 'Tushar';
    final email = user.email ?? 'hlotushar7@gmail.com';
    final phone = user.phoneNumber ?? '+1 (555) 019-2834';
    final location = user.location ?? 'San Francisco, CA';

    if (_selectedTemplate == 'Minimalist') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w300,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$email  |  $phone  |  $location',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.grey, thickness: 0.5),
        ],
      );
    }

    if (_selectedTemplate == 'Executive') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF1E3A8A), // Navy blue
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.experienceLevel != null ? '${user.experienceLevel} Software Engineer' : 'Senior Mobile Engineer',
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(email, style: const TextStyle(color: Colors.black54, fontSize: 10)),
              Text(phone, style: const TextStyle(color: Colors.black54, fontSize: 10)),
              Text(location, style: const TextStyle(color: Colors.black54, fontSize: 10)),
            ],
          ),
        ],
      );
    }

    // Default: Modern template
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0F172A), // Charcoal
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(phone, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Text(location, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateBody(dynamic user, ResumeModel resume) {
    final bio = user.bio ?? 'Experienced software engineer specializing in building high-performance cross-platform mobile applications with beautiful UI and maintainable architectures.';
    final skills = resume.skills.isNotEmpty ? resume.skills : const ['Flutter', 'Dart', 'Firebase', 'State Management', 'REST APIs'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Professional Summary
        _buildSectionHeader('Professional Summary'),
        const SizedBox(height: 8),
        Text(
          bio,
          style: const TextStyle(color: Colors.black87, fontSize: 12, height: 1.4),
        ),
        const SizedBox(height: 20),

        // Key Skills
        _buildSectionHeader('Technical Skills'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                skill,
                style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Work Experience
        _buildSectionHeader('Professional Experience'),
        const SizedBox(height: 8),
        _buildExperienceItem(
          company: 'Senior Software Engineer  |  TechCorp Inc.',
          period: '2023 - Present',
          points: [
            'Architected and deployed premium cross-platform apps using Flutter & Riverpod.',
            'Optimized scroll rendering performance resulting in a 40% memory usage reduction.',
            'Integrated Firebase Auth & Cloud Firestore to persist active user session states.',
          ],
        ),
        const SizedBox(height: 12),
        _buildExperienceItem(
          company: 'Mobile App Developer  |  AppWorks',
          period: '2021 - 2023',
          points: [
            'Built native Swift/SwiftUI features for core enterprise application.',
            'Refactored legacy state management flows reducing page transition load times by 200ms.',
          ],
        ),
        const SizedBox(height: 20),

        // Education
        _buildSectionHeader('Education'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'B.S. in Computer Science  |  State University',
              style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Text(
              'Graduated 2021',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    Color underlineColor = const Color(0xFF6366F1);
    if (_selectedTemplate == 'Executive') underlineColor = const Color(0xFF1E3A8A);
    if (_selectedTemplate == 'Minimalist') underlineColor = Colors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: _selectedTemplate == 'Executive' ? const Color(0xFF1E3A8A) : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: double.infinity,
          height: 1.5,
          color: underlineColor,
        ),
      ],
    );
  }

  Widget _buildExperienceItem({required String company, required String period, required List<String> points}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              company,
              style: const TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.bold),
            ),
            Text(
              period,
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...points.map((pt) {
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(color: Colors.black54, fontSize: 12)),
                Expanded(
                  child: Text(
                    pt,
                    style: const TextStyle(color: Colors.black87, fontSize: 11),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
