import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PoliceVerificationScreen extends StatefulWidget {
  const PoliceVerificationScreen({super.key});

  @override
  State<PoliceVerificationScreen> createState() =>
      _PoliceVerificationScreenState();
}

class _PoliceVerificationScreenState extends State<PoliceVerificationScreen> {
  String verificationStatus = 'not-verified'; // verified | pending | declined

  final userProfile = {
    "name": "Sarah Chen",
    "age": 28,
    "location": "San Francisco, CA",
    "trustScore": 850,
    "completedTrips": 24,
    "badges": 8,
  };

  void _sendVerificationRequest() {
    setState(() => verificationStatus = 'pending');
    Navigator.pop(context);
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1E90FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.shield, color: Color(0xFF1E90FF)),
            ),
            const SizedBox(height: 12),
            const Text("Request Police Verification?",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          "This will send a verification request to ${userProfile["name"]}. "
              "They can accept or decline. The process takes 24–72 hours.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: _sendVerificationRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E90FF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Yes, Send Request"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  Widget _verificationBadge() {
    switch (verificationStatus) {
      case 'verified':
        return _buildBadge(LucideIcons.shieldCheck, const Color(0xFF1E90FF),
            'Police Verified');
      case 'pending':
        return _buildBadge(
            LucideIcons.clock, const Color(0xFFFF8C00), 'Verification Pending');
      default:
        return _buildBadge(LucideIcons.shield, Colors.grey, 'Not Verified');
    }
  }

  Widget _buildBadge(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(IconData icon, Color color, String title, String message) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(message,
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 13)),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureTile(IconData icon, String title, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF003B2E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem("${userProfile["completedTrips"]}", "Trips"),
            _statItem("${userProfile["badges"]}", "Badges"),
            _statItem("${userProfile["trustScore"]}", "Trust Score"),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF003B2E),
                fontSize: 16)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Profile",
          style: TextStyle(
              color: Color(0xFF003B2E), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF003B2E)),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ✅ Responsive layout for mobile + web
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Profile Card ---
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 1,
                      shadowColor: Colors.black12,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor:
                              const Color(0xFF1E90FF).withOpacity(0.1),
                              child: const Icon(Icons.person,
                                  size: 50, color: Color(0xFF1E90FF)),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "${userProfile["name"]}, ${userProfile["age"]}",
                              style: const TextStyle(
                                  color: Color(0xFF003B2E),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text("${userProfile["location"]}",
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 13)),
                            const SizedBox(height: 10),
                            _verificationBadge(),
                            const SizedBox(height: 16),

                            // --- Trust Score ---
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Trust Score",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13)),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: (userProfile["trustScore"] as int) /
                                      1000.0,
                                  minHeight: 6,
                                  color: const Color(0xFF1E90FF),
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${userProfile["trustScore"]}/1000",
                                    style: const TextStyle(
                                        color: Color(0xFF1E90FF),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- Verification Status Cards ---
                    if (verificationStatus == 'pending')
                      _statusCard(
                          LucideIcons.clock,
                          const Color(0xFFFFA500),
                          "Verification in Progress",
                          "Police verification request submitted. Takes 24–72 hours."),
                    if (verificationStatus == 'verified')
                      _statusCard(
                          LucideIcons.shieldCheck,
                          const Color(0xFF1E90FF),
                          "Police Verified",
                          "Verified on ${DateTime.now().toLocal().toString().split(' ')[0]}."),
                    const SizedBox(height: 20),

                    // --- Buttons ---
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon:
                            const Icon(LucideIcons.messageCircle, size: 18),
                            label: const Text("Chat"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF003B2E),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(LucideIcons.phone, size: 18),
                            label: const Text("Call"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF003B2E),
                              side:
                              const BorderSide(color: Color(0xFF003B2E)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.userPlus, size: 18),
                      label: const Text("Add to Trip"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD22B2B),
                        side: const BorderSide(color: Color(0xFFD22B2B)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (verificationStatus == 'not-verified')
                      ElevatedButton.icon(
                        onPressed: _showVerificationDialog,
                        icon: const Icon(LucideIcons.shield, size: 18),
                        label: const Text("Request Police Verification"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E90FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),

                    const SizedBox(height: 24),

                    // --- SAFETY FEATURES GRID ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Safety Features",
                          style: TextStyle(
                              color: const Color(0xFF003B2E),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 12),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.2,
                      children: [
                        _featureTile(LucideIcons.flag, "Report Issue",
                            const Color(0xFF1E90FF)),
                        _featureTile(LucideIcons.alertTriangle, "SOS Alert",
                            const Color(0xFFD22B2B)),
                        _featureTile(
                            LucideIcons.userX, "Block User", Colors.grey),
                        _featureTile(LucideIcons.shield, "Verification",
                            const Color(0xFF1E90FF)),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _buildStatsCard(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}