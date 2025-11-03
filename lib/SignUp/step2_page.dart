import 'package:flutter/material.dart';
import 'signup_step_layout.dart';
import 'sign_up_data.dart';

class Step2Page extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step2Page({
    super.key,
    required this.signupData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step2Page> createState() => _Step2PageState();
}

class _Step2PageState extends State<Step2Page> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCountry;
  final TextEditingController _cityController = TextEditingController();

  final List<String> _countries = [
    "United States",
    "India",
    "China",
    "Australia",
    "Germany",
    "United Kingdom",
    "Canada",
    "France",
    "Japan",
    "Brazil",
    "Mexico",
    "Other"
  ];

  void _saveAndNext() {
    if (_formKey.currentState!.validate()) {
      widget.signupData
        ..country = _selectedCountry
        ..city = _cityController.text.trim();

      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepLayout(
      title: "Step 2 of 6",
      onBack: widget.onBack,
      onNext: _saveAndNext,
      nextLabel: "Continue",
      backLabel: "Back",
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // 🔹 Progress bar
            LinearProgressIndicator(
              value: 2 / 6,
              backgroundColor: Colors.grey[800],
              color: Colors.green,
              minHeight: 6,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 30),

            // 🔹 Icon
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.orange[600],
              child: const Icon(Icons.location_on, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // 🔹 Subtitle
            const Text(
              "Help us find adventures near you",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 Country Dropdown (scrollable)
            DropdownButtonFormField<String>(
              value: _selectedCountry,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration:
              _inputDecoration("Select your country", icon: Icons.public),
              items: _countries
                  .map((c) => DropdownMenuItem(
                value: c,
                child: Text(c, overflow: TextOverflow.ellipsis),
              ))
                  .toList(),
              validator: (val) =>
              val == null || val.isEmpty ? "Please select a country" : null,
              onChanged: (val) => setState(() => _selectedCountry = val),
              menuMaxHeight: 250, // ✅ makes list scrollable if too many
            ),
            const SizedBox(height: 15),

            // 🔹 City Field
            TextFormField(
              controller: _cityController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Enter your city"),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter your city";
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
                  return "City must contain only letters";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // 🔹 Privacy Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🔒 Privacy Note",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your location helps us suggest nearby trails and connect you with local adventurers. "
                        "We never share your exact location without permission.",
                    style: TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}