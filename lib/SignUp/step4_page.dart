import 'package:flutter/material.dart';
import 'signup_step_layout.dart';
import 'sign_up_data.dart';

class Step4Page extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step4Page({
    super.key,
    required this.signupData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step4Page> createState() => _Step4PageState();
}

class _Step4PageState extends State<Step4Page> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  String? _relationship;
  String? _selectedCountryCode;

  final List<String> _countryCodes = [
    "+1 (USA)",
    "+44 (UK)",
    "+61 (Australia)",
    "+91 (India)",
    "+81 (Japan)",
    "+49 (Germany)",
    "+33 (France)",
    "+86 (China)",
    "+55 (Brazil)",
  ];

  final List<String> _relationships = [
    "Parent",
    "Sibling",
    "Spouse",
    "Friend",
    "Relative",
    "Other"
  ];

  void _saveAndNext() {
    if (_formKey.currentState!.validate()) {
      final fullPhone =
          "${_selectedCountryCode ?? ''} ${_contactPhoneController.text.trim()}";

      widget.signupData
        ..emergencyContactName = _contactNameController.text.trim()
        ..emergencyContactPhone = fullPhone.trim() // ✅ save full phone with code
        ..relationship = _relationship;

      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepLayout(
      title: "Step 4 of 6",
      onBack: widget.onBack,
      onNext: _saveAndNext,
      nextLabel: "Continue",
      backLabel: "Back",
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: 4 / 6,
              backgroundColor: Colors.grey[800],
              color: Colors.green,
              minHeight: 6,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 30),

            // Emergency Icon
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.red[600],
              child: const Icon(Icons.shield, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Subtitle
            const Text(
              "Phone number for emergency contact",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Emergency Contact Name
            TextFormField(
              controller: _contactNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Emergency contact name",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
              value!.isEmpty ? "Please enter a name" : null,
            ),
            const SizedBox(height: 16),

            // Emergency Contact Phone with country code selector
            Row(
              children: [
                // Country Code Dropdown
                Flexible(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: _selectedCountryCode,
                    isExpanded: true,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "+Code",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: _countryCodes
                        .map((code) => DropdownMenuItem(
                      value: code,
                      child: Text(
                        code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedCountryCode = val),
                    validator: (value) =>
                    value == null ? "Select code" : null,
                  ),
                ),
                const SizedBox(width: 10),

                // Phone number field
                Flexible(
                  flex: 7,
                  child: TextFormField(
                    controller: _contactPhoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Phone number",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Enter phone number";
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                        return "Must be 10 digits";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Relationship Dropdown
            DropdownButtonFormField<String>(
              value: _relationship,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Relationship",
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _relationships
                  .map((relation) => DropdownMenuItem(
                value: relation,
                child: Text(relation,
                    style: const TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _relationship = val),
              validator: (value) =>
              value == null ? "Please select a relationship" : null,
            ),
            const SizedBox(height: 20),

            // Safety Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "❤️ Safety is our priority",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "This contact will only be used in emergency situations during outdoor activities. We never share this information for other purposes.",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
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
}