import 'package:flutter/material.dart';
import 'signup_step_layout.dart';
import 'sign_up_data.dart';

class Step5Page extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step5Page({
    super.key,
    required this.signupData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step5Page> createState() => _Step5PageState();
}

class _Step5PageState extends State<Step5Page> {
  final TextEditingController _bioController = TextEditingController();
  String? _uploadedFile;

  void _saveAndNext() {
    if (_bioController.text.trim().length < 20) {
      return; // still blocked, but button disabled handles most cases
    }
    widget.signupData
      ..bio = _bioController.text.trim()
      ..profileFile = _uploadedFile;
    widget.onNext();
  }

  void _pickFile() async {
    setState(() {
      _uploadedFile = "example_file.png"; // simulate file upload
    });
  }

  @override
  Widget build(BuildContext context) {
    final bioLength = _bioController.text.trim().length;
    final bool isTooShort = bioLength > 0 && bioLength < 20;
    final bool isNextEnabled = bioLength >= 20;

    return SignupStepLayout(
      title: "Step 5 of 6",
      onBack: widget.onBack,
      onNext: _saveAndNext,
      nextLabel: "Continue",
      backLabel: "Back",
      isNextEnabled: isNextEnabled, // 👈 control button state
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: 5 / 6,
            backgroundColor: Colors.green.withOpacity(isNextEnabled ? 1.0 : 0.4),
            color: Colors.green,
            minHeight: 6,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 30),

          // Icon
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.purple[600],
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Subtitle
          const Text(
            "Tell us about yourself and your adventure goals",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // Character counter
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "(${bioLength}/500)",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          const SizedBox(height: 6),

          // Bio input
          TextField(
            controller: _bioController,
            maxLines: 6,
            maxLength: 500,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText:
              "Share your outdoor experience, favorite adventures, or what you're hoping to discover...",
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              counterStyle: const TextStyle(color: Colors.white70),
            ),
            onChanged: (_) => setState(() {}),
          ),

          // Inline validation message
          if (isTooShort)
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Your bio must be at least 20 characters",
                style: TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),

          const SizedBox(height: 20),

          // Optional upload label
          const Text(
            "(Optional)",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),

          // File upload box
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[700]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: _uploadedFile == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload, color: Colors.white70, size: 36),
                    SizedBox(height: 8),
                    Text(
                      "Upload a file or photo",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 36),
                    const SizedBox(height: 8),
                    Text(
                      _uploadedFile!,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
