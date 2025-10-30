import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// Validation functions
class ValidationResult {
  final bool isValid;
  final String? message;

  ValidationResult({required this.isValid, this.message});
}

ValidationResult validateEmail(String email) {
  if (email.isEmpty) {
    return ValidationResult(isValid: false, message: 'Email is required');
  }
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(email)) {
    return ValidationResult(isValid: false, message: 'Please enter a valid email');
  }
  return ValidationResult(isValid: true);
}

ValidationResult validatePassword(String password) {
  if (password.isEmpty) {
    return ValidationResult(isValid: false, message: 'Password is required');
  }
  if (password.length < 8) {
    return ValidationResult(isValid: false, message: 'Password must be at least 8 characters');
  }
  return ValidationResult(isValid: true);
}

ValidationResult validatePasswordMatch(String password, String confirmPassword) {
  if (confirmPassword.isEmpty) {
    return ValidationResult(isValid: false, message: 'Please confirm your password');
  }
  if (password != confirmPassword) {
    return ValidationResult(isValid: false, message: 'Passwords do not match');
  }
  return ValidationResult(isValid: true);
}

ValidationResult validateName(String name) {
  if (name.isEmpty) {
    return ValidationResult(isValid: false, message: 'This field is required');
  }
  if (name.length < 2) {
    return ValidationResult(isValid: false, message: 'Name must be at least 2 characters');
  }
  return ValidationResult(isValid: true);
}

ValidationResult validatePhone(String phone) {
  if (phone.isNotEmpty) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(phone)) {
      return ValidationResult(isValid: false, message: 'Please enter a valid phone number');
    }
  }
  return ValidationResult(isValid: true);
}

ValidationResult validateBio(String bio) {
  if (bio.length < 20) {
    return ValidationResult(isValid: false, message: 'Bio must be at least 20 characters');
  }
  return ValidationResult(isValid: true);
}

ValidationResult validateInterests(List<String> interests) {
  if (interests.length < 3) {
    return ValidationResult(isValid: false, message: 'Please select at least 3 interests');
  }
  return ValidationResult(isValid: true);
}

ValidationResult validateRequired(String value, String fieldName) {
  if (value.isEmpty) {
    return ValidationResult(isValid: false, message: '$fieldName is required');
  }
  return ValidationResult(isValid: true);
}

// Data models
class SignupData {
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmPassword;
  String phone;
  String dateOfBirth;
  String gender;
  String country;
  String city;
  String experienceLevel;
  List<String> interests;
  String bio;
  String emergencyName;
  String emergencyPhone;
  String emergencyRelationship;
  bool agreeToTerms;
  String? profilePicture;

  SignupData({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.phone = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.country = '',
    this.city = '',
    this.experienceLevel = '',
    this.interests = const [],
    this.bio = '',
    this.emergencyName = '',
    this.emergencyPhone = '',
    this.emergencyRelationship = '',
    this.agreeToTerms = false,
    this.profilePicture,
  });

  SignupData copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? confirmPassword,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? country,
    String? city,
    String? experienceLevel,
    List<String>? interests,
    String? bio,
    String? emergencyName,
    String? emergencyPhone,
    String? emergencyRelationship,
    bool? agreeToTerms,
    String? profilePicture,
  }) {
    return SignupData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      interests: interests ?? this.interests,
      bio: bio ?? this.bio,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      emergencyRelationship: emergencyRelationship ?? this.emergencyRelationship,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}

class AdventureInterest {
  final String id;
  final IconData icon;
  final String name;
  final Color color;

  AdventureInterest({
    required this.id,
    required this.icon,
    required this.name,
    required this.color,
  });
}

class Country {
  final String value;
  final String label;

  Country({required this.value, required this.label});
}

// Main Widget
class DetailedSignupScreen extends StatefulWidget {
  final VoidCallback onSignupComplete;
  final VoidCallback onBackToLogin;

  const DetailedSignupScreen({
    Key? key,
    required this.onSignupComplete,
    required this.onBackToLogin,
  }) : super(key: key);

  @override
  _DetailedSignupScreenState createState() => _DetailedSignupScreenState();
}

class _DetailedSignupScreenState extends State<DetailedSignupScreen> {
  static const int TOTAL_STEPS = 6;
  
  int _currentStep = 1;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isSubmitting = false;
  bool _showSuccess = false;
  
  final Map<String, String> _errors = {};
  SignupData _formData = SignupData();

  final List<Country> _countries = [
    Country(value: 'US', label: 'United States'),
    Country(value: 'CA', label: 'Canada'),
    Country(value: 'GB', label: 'United Kingdom'),
    Country(value: 'AU', label: 'Australia'),
    Country(value: 'DE', label: 'Germany'),
    Country(value: 'FR', label: 'France'),
    Country(value: 'IN', label: 'India'),
    Country(value: 'JP', label: 'Japan'),
    Country(value: 'BR', label: 'Brazil'),
    Country(value: 'MX', label: 'Mexico'),
  ];

  final List<AdventureInterest> _adventureInterests = [
    AdventureInterest(
      id: 'hiking',
      icon: Icons.landscape,
      name: 'Hiking',
      color: Colors.green,
    ),
    AdventureInterest(
      id: 'camping',
      icon: Icons.cabin,
      name: 'Camping',
      color: Colors.orange,
    ),
    AdventureInterest(
      id: 'rockClimbing',
      icon: Icons.rocket_launch,
      name: 'Rock Climbing',
      color: Colors.red,
    ),
    AdventureInterest(
      id: 'mountaineering',
      icon: Icons.forest,
      name: 'Mountaineering',
      color: Colors.purple,
    ),
    AdventureInterest(
      id: 'backpacking',
      icon: Icons.group,
      name: 'Backpacking',
      color: Colors.blue,
    ),
    AdventureInterest(
      id: 'photography',
      icon: Icons.camera_alt,
      name: 'Photography',
      color: Colors.pink,
    ),
    AdventureInterest(
      id: 'wildlife',
      icon: Icons.favorite,
      name: 'Wildlife Watching',
      color: Colors.teal,
    ),
    AdventureInterest(
      id: 'cycling',
      icon: Icons.pedal_bike,
      name: 'Cycling',
      color: Colors.yellow,
    ),
    AdventureInterest(
      id: 'kayaking',
      icon: Icons.waves,
      name: 'Kayaking',
      color: Colors.cyan,
    ),
    AdventureInterest(
      id: 'skiing',
      icon: Icons.ac_unit,
      name: 'Skiing',
      color: Colors.indigo,
    ),
  ];

  void _updateFormData(SignupData updates) {
    setState(() {
      _formData = _formData.copyWith(
        firstName: updates.firstName,
        lastName: updates.lastName,
        email: updates.email,
        password: updates.password,
        confirmPassword: updates.confirmPassword,
        phone: updates.phone,
        dateOfBirth: updates.dateOfBirth,
        gender: updates.gender,
        country: updates.country,
        city: updates.city,
        experienceLevel: updates.experienceLevel,
        interests: updates.interests,
        bio: updates.bio,
        emergencyName: updates.emergencyName,
        emergencyPhone: updates.emergencyPhone,
        emergencyRelationship: updates.emergencyRelationship,
        agreeToTerms: updates.agreeToTerms,
        profilePicture: updates.profilePicture,
      );
      
      // Clear errors for updated fields
      updates.toJson().forEach((key, value) {
        if (_errors.containsKey(key)) {
          _errors.remove(key);
        }
      });
    });
  }

  void _toggleInterest(String interestId) {
    setState(() {
      if (_formData.interests.contains(interestId)) {
        _formData = _formData.copyWith(
          interests: List.from(_formData.interests)..remove(interestId),
        );
      } else {
        _formData = _formData.copyWith(
          interests: List.from(_formData.interests)..add(interestId),
        );
      }
    });
  }

  bool _validateCurrentStep() {
    final newErrors = <String, String>{};
    
    switch (_currentStep) {
      case 1:
        final firstNameValidation = validateName(_formData.firstName);
        if (!firstNameValidation.isValid) newErrors['firstName'] = firstNameValidation.message!;
        
        final lastNameValidation = validateName(_formData.lastName);
        if (!lastNameValidation.isValid) newErrors['lastName'] = lastNameValidation.message!;
        
        final emailValidation = validateEmail(_formData.email);
        if (!emailValidation.isValid) newErrors['email'] = emailValidation.message!;
        
        final passwordValidation = validatePassword(_formData.password);
        if (!passwordValidation.isValid) newErrors['password'] = passwordValidation.message!;
        
        final passwordMatchValidation = validatePasswordMatch(_formData.password, _formData.confirmPassword);
        if (!passwordMatchValidation.isValid) newErrors['confirmPassword'] = passwordMatchValidation.message!;
        
        final phoneValidation = validatePhone(_formData.phone);
        if (!phoneValidation.isValid) newErrors['phone'] = phoneValidation.message!;
        break;
        
      case 2:
        final countryValidation = validateRequired(_formData.country, 'Country');
        if (!countryValidation.isValid) newErrors['country'] = countryValidation.message!;
        break;
        
      case 3:
        if (_formData.experienceLevel.isEmpty) newErrors['experienceLevel'] = 'Please select your experience level';
        final interestsValidation = validateInterests(_formData.interests);
        if (!interestsValidation.isValid) newErrors['interests'] = interestsValidation.message!;
        break;
        
      case 4:
        final emergencyNameValidation = validateName(_formData.emergencyName);
        if (!emergencyNameValidation.isValid) newErrors['emergencyName'] = emergencyNameValidation.message!;
        
        final emergencyPhoneValidation = validatePhone(_formData.emergencyPhone);
        if (!emergencyPhoneValidation.isValid) newErrors['emergencyPhone'] = emergencyPhoneValidation.message!;
        
        if (_formData.emergencyRelationship.isEmpty) newErrors['emergencyRelationship'] = 'Please select relationship';
        break;
        
      case 5:
        final bioValidation = validateBio(_formData.bio);
        if (!bioValidation.isValid) newErrors['bio'] = bioValidation.message!;
        break;
        
      case 6:
        if (!_formData.agreeToTerms) newErrors['terms'] = 'Please agree to the terms and conditions';
        break;
    }
    
    setState(() {
      _errors.clear();
      _errors.addAll(newErrors);
    });
    
    return newErrors.isEmpty;
  }

  bool _canProceedToNext() {
    switch (_currentStep) {
      case 1:
        return _formData.firstName.isNotEmpty &&
            _formData.lastName.isNotEmpty &&
            _formData.email.isNotEmpty &&
            _formData.password.isNotEmpty &&
            _formData.confirmPassword.isNotEmpty;
      case 2:
        return _formData.country.isNotEmpty;
      case 3:
        return _formData.experienceLevel.isNotEmpty && _formData.interests.length >= 3;
      case 4:
        return _formData.emergencyName.isNotEmpty &&
            _formData.emergencyPhone.isNotEmpty &&
            _formData.emergencyRelationship.isNotEmpty;
      case 5:
        return _formData.bio.length >= 20;
      case 6:
        return _formData.agreeToTerms;
      default:
        return false;
    }
  }

  void _handleNext() {
    if (_validateCurrentStep()) {
      if (_currentStep < TOTAL_STEPS) {
        setState(() {
          _currentStep++;
          _errors.clear();
        });
      } else {
        _handleSubmit();
      }
    }
  }

