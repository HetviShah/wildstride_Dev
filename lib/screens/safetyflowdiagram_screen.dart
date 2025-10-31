import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SafetyFlowDiagramScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SafetyFlowDiagramScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reportFlow = [
      {'step': 1, 'screen': 'Report Issue', 'icon': LucideIcons.flag, 'description': 'Select severity level'},
      {'step': 2, 'screen': 'Evidence Submission', 'icon': LucideIcons.fileText, 'description': 'Upload evidence & details'},
      {'step': 3, 'screen': 'Review in Progress', 'icon': LucideIcons.search, 'description': 'Safety team reviews'},
      {'step': 4, 'screen': 'Outcome', 'icon': LucideIcons.checkCircle2, 'description': 'Decision & appeal option'},
    ];

    final List<Map<String, dynamic>> verificationFlow = [
      {'step': 1, 'screen': 'Profile View', 'icon': LucideIcons.shield, 'description': 'View user profile'},
      {'step': 2, 'screen': 'Request Verification', 'icon': LucideIcons.shieldCheck, 'description': 'Send verification request'},
      {'step': 3, 'screen': 'Pending State', 'icon': LucideIcons.clock, 'description': '24-72 hours wait'},
      {'step': 4, 'screen': 'Verified / Declined', 'icon': LucideIcons.shieldCheck, 'description': 'Final status displayed'},
    ];

    final List<Map<String, dynamic>> moderatorFlow = [
      {'step': 1, 'screen': 'AI Detection', 'icon': LucideIcons.alertTriangle, 'description': 'False report flagged'},
      {'step': 2, 'screen': 'Evidence Analysis', 'icon': LucideIcons.eye, 'description': 'Review inconsistencies'},
      {'step': 3, 'screen': 'Moderator Decision', 'icon': LucideIcons.shield, 'description': 'Apply penalties if needed'},
      {'step': 4, 'screen': 'User Reinstatement', 'icon': LucideIcons.checkCircle2, 'description': 'Restore accused user'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF003B2E)),
          onPressed: onBack,
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Safety Flow Overview",
              style: TextStyle(
                color: Color(0xFF003B2E),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              "Connected screen workflows",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFlowSection(
                  title: "Report & Safety Flow",
                  color: const Color(0xFF1E90FF),
                  icon: LucideIcons.flag,
                  flowData: reportFlow,
                ),
                const SizedBox(height: 24),
                _buildFlowSection(
                  title: "Police Verification Flow",
                  color: const Color(0xFF003B2E),
                  icon: LucideIcons.shieldCheck,
                  flowData: verificationFlow,
                ),
                const SizedBox(height: 24),
                _buildFlowSection(
                  title: "Moderator Safeguards Flow",
                  color: const Color(0xFFFF8C00),
                  icon: LucideIcons.shield,
                  flowData: moderatorFlow,
                ),
                const SizedBox(height: 24),
                _buildKeyDesignCard(),
                const SizedBox(height: 24),
                _buildAllScreensList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowSection({
    required String title,
    required Color color,
    required IconData icon,
    required List<Map<String, dynamic>> flowData,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF003B2E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: flowData.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                bool isLast = index == flowData.length - 1;
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(color: color.withOpacity(0.3), width: 2),
                              ),
                              child: Icon(item['icon'], size: 20, color: color),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 40,
                                color: color.withOpacity(0.3),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: color.withOpacity(0.2)),
                                      ),
                                      child: Text(
                                        "Step ${item['step']}",
                                        style: TextStyle(fontSize: 11, color: color),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['screen'],
                                      style: const TextStyle(
                                        color: Color(0xFF003B2E),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['description'],
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isLast) const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyDesignCard() {
    return Card(
      color: const Color(0xFFF3EFE7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFD6CDBD)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Key Design Principles",
              style: TextStyle(
                color: Color(0xFF003B2E),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            _BulletPoint(
              title: "Calm Safety Colors",
              description: "Blue/green for trust, red only for critical alerts",
            ),
            _BulletPoint(
              title: "Instagram-style UI",
              description: "Rounded cards, vertical layouts, clean icons",
            ),
            _BulletPoint(
              title: "Progressive Disclosure",
              description: "Step-by-step flows with clear progress indicators",
            ),
            _BulletPoint(
              title: "Trust & Safety Balance",
              description: "Serious but not intimidating interface",
            ),
            _BulletPoint(
              title: "False Report Protection",
              description: "AI detection + moderator review safeguards",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllScreensList() {
    final List<Map<String, String>> screens = [
      {"title": "Safety Hub", "subtitle": "Central hub for all safety features"},
      {"title": "Report Issue Screen", "subtitle": "Select issue severity (Minor/Serious/Critical)"},
      {"title": "Evidence Submission Screen", "subtitle": "Upload evidence and describe incident"},
      {"title": "Report Review Screen", "subtitle": "Track review progress with timeline"},
      {"title": "Report Outcome Screen", "subtitle": "View decision and appeal option"},
      {"title": "Moderator Report Screen", "subtitle": "Review false complaint flags (Admin)"},
      {"title": "Verification Profile Screen", "subtitle": "Profile with police verification options"},
      {"title": "Safety Tips Screen", "subtitle": "Carousel of do's, don'ts & reporting info"},
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: screens
            .map(
              (screen) => Column(
            children: [
              ListTile(
                title: Text(
                  screen['title']!,
                  style: const TextStyle(
                    color: Color(0xFF003B2E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  screen['subtitle']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              if (screen != screens.last)
                Divider(
                  height: 0,
                  color: Colors.grey[300],
                ),
            ],
          ),
        )
            .toList(),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String title;
  final String description;

  const _BulletPoint({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 6, height: 6, margin: const EdgeInsets.only(top: 6), decoration: const BoxDecoration(color: Color(0xFF1E90FF), shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B2E),
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}