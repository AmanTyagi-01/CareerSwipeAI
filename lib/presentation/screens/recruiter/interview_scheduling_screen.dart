import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/app_theme.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';

class InterviewSchedulingScreen extends StatefulWidget {
  final String candidateName;
  const InterviewSchedulingScreen({super.key, required this.candidateName});

  @override
  State<InterviewSchedulingScreen> createState() => _InterviewSchedulingScreenState();
}

class _InterviewSchedulingScreenState extends State<InterviewSchedulingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '10:00 AM';
  String _interviewType = 'Video Call';
  final _meetingLinkController = TextEditingController(text: 'https://meet.google.com/csw-interviews-ai');
  final _notesController = TextEditingController(text: 'Technical discussion on Flutter architecture and AI pipelines.');

  final List<String> _timeSlots = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  void dispose() {
    _meetingLinkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _schedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Interview scheduled with ${widget.candidateName} for ${_selectedDate.day}/${_selectedDate.month} at $_selectedSlot!'),
        backgroundColor: AppColors.darkSuccess,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Interview', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Candidate Pill
              GlassCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.darkPrimary.withValues(alpha: 0.2),
                      child: Text(
                        widget.candidateName.isNotEmpty ? widget.candidateName[0] : 'C',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkPrimary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.candidateName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(
                          'Candidate Interviewee',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Date Picker Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: AppSpacing.sm),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month_rounded, color: AppColors.darkPrimary),
                      title: Text(
                        '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      trailing: TextButton(
                        onPressed: _pickDate,
                        child: const Text('Change Date'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Time Slots Card
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Time Slots', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _timeSlots.map((slot) {
                        final isSelected = _selectedSlot == slot;
                        return ChoiceChip(
                          label: Text(slot),
                          selected: isSelected,
                          selectedColor: AppColors.darkPrimary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedSlot = slot);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Interview Details
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Interview Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Video Call', label: Text('Video Call'), icon: Icon(Icons.videocam_outlined)),
                        ButtonSegment(value: 'In Person', label: Text('In Person'), icon: Icon(Icons.location_on_outlined)),
                      ],
                      selected: {_interviewType},
                      onSelectionChanged: (set) => setState(() => _interviewType = set.first),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _meetingLinkController,
                      decoration: const InputDecoration(
                        labelText: 'Meeting Link or Location',
                        prefixIcon: Icon(Icons.link_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Preparation Notes for Candidate',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _schedule,
                  child: const Text('Schedule Interview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

