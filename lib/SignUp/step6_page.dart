import 'package:flutter/material.dart';
import 'signup_step_layout.dart';
import 'sign_up_data.dart';
import 'onboardingScreen.dart';

class Step6Page extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onBack;
  final VoidCallback onFinish;

  const Step6Page({
    super.key,
    required this.signupData,
    required this.onBack,
    required this.onFinish,
  });

  @override
  State<Step6Page> createState() => _Step6PageState();
}

class _Step6PageState extends State<Step6Page> {
  bool _agreedToTerms = false;
  bool _subscribeUpdates = false;

  void _saveAndFinish() {
    if (!_agreedToTerms) return; // extra safety
    widget.signupData
      ..agreedToTerms = _agreedToTerms
      ..subscribeUpdates = _subscribeUpdates;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepLayout(
      title: "Step 6 of 6",
      onBack: widget.onBack,
      onNext: _saveAndFinish,
      nextLabel: "Create Account",
      backLabel: "Back",
      isNextEnabled: _agreedToTerms, // ✅ only enabled if terms checked
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: 6 / 6,
            backgroundColor: Colors.grey[800],
            color: Colors.green,
            minHeight: 6,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 30),

          // Green check icon
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green[600],
            child: const Icon(Icons.check, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Subtitle
          const Text(
            "Just agree to our terms and you're ready to explore",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 30),

          // Ready to Adventure card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green[600],
                  child: const Icon(Icons.terrain, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Ready to Adventure",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Join thousands of outdoor enthusiasts\n\n"
                            "Your profile is complete! You'll have access to personalized trail recommendations, "
                            "local adventure groups, and emergency safety features.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Terms of Service checkbox
          CheckboxListTile(
            value: _agreedToTerms,
            onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green,
            title: Wrap(
              children: const [
                Text("I agree to the ",
                    style: TextStyle(color: Colors.white)),
                Text("Terms of Service",
                    style: TextStyle(color: Colors.green)),
                Text(" and ",
                    style: TextStyle(color: Colors.white)),
                Text("Privacy Policy",
                    style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Updates subscription checkbox (optional)
          CheckboxListTile(
            value: _subscribeUpdates,
            onChanged: (val) =>
                setState(() => _subscribeUpdates = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.green,
            title: const Text(
              "I'd like to receive updates about new trails, events, and outdoor tips",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}