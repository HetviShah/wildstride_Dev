import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';


class ReportReviewScreen extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onViewOutcome;

  const ReportReviewScreen({
    super.key,
    this.onBack,
    this.onViewOutcome,
  });

  @override
  Widget build(BuildContext context) {
    final String reportId =
        "WS-${DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase()}";
    final String submittedDate =
        "${DateTime.now().day} ${_monthName(DateTime.now().month)} ${DateTime.now().year}";
    final DateTime estimatedCompletion =
    DateTime.now().add(const Duration(hours: 48));

    final List<Map<String, dynamic>> timeline = [
      {
        'status': 'completed',
        'label': 'Report Submitted',
        'description': submittedDate,
        'icon': LucideIcons.checkCircle2,
        'color': const Color(0xFF1E90FF), // sky-blue
      },
      {
        'status': 'completed',
        'label': 'Evidence Collected',
        'description': 'All materials received',
        'icon': LucideIcons.fileCheck,
        'color': const Color(0xFF1E90FF),
      },
      {
        'status': 'active',
        'label': 'Under Review',
        'description': 'Safety team investigating',
        'icon': LucideIcons.search,
        'color': const Color(0xFFFF8C00), // fox-orange
      },
      {
        'status': 'pending',
        'label': 'Resolution',
        'description':
        'Expected by ${estimatedCompletion.day} ${_monthName(estimatedCompletion.month)}',
        'icon': LucideIcons.clock,
        'color': Colors.grey,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Header
            Container(
              color: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft,
                        color: Color(0xFF003B2E)),
                    onPressed: onBack,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Report Status",
                          style: TextStyle(
                              color: Color(0xFF003B2E),
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(
                          "Case #$reportId",
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // ✅ Scroll Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Status Card ---
                    _statusCard(),

                    const SizedBox(height: 20),

                    // --- Timeline ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Review Timeline",
                        style: TextStyle(
                          color: const Color(0xFF003B2E),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            for (int i = 0; i < timeline.length; i++)
                              _timelineStep(
                                  step: timeline[i],
                                  isLast: i == timeline.length - 1)
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Estimated Review Time ---
                    _infoCard(
                      icon: LucideIcons.clock,
                      title: "Estimated Review Time: 24–48 hours",
                      message:
                      "You'll receive a notification when the review is complete. Critical issues are prioritized and reviewed within 2–4 hours.",
                      color: const Color(0xFFFF8C00),
                    ),

                    const SizedBox(height: 20),

                    // --- What Happens Next ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "What Happens Next?",
                        style: TextStyle(
                          color: const Color(0xFF003B2E),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _nextStepsCard(),

                    const SizedBox(height: 20),

                    // --- Support Section ---
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              "Need immediate assistance or have questions?",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(LucideIcons.mail,
                                  size: 18, color: Color(0xFF1E90FF)),
                              label: const Text("Contact Safety Team"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1E90FF),
                                side: const BorderSide(
                                    color: Color(0xFF1E90FF), width: 1.3),
                                minimumSize:
                                const Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- STATUS CARD ---
  Widget _statusCard() {
    return Card(
      elevation: 0,
      color: const Color(0xFFE8F4FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.search,
                  color: Color(0xFF1E90FF), size: 36),
            ),
            const SizedBox(height: 12),
            const Text(
              "Review in Progress",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B2E)),
            ),
            const SizedBox(height: 4),
            const Text(
              "Our safety team is carefully reviewing your report",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Progress",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("60%",
                    style: TextStyle(color: Color(0xFF1E90FF), fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.6,
                color: const Color(0xFF1E90FF),
                backgroundColor: Colors.white,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- TIMELINE STEP ---
  Widget _timelineStep({required Map step, required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon + line
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (step['status'] == 'completed')
                    ? (step['color'] as Color).withOpacity(0.2)
                    : (step['status'] == 'active')
                    ? (step['color'] as Color).withOpacity(0.2)
                    : Colors.grey.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(step['icon'] as IconData,
                  size: 20, color: step['color'] as Color),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 40,
                color: (step['status'] == 'completed')
                    ? (step['color'] as Color).withOpacity(0.3)
                    : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        // Label + desc
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(step['label'],
                        style: const TextStyle(
                            color: Color(0xFF003B2E),
                            fontWeight: FontWeight.w600)),
                    if (step['status'] == 'active') ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF8C00).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Color(0xFFFF8C00).withOpacity(0.3)),
                        ),
                        child: const Text("In Progress",
                            style: TextStyle(
                                color: Color(0xFFFF8C00), fontSize: 10)),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(step['description'],
                    style:
                    const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- INFO CARD ---
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Card(
      color: color.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Color(0xFF003B2E),
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(message,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12, height: 1.4)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  // --- NEXT STEPS ---
  Widget _nextStepsCard() {
    final List<String> steps = [
      "Our safety team reviews all evidence and may contact both parties for clarification",
      "A decision is made based on community guidelines and evidence provided",
      "You'll be notified of the outcome and can appeal if needed"
    ];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: List.generate(steps.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1E90FF).withOpacity(0.15),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            color: Color(0xFF1E90FF), fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(steps[index],
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12, height: 1.4)),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  String _monthName(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[m - 1];
  }
}