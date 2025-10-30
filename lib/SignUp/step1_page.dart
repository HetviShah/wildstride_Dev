import 'package:flutter/material.dart';
import 'sign_up_data.dart';
import 'signup_step_layout.dart';

class Step1Page extends StatefulWidget {
  final SignupData signupData;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const Step1Page({
    super.key,
    required this.signupData,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<Step1Page> createState() => _Step1PageState();
}

class _Step1PageState extends State<Step1Page> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _phoneController;

  String? _selectedCountryCode;
  String? _selectedGender;
  DateTime? _dob;

  final List<String> _genders = ["Male", "Female", "Other"];

  final List<Map<String, String>> _countryCodes = [
    {"code": "+1", "name": "US"},
    {"code": "+44", "name": "UK"},
    {"code": "+61", "name": "AU"},
    {"code": "+91", "name": "India"},
    {"code": "+81", "name": "Japan"},
    {"code": "+49", "name": "Germany"},
    {"code": "+33", "name": "France"},
  ];

  bool _isFormValid = false;
  bool _showDobError = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.signupData.firstName);
    _lastNameController = TextEditingController(text: widget.signupData.lastName);
    _emailController = TextEditingController(text: widget.signupData.email);
    _passwordController = TextEditingController(text: widget.signupData.password);
    _confirmPasswordController = TextEditingController(text: widget.signupData.password);
    _phoneController = TextEditingController(text: widget.signupData.phoneNumber);
    _selectedCountryCode = widget.signupData.countryCode;
    _selectedGender = widget.signupData.gender;
    _dob = widget.signupData.dob;

    _checkFormValidity(); // ✅ ensures Next is enabled when coming back
  }

  bool _validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#\$&*~]).{8,}$');
    return regex.hasMatch(password);
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _checkFormValidity();
      });
    }
  }

  void _checkFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isFormValid = isValid && _dob != null && _selectedGender != null && _selectedCountryCode != null);
  }

  void _saveAndNext() {
    final isValid = _formKey.currentState?.validate() ?? false;

    setState(() {
      _showDobError = true; // show DOB error only after trying to submit
    });

    if (isValid && _dob != null && _selectedGender != null && _selectedCountryCode != null) {
      widget.signupData
        ..firstName = _firstNameController.text.trim()
        ..lastName = _lastNameController.text.trim()
        ..email = _emailController.text.trim()
        ..password = _passwordController.text.trim()
        ..countryCode = _selectedCountryCode
        ..phoneNumber = _phoneController.text.trim()
        ..gender = _selectedGender
        ..dob = _dob;

      widget.onNext();
    } else {
      setState(() => _isFormValid = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupStepLayout(
      title: "Step 1 of 6",
      onBack: widget.onBack,
      onNext: _saveAndNext,
      nextLabel: "Continue",
      backLabel: "Back",
      isNextEnabled: _isFormValid,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.green[600],
              child: const Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "Let's Get Started",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            // First & Last Name
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("First name"),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter first name";
                      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                        return "Only letters allowed";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Last name"),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Enter last name";
                      if (!RegExp(r'^[a-zA-Z]+$').hasMatch(v)) {
                        return "Only letters allowed";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Email
            TextFormField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Email address", icon: Icons.email_outlined),
              validator: (v) {
                if (v == null || v.isEmpty) return "Enter email";
                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                  return "Enter a valid email";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            // Password
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Create password", icon: Icons.lock_outline),
              validator: (v) {
                if (v == null || v.isEmpty) return "Enter password";
                if (!_validatePassword(v)) {
                  return "Must be 8+ chars, include upper, lower & special char";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Confirm password", icon: Icons.lock_outline),
              validator: (v) {
                if (v != _passwordController.text) {
                  return "Passwords don't match";
                }
                return null;
              },
            ),
            const SizedBox(height: 15),

            // Phone (Code + Number)
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true, // ✅ prevents overflow
                    value: _selectedCountryCode,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Code"),
                    items: _countryCodes
                        .map((c) => DropdownMenuItem(
                      value: c["code"],
                      child: Text("${c["code"]} (${c["name"]})",
                          overflow: TextOverflow.ellipsis, // ✅ no overflow
                          style: const TextStyle(color: Colors.white)),
                    ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCountryCode = val;
                        _checkFormValidity();
                      });
                    },
                    validator: (val) => val == null ? "Select code" : null,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 4,
                  child: TextFormField(
                    controller: _phoneController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration("Phone number", icon: Icons.phone),
                    validator: (v) {
                      if (v != null && v.isNotEmpty) {
                        if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                          return "Must be 10 digits";
                        }
                      }
                      return null;
                    },
                    onChanged: (_) => _checkFormValidity(), // ✅ live validation
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Gender
            DropdownButtonFormField<String>(
              value: _selectedGender,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Gender"),
              items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedGender = val;
                  _checkFormValidity();
                });
              },
              validator: (val) => val == null ? "Select gender" : null,
            ),
            const SizedBox(height: 15),

            // DOB
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: _inputDecoration("Date of Birth", icon: Icons.calendar_today),
                child: Text(
                  _dob == null
                      ? "dd/mm/yyyy"
                      : "${_dob!.day}/${_dob!.month}/${_dob!.year}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            if (_dob == null && _showDobError)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Select your DOB",
                      style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}