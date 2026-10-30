import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

/// Resume Workspace & Upload Screen matching Poster 1 Screen 7 & Poster 2 Screen 4:
/// - "My Resume" / "Upload Your Resume"
/// - Active Resume card: "Aman_Tyagi_Resume.pdf", 1.2 MB, uploaded 2 days ago
/// - Extracted Information checklist (Profile Summary, Skills, Projects, Education, Experience)
/// - AI Suggestions Card
/// - "Improve with AI" / "Tap to Upload Resume" action
class ResumeUploadScreen extends ConsumerStatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  ConsumerState<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends ConsumerState<ResumeUploadScreen> {
  bool _isUploading = false;
  String _resumeName = 'Aman_Tyagi_Resume.pdf';
  String _resumeSize = '1.2 MB';

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _isUploading = true;
        _resumeName = file.name;
        _resumeSize = '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB';
      });

      await Future.delayed(const Duration(milliseconds: 1200));
      setState(() => _isUploading = false);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Resume uploaded and parsed successfully!'),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        title: const Text(
          'My Resume',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: Color(0xFF8B5CF6)),
            onPressed: () => context.push('/resume/analysis'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Uploaded Resume Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF121622),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.35)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // PDF Icon Badge
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                      ),
                      child: const Center(
                        child: Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _resumeName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_resumeSize · Uploaded 2 days ago',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Upload New button
                    IconButton(
                      icon: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF38BDF8)),
                      onPressed: _pickFile,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Tap to Upload New Banner
              InkWell(
                onTap: _pickFile,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F131D),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF2A334A),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _isUploading ? Icons.hourglass_top_rounded : Icons.file_upload_outlined,
                        color: const Color(0xFF8B5CF6),
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isUploading ? 'Parsing Resume...' : 'Tap to Upload New Resume',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Supports PDF, DOC, DOCX up to 10MB',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Section: Extracted Information
              const Text(
                'Extracted Information',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              _buildInfoItem(Icons.badge_outlined, 'Profile Summary', 'Verified', const Color(0xFF10B981)),
              _buildInfoItem(Icons.code_rounded, 'Skills', '18 Detected', const Color(0xFF38BDF8)),
              _buildInfoItem(Icons.folder_special_outlined, 'Projects', '4 Projects', const Color(0xFF8B5CF6)),
              _buildInfoItem(Icons.school_outlined, 'Education', 'B.Tech CSE', const Color(0xFFF59E0B)),
              _buildInfoItem(Icons.work_history_outlined, 'Experience', '2+ Years', const Color(0xFF10B981)),

              const SizedBox(height: 24),

              // AI Suggestions Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E1B4B), Color(0xFF121622)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Color(0xFFFBBF24), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'AI Suggestions',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '• Quantify your impact at TCS with exact percentage metrics\n• Add Docker and Kubernetes to match 40% more backend roles\n• Reformat executive summary for optimal ATS parser indexing',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFCBD5E1),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // "Improve with AI" Button
                    Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => context.push('/ai/assistant'),
                          child: const Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bolt, color: Colors.white, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Improve with AI',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String status, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF8B5CF6), size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF64748B), size: 18),
        ],
      ),
    );
  }
}
