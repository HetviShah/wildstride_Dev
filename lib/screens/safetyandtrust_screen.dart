import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'safetytips_screen.dart';
import 'report_an_issue_screen.dart';
import 'police_verification_screen.dart';

class SafetyTrustScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const SafetyTrustScreen({super.key, this.onBack});

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
              // Header Row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF003B2E)),
                    onPressed: onBack ?? () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Safety & Trust",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003B2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                "Keep your travels safe",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Trust Score Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF2E8B57).withAlpha(26)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.verified_user, color: Color(0xFF2E8B57), size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Your Trust Score",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E8B57),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "850 ",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003B2E),
                                ),
                              ),
                              TextSpan(
                                text: "/ 1000 points",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(
                            "High",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E8B57),
                            ),
                          ),
                          //backgroundColor: Color(0xFF2E8B57).withOpacity(0.1);
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.map, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("24 trips", style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 12),
                        Icon(Icons.verified, size: 16, color: Colors.blue),
                        SizedBox(width: 4),
                        Text("Verified", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Emergency SOS Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent.withAlpha(51)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Emergency SOS",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "In immediate danger? Use the SOS button in the app header to alert emergency contacts and authorities.",
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              "Learn how SOS works →",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Section Title
              const Text(
                "Safety Features",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B2E),
                ),
              ),
              const SizedBox(height: 16),

              // Safety Feature Buttons
              _buildFeatureCard(
                context,
                title: "Report an Issue",
                subtitle: "Report unsafe behavior or violations",
                icon: Icons.flag_outlined,
                iconColor: const Color(0xFF2E8B57),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportIssueScreen(
                        onBack: () => Navigator.pop(context),
                        onContinue: (String issue) {
                          // TODO: Handle continue logic
                        },
                      ),
                    ),
                  );
                },
              ),
              _buildFeatureCard(
                context,
                title: "Safety Guidelines",
                subtitle: "Learn safety do's and don'ts",
                icon: Icons.article_outlined,
                iconColor: const Color(0xFFFF8C00),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SafetyTipsScreen(
                        onBack: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
              ),
              _buildFeatureCard(
                context,
                title: "Police Verification",
                subtitle: "Request or view verification status",
                icon: Icons.verified_user_outlined,
                iconColor: const Color(0xFF1E90FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PoliceVerificationScreen(),
                    ),
                  );
                },
              ),
              _buildFeatureCard(
                context,
                title: "My Reports",
                subtitle: "Track your submitted reports",
                icon: Icons.remove_red_eye_outlined,
                iconColor: const Color(0xFFFFA500),
              ),
              const SizedBox(height: 32),

              // Community Safety Section
              const Text(
                "Community Safety",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B2E),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard("99.2%", "Safe Trips", Colors.lightBlue.shade50,
                        const Color(0xFF2E8B57)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard("24hrs", "Report Review", Colors.green.shade50,
                        const Color(0xFF003B2E)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard("15K+", "Verified Users", Colors.orange.shade50,
                        const Color(0xFFFF8C00)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricCard("4.8/5", "Safety Rating", Colors.yellow.shade50,
                        const Color(0xFFFFC107)),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Safety Commitment
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withAlpha(51)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Our Safety Commitment",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003B2E),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Wildstride is committed to providing a safe travel community. We employ AI-powered monitoring, 24/7 safety team support, and comprehensive verification systems to protect our users.",
                      style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "📘 Read our Safety Policy →",
                        style: TextStyle(
                          color: Color(0xFF1E90FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // View Flow Diagram
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withAlpha(102), style: BorderStyle.solid),
                  ),
                  child: const Center(
                    child: Text(
                      "👁️ View Safety Flow Diagram",
                      style: TextStyle(
                        color: Color(0xFF003B2E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color iconColor,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: iconColor.withAlpha(38)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: iconColor),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String value, String label, Color bg, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
