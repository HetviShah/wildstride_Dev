import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReportIssueScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String) onContinue;
  final String reportedUser;

  const ReportIssueScreen({
    super.key,
    required this.onBack,
    required this.onContinue,
    this.reportedUser = "Sarah Chen",
  });

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedIssue;

  final List<Map<String, dynamic>> issueTypes = [
    {
      'value': 'minor',
      'label': 'Minor Issue',
      'description': 'Rude behavior, no-show, ghosting',
      'icon': LucideIcons.alertCircle,
      'color': Color(0xFF1E90FF), // sky-blue
    },
    {
      'value': 'serious',
      'label': 'Serious Issue',
      'description': 'Harassment, unwanted contact, inappropriate behavior',
      'icon': LucideIcons.alertTriangle,
      'color': Color(0xFFFF8C00), // fox-orange
    },
    {
      'value': 'critical',
      'label': 'Critical Issue',
      'description': 'Assault, threats, severe harassment, safety concern',
      'icon': LucideIcons.alertOctagon,
      'color': Color(0xFFD22B2B), // lucky-red
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF003B2E)),
                    onPressed: widget.onBack,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Report an Issue",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Info Card
              _buildInfoCard(),

              const SizedBox(height: 24),

              // Issue Selection
              const Text(
                "What type of issue are you reporting?",
                style: TextStyle(
                  color: Color(0xFF003B2E),
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              Column(
                children: issueTypes.map((issue) => _buildIssueOption(issue)).toList(),
              ),

              const SizedBox(height: 20),

              // Critical Notice
              if (_selectedIssue == 'critical') _buildCriticalNotice(),

              const SizedBox(height: 24),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedIssue != null
                      ? () => widget.onContinue(_selectedIssue!)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E90FF), // sky-blue
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // False Report Warning
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8D9B5).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8D9B5)),
                ),
                child: const Text(
                  "False reports may result in trust score penalties. Report only genuine safety concerns.",
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E90FF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E90FF).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF1E90FF).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.alertCircle, color: Color(0xFF1E90FF)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're reporting: ${widget.reportedUser}",
                  style: const TextStyle(
                    color: Color(0xFF003B2E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Your report is confidential. We take all reports seriously and will review within 24–48 hours.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueOption(Map<String, dynamic> issue) {
    final bool isSelected = _selectedIssue == issue['value'];

    return GestureDetector(
      onTap: () => setState(() => _selectedIssue = issue['value']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? issue['color'].withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? issue['color']
                : Colors.grey.withOpacity(0.2),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: issue['color'].withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: issue['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(issue['icon'], color: issue['color'], size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        issue['label'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003B2E),
                          fontSize: 15,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E90FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.check, color: Colors.white, size: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    issue['description'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriticalNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD22B2B).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD22B2B).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(LucideIcons.alertOctagon, color: Color(0xFFD22B2B)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "For immediate danger, use the SOS button in the app header or contact emergency services.",
                  style: TextStyle(
                    color: Color(0xFF003B2E),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "This report will be prioritized and reviewed within 2–4 hours. We may contact you for additional information.",
                  style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}