import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
  final _notesController = TextEditingController(text: 'Round 1 technical discussion on Flutter architecture and state management.');

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
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF8B5CF6),
              surface: Color(0xFF121622),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _schedule() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Interview scheduled with ${widget.candidateName} for ${_selectedDate.day}/${_selectedDate.month} at $_selectedSlot!'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E17),
        elevation: 0,
        foregroundColor: const Color(0xFFF1F5F9),
        title: const Text('Schedule Interview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCandidateHeader(),
              const SizedBox(height: 20),
              _buildDateSelector(),
              const SizedBox(height: 20),
              _buildTimeSlots(),
              const SizedBox(height: 20),
              _buildInterviewTypeDetails(),
              const SizedBox(height: 28),
              _buildSubmitButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
              ),
            ),
            child: Center(
              child: Text(
                widget.candidateName.isNotEmpty ? widget.candidateName[0] : 'C',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.candidateName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFF1F5F9))),
                const SizedBox(height: 2),
                const Text('Software Engineer Applicant · Round 1', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Interview Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFF1F5F9))),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0E17),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF232A3B)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: Color(0xFF8B5CF6), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFF1F5F9)),
                  ),
                  const Spacer(),
                  const Text('Select Date', style: TextStyle(color: Color(0xFF38BDF8), fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Time Slots', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFF1F5F9))),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _timeSlots.map((slot) {
              final isSelected = _selectedSlot == slot;
              return InkWell(
                onTap: () => setState(() => _selectedSlot = slot),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF0A0E17),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF232A3B)),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInterviewTypeDetails() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF121622),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF232A3B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Interview Modality', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFF1F5F9))),
          const SizedBox(height: 12),
          Row(
            children: ['Video Call', 'In Person'].map((type) {
              final isSelected = _interviewType == type;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: InkWell(
                    onTap: () => setState(() => _interviewType = type),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF0A0E17),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? const Color(0xFF8B5CF6) : const Color(0xFF232A3B)),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Meeting Link / Address', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _meetingLinkController,
            style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 13),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.link_rounded, color: Color(0xFF8B5CF6), size: 18),
              filled: true,
              fillColor: const Color(0xFF0A0E17),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF232A3B))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF232A3B))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5)),
            ),
          ),
          const SizedBox(height: 14),
          const Text('Candidate Notes', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          TextFormField(
            controller: _notesController,
            maxLines: 2,
            style: const TextStyle(color: Color(0xFFF1F5F9), fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0A0E17),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF232A3B))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF232A3B))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF38BDF8)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: _schedule,
        child: const Text(
          'Confirm & Schedule Interview',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