  void _handleBack() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      widget.onBackToLogin();
    }
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      print('Signup data: ${_formData.toJson()}');
      
      setState(() {
        _showSuccess = true;
      });
      
      await Future.delayed(const Duration(seconds: 2));
      widget.onSignupComplete();
      
    } catch (error) {
      print('Signup error: $error');
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _renderStepContent() {
    switch (_currentStep) {
      case 1:
        return _renderPersonalInfoStep();
      case 2:
        return _renderLocationStep();
      case 3:
        return _renderAdventureLevelStep();
      case 4:
        return _renderEmergencyContactStep();
      case 5:
        return _renderAboutYouStep();
      case 6:
        return _renderFinalStep();
      default:
        return _renderPersonalInfoStep();
    }
  }

  Widget _renderPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          icon: Icons.person,
          title: 'Personal Information',
          subtitle: "Let's get started",
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    hintText: 'First Name',
                    value: _formData.firstName,
                    onChanged: (value) => _updateFormData(_formData.copyWith(firstName: value)),
                    errorText: _errors['firstName'],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    hintText: 'Last Name',
                    value: _formData.lastName,
                    onChanged: (value) => _updateFormData(_formData.copyWith(lastName: value)),
                    errorText: _errors['lastName'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              hintText: 'Email Address',
              value: _formData.email,
              onChanged: (value) => _updateFormData(_formData.copyWith(email: value)),
              errorText: _errors['email'],
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              hintText: 'Create Password',
              value: _formData.password,
              onChanged: (value) => _updateFormData(_formData.copyWith(password: value)),
              errorText: _errors['password'],
              obscureText: !_showPassword,
              onToggleVisibility: () => setState(() => _showPassword = !_showPassword),
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              hintText: 'Confirm Password',
              value: _formData.confirmPassword,
              onChanged: (value) => _updateFormData(_formData.copyWith(confirmPassword: value)),
              errorText: _errors['confirmPassword'],
              obscureText: !_showConfirmPassword,
              onToggleVisibility: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    hintText: 'Phone Number (Optional)',
                    value: _formData.phone,
                    onChanged: (value) => _updateFormData(_formData.copyWith(phone: value)),
                    errorText: _errors['phone'],
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    value: _formData.gender,
                    hintText: 'Gender',
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male')),
                      DropdownMenuItem(value: 'female', child: Text('Female')),
                      DropdownMenuItem(value: 'other', child: Text('Other')),
                      DropdownMenuItem(value: 'prefer-not-to-say', child: Text('Prefer not to say')),
                    ],
                    onChanged: (value) => _updateFormData(_formData.copyWith(gender: value ?? '')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDateField(),
          ],
        ),
      ],
    );
  }

  Widget _renderLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          icon: Icons.location_on,
          title: 'Location',
          subtitle: 'Help us find adventures near you',
          color: Colors.orange,
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            _buildDropdown(
              value: _formData.country,
              hintText: 'Select Country',
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country.value,
                  child: Text(country.label),
                );
              }).toList(),
              onChanged: (value) => _updateFormData(_formData.copyWith(country: value ?? '')),
              errorText: _errors['country'],
              prefixIcon: Icons.public,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              hintText: 'Enter City',
              value: _formData.city,
              onChanged: (value) => _updateFormData(_formData.copyWith(city: value)),
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.security,
              title: 'Privacy Note',
              message: 'Your location helps us suggest nearby trails and connect you with local adventurers. '
                  'We never share your exact location without permission.',
              color: Colors.green,
            ),
          ],
        ),
      ],
    );
  }

  Widget _renderAdventureLevelStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          icon: Icons.landscape,
          title: 'Adventure Level',
          subtitle: 'Tell us about your outdoor experience',
          color: Colors.amber,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Experience Level',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildExperienceLevelCard(
                  value: 'beginner',
                  label: 'Beginner',
                  description: 'New to outdoor adventures',
                  isSelected: _formData.experienceLevel == 'beginner',
                ),
                _buildExperienceLevelCard(
                  value: 'intermediate',
                  label: 'Intermediate',
                  description: 'Some outdoor experience',
                  isSelected: _formData.experienceLevel == 'intermediate',
                ),
                _buildExperienceLevelCard(
                  value: 'advanced',
                  label: 'Advanced',
                  description: 'Experienced adventurer',
                  isSelected: _formData.experienceLevel == 'advanced',
                ),
                _buildExperienceLevelCard(
                  value: 'expert',
                  label: 'Expert',
                  description: 'Professional level',
                  isSelected: _formData.experienceLevel == 'expert',
                ),
              ],
            ),
            if (_errors.containsKey('experienceLevel'))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errors['experienceLevel']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Select Interests (${_formData.interests.length}/10)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: _adventureInterests.map((interest) {
                return _buildInterestCard(interest);
              }).toList(),
            ),
            if (_errors.containsKey('interests'))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errors['interests']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _renderEmergencyContactStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          icon: Icons.security,
          title: 'Safety First',
          subtitle: 'Phone number for emergency situations',
          color: Colors.red,
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            _buildTextField(
              hintText: 'Emergency Contact Name',
              value: _formData.emergencyName,
              onChanged: (value) => _updateFormData(_formData.copyWith(emergencyName: value)),
              errorText: _errors['emergencyName'],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              hintText: 'Emergency Phone Number',
              value: _formData.emergencyPhone,
              onChanged: (value) => _updateFormData(_formData.copyWith(emergencyPhone: value)),
              errorText: _errors['emergencyPhone'],
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              value: _formData.emergencyRelationship,
              hintText: 'Relationship',
              items: const [
                DropdownMenuItem(value: 'parent', child: Text('Parent')),
                DropdownMenuItem(value: 'spouse', child: Text('Spouse')),
                DropdownMenuItem(value: 'sibling', child: Text('Sibling')),
                DropdownMenuItem(value: 'friend', child: Text('Friend')),
              ],
              onChanged: (value) => _updateFormData(_formData.copyWith(emergencyRelationship: value ?? '')),
              errorText: _errors['emergencyRelationship'],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.favorite,
              title: 'Safety is our priority',
              message: 'This contact will only be used in emergency situations during outdoor activities. '
                  'We never share this information for marketing purposes.',
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _renderAboutYouStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          icon: Icons.group,
          title: 'About You',
          subtitle: 'Tell us about yourself',
          color: Colors.purple,
        ),
        const SizedBox(height: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bio (${_formData.bio.length}/500)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 5,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Tell us about your outdoor experiences and what you love about adventures...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _errors.containsKey('bio') ? Colors.red : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: _errors.containsKey('bio') ? Colors.red : Colors.blue,
                  ),
                ),
              ),
              onChanged: (value) => _updateFormData(_formData.copyWith(bio: value)),
            ),
            if (_errors.containsKey('bio'))
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errors['bio']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Profile Picture (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildUploadCard(),
          ],
        ),
      ],
    );
  }

  Widget _renderFinalStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildStepHeader(
          icon: Icons.check,
          title: 'Almost there!',
          subtitle: 'Just agree to our terms and you\'re ready to explore',
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.green.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(Icons.landscape, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ready to Adventure',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Join thousands of outdoor enthusiasts',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.only(left: 60),
                  child: Text(
                    'Your profile is complete! You\'ll have access to personalized trail recommendations, '
                    'local adventure groups, and emergency safety features.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _formData.agreeToTerms,
                  onChanged: (value) => _updateFormData(_formData.copyWith(agreeToTerms: value ?? false)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of Service',
                            style: const TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // Handle terms tap
                            },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(color: Colors.green),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              // Handle privacy policy tap
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_errors.containsKey('terms'))
              Padding(
                padding: const EdgeInsets.only(left: 48, top: 4),
                child: Text(
                  _errors['terms']!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {
                    // Handle marketing consent
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'I\'d like to receive updates about new trails, events, and outdoor tips',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Helper widget methods
  Widget _buildStepHeader({required IconData icon, required String title, required String subtitle, required Color color}) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String hintText,
    required String value,
    required ValueChanged<String> onChanged,
    String? errorText,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.collapsed(offset: value.length),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.blue,
              ),
            ),
            errorText: errorText,
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String hintText,
    required String value,
    required ValueChanged<String> onChanged,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? errorText,
  }) {
    return TextField(
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value.length),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.blue,
          ),
        ),
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String value,
    required String hintText,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    String? errorText,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.isEmpty ? null : value,
                hint: Row(
                  children: [
                    if (prefixIcon != null) ...[
                      Icon(prefixIcon, color: Colors.grey),
                      const SizedBox(width: 8),
                    ],
                    Text(hintText, style: TextStyle(color: Colors.grey.shade500)),
                  ],
                ),
                items: items,
                onChanged: onChanged,
                isExpanded: true,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: TextEditingController(text: _formData.dateOfBirth),
      decoration: InputDecoration(
        hintText: 'Date of Birth',
        prefixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          firstDate: DateTime(1900),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
        );
        if (picked != null) {
          _updateFormData(_formData.copyWith(dateOfBirth: DateFormat('yyyy-MM-dd').format(picked)));
        }
      },
    );
  }

  Widget _buildExperienceLevelCard({
    required String value,
    required String label,
    required String description,
    required bool isSelected,
  }) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _updateFormData(_formData.copyWith(experienceLevel: value)),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestCard(AdventureInterest interest) {
    final isSelected = _formData.interests.contains(interest.id);
    
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _toggleInterest(interest.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: interest.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(interest.icon, color: interest.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  interest.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check, color: Colors.green, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String message, required Color color}) {
    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: InkWell(
        onTap: () {
          // Handle image upload
        },
        borderRadius: BorderRadius.circular(12),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.cloud_upload, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                'Upload profile picture',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'JPG, PNG up to 5MB',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return Scaffold(
        body: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to Wildstride!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your account has been created successfully. Get ready to explore amazing adventures!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBack,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Account'),
            Text(
              'Step $_currentStep of $TOTAL_STEPS',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          // Language selector would go here
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // Handle language selection
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: _renderStepContent(),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _handleBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, size: 16),
                    SizedBox(width: 8),
                    Text('Back'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _canProceedToNext() && !_isSubmitting ? _handleNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_currentStep == TOTAL_STEPS ? 'Create Account' : 'Continue'),
                          const SizedBox(width: 8),
                          Icon(_currentStep == TOTAL_STEPS ? Icons.check : Icons.arrow_forward, size: 16),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to convert SignupData to JSON for debugging
extension SignupDataExtension on SignupData {
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phone': phone,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'country': country,
      'city': city,
      'experienceLevel': experienceLevel,
      'interests': interests,
      'bio': bio,
      'emergencyName': emergencyName,
      'emergencyPhone': emergencyPhone,
      'emergencyRelationship': emergencyRelationship,
      'agreeToTerms': agreeToTerms,
      'profilePicture': profilePicture,
    };
  }
}