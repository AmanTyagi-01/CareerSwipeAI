import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/resume_provider.dart';
import '../../../presentation/widgets/common/animated_background.dart';
import '../../../presentation/widgets/common/custom_buttons.dart';
import '../../../presentation/widgets/common/glass_card.dart';
import '../../../presentation/widgets/common/loading_indicator.dart';

class ResumeUploadScreen extends ConsumerStatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  ConsumerState<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends ConsumerState<ResumeUploadScreen> {
  bool _isUploading = false;
  bool _isAnalyzing = false;
  double _uploadProgress = 0;

  Future<void> _pickAndUploadFile() async {
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;

      if (file.size > AppConstants.maxResumeSize) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File size exceeds 10MB limit'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      setState(() => _isUploading = true);

      // Simulate upload progress
      for (int i = 0; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() => _uploadProgress = i / 10);
      }

      final resumeNotifier = ref.read(resumeNotifierProvider.notifier);
      final resume = await resumeNotifier.uploadResume(user.id, file);

      setState(() {
        _isUploading = false;
        _isAnalyzing = true;
        _uploadProgress = 0;
      });

      // Analyze resume
      final analysis = await resumeNotifier.analyzeResume(resume);

      setState(() => _isAnalyzing = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resume analyzed successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );

      context.push('/resume/analysis', extra: analysis.id);
    } catch (e) {
      setState(() {
        _isUploading = false;
        _isAnalyzing = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show resume history
            },
          ),
        ],
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Your Resume',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
                    .animate()
                    .fadeIn()
                    .slideY(begin: -0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Get AI-powered analysis and optimization insights',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: const Duration(milliseconds: 100)),
                const SizedBox(height: 32),

                if (_isUploading)
                  _buildUploadProgress(context, isDark)
                else if (_isAnalyzing)
                  _buildAnalysisProgress(context, isDark)
                else
                  _buildUploadArea(context, isDark),

                const SizedBox(height: 32),
                _buildSupportedFormats(context, isDark),
                const SizedBox(height: 32),
                _buildPreviousAnalyses(context, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadArea(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: _pickAndUploadFile,
      child: GlassCard(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withValues(alpha: 0.2),
                      AppTheme.accentColor.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  size: 40,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tap to Upload Resume',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PDF, DOC, or DOCX (max 10MB)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Select File',
                onPressed: _pickAndUploadFile,
                width: 200,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 200))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildUploadProgress(BuildContext context, bool isDark) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            const AppLoadingIndicator(size: 64, message: 'Uploading resume...'),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: isDark ? AppTheme.darkElevated : AppTheme.lightElevated,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${(_uploadProgress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisProgress(BuildContext context, bool isDark) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.2),
                    AppTheme.accentColor.withValues(alpha: 0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const AppLoadingIndicator(size: 40),
            ),
            const SizedBox(height: 24),
            Text(
              'AI Analysis in Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Analyzing ATS compatibility, keywords, and formatting...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildAnalysisStep(context, 'Extracting text', true, isDark),
            const SizedBox(height: 8),
            _buildAnalysisStep(context, 'Analyzing keywords', true, isDark),
            const SizedBox(height: 8),
            _buildAnalysisStep(context, 'Checking ATS compatibility', false, isDark),
            const SizedBox(height: 8),
            _buildAnalysisStep(context, 'Generating insights', false, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisStep(BuildContext context, String label, bool completed, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: completed ? AppTheme.successColor : (isDark ? AppTheme.darkTextTertiary : AppTheme.lightTextTertiary),
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: completed
                ? AppTheme.successColor
                : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
            fontWeight: completed ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSupportedFormats(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supported Formats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildFormatChip(context, 'PDF', Icons.picture_as_pdf, Colors.red, isDark),
              const SizedBox(width: 12),
              _buildFormatChip(context, 'DOC', Icons.description, Colors.blue, isDark),
              const SizedBox(width: 12),
              _buildFormatChip(context, 'DOCX', Icons.description, Colors.blueAccent, isDark),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Tips for best results:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildTip(context, 'Use standard fonts (Arial, Calibri, Times New Roman)'),
          _buildTip(context, 'Avoid tables, images, and complex formatting'),
          _buildTip(context, 'Include relevant keywords from job descriptions'),
          _buildTip(context, 'Keep file size under 10MB'),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 300))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildFormatChip(BuildContext context, String label, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(BuildContext context, String tip) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check, color: AppTheme.successColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousAnalyses(BuildContext context, bool isDark) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Previous Analyses',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildAnalysisItem(
            context,
            fileName: 'resume_v3.pdf',
            score: 82,
            date: '2 days ago',
            isDark: isDark,
          ),
          Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
          _buildAnalysisItem(
            context,
            fileName: 'resume_v2.pdf',
            score: 74,
            date: '1 week ago',
            isDark: isDark,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildAnalysisItem(BuildContext context, {
    required String fileName,
    required int score,
    required String date,
    required bool isDark,
  }) {
    final color = AppConstants.getScoreColor(score.toDouble());

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.description, color: color),
      ),
      title: Text(
        fileName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        date,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$score',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      onTap: () => context.push('/resume/analysis'),
    );
  }
}
