import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AuthScreens extends StatefulWidget {
  final VoidCallback onLogin;

  const AuthScreens({Key? key, required this.onLogin}) : super(key: key);

  @override
  _AuthScreensState createState() => _AuthScreensState();
}

class OnboardingStep {
  final IconData icon;
  final String title;
  final String description;
  final String color;

  OnboardingStep({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class _AuthScreensState extends State<AuthScreens> {
  String _currentScreen = 'login';
  bool _showPassword = false;
  int _onboardingStep = 0;
  TextDirection _direction = TextDirection.ltr;

  final List<OnboardingStep> _onboardingSteps = [
    OnboardingStep(
      icon: LucideIcons.mountain,
      title: 'Discover Adventures',
      description: 'Explore amazing outdoor experiences',
      color: 'from-wildstride-forest-green to-green-600',
    ),
    OnboardingStep(
      icon: LucideIcons.users,
      title: 'Connect Explorers',
      description: 'Meet fellow adventure enthusiasts',
      color: 'from-wildstride-trail-orange to-orange-600',
    ),
    OnboardingStep(
      icon: LucideIcons.compass,
      title: 'Track Journey',
      description: 'Monitor your outdoor activities',
      color: 'from-wildstride-silk-gold to-yellow-600',
    ),
  ];

  void _handleLogin() {
    widget.onLogin();
  }

  void _handleSignup() {
    setState(() {
      _currentScreen = 'detailed-signup';
    });
  }

  void _handleSignupComplete() {
    setState(() {
      _currentScreen = 'onboarding';
      _onboardingStep = 0;
    });
  }

  void _handleOnboardingNext() {
    if (_onboardingStep < _onboardingSteps.length - 1) {
      setState(() {
        _onboardingStep++;
      });
    } else {
      _handleLogin();
    }
  }

  Widget _buildLanguageSelector() {
    return Positioned(
      top: 16,
      right: _direction == TextDirection.rtl ? null : 16,
      left: _direction == TextDirection.rtl ? 16 : null,
      child: _buildCompactLanguageSelector(),
    );
  }

  Widget _buildCompactLanguageSelector() {
    // Placeholder for language selector
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(Icons.language, size: 20),
    );
  }

  Widget _buildSocialLoginButton(Widget icon, Color color, {Color? backgroundColor}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: IconButton(
        onPressed: _handleLogin,
        icon: icon,
        iconSize: 20,
        color: color,
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // wildstride-himalayan-mist
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32), // wildstride-forest-green
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.landscape, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your outdoor adventure companion',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email Field
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(LucideIcons.mail, size: 20),
                              hintText: 'Email Address',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: TextField(
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(LucideIcons.lock, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(_showPassword ? LucideIcons.eyeOff : LucideIcons.eye, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                              hintText: 'Password',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 16),

                        // Forgot Password
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentScreen = 'forgot';
                            });
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Color(0xFF2E7D32)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text('or continue with', style: TextStyle(color: Colors.grey)),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade300)),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Social Login Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSocialLoginButton(
                              const Icon(Icons.g_mobiledata),
                              Colors.black,
                            ),
                            _buildSocialLoginButton(
                              const Icon(Icons.facebook),
                              Colors.white,
                              backgroundColor: const Color(0xFF0866FF),
                            ),
                            _buildSocialLoginButton(
                              const Icon(Icons.camera_alt),
                              Colors.white,
                              backgroundColor: Colors.pink,
                            ),
                            _buildSocialLoginButton(
                              const Icon(Icons.chat),
                              Colors.white,
                              backgroundColor: const Color(0xFF09B83E),
                            ),
                            _buildSocialLoginButton(
                              const Icon(Icons.apple),
                              Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentScreen = 'detailed-signup';
                          });
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Color(0xFF2E7D32)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildSignupScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and Title
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.landscape, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your outdoor adventure companion',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Fields
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(LucideIcons.user, size: 20),
                        hintText: 'Full Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(LucideIcons.mail, size: 20),
                        hintText: 'Email Address',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.lock, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword ? LucideIcons.eyeOff : LucideIcons.eye, size: 20),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        hintText: 'Create Password',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Create Account'),
                  ),
                  const SizedBox(height: 24),

                  // Divider and Social Login (similar to login screen)
                  // ... (similar social login section as login screen)

                  // Terms and Conditions
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'By signing up, you agree to our Terms of Service and Privacy Policy',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentScreen = 'login';
                          });
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Color(0xFF2E7D32)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentScreen = 'login';
                      });
                    },
                    icon: const Icon(LucideIcons.arrowLeft),
                    label: const Text('Back to Login'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.landscape, color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your email to receive a reset link',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email Field
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(LucideIcons.mail, size: 20),
                              hintText: 'Email Address',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Send Reset Link Button
                        ElevatedButton(
                          onPressed: () {
                            // Handle password reset
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Send Reset Link'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildOnboardingScreen() {
    final step = _onboardingSteps[_onboardingStep];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon with gradient background
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(step.icon, color: Colors.white, size: 48),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          step.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          step.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Progress Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _onboardingSteps.asMap().entries.map((entry) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: entry.key == _onboardingStep
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey.shade300,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),

                        // Logo on last step
                        if (_onboardingStep == _onboardingSteps.length - 1) ...[
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.landscape, color: Colors.white, size: 24),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),

                  // Buttons
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _handleOnboardingNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_onboardingStep < _onboardingSteps.length - 1
                                ? 'Continue'
                                : 'Get Started'),
                            const SizedBox(width: 8),
                            const Icon(LucideIcons.arrowRight),
                          ],
                        ),
                      ),
                      if (_onboardingStep > 0) ...[
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _onboardingStep--;
                            });
                          },
                          child: const Text('Back'),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildDetailedSignupScreen() {
    // Placeholder for detailed signup screen
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              onPressed: () {
                setState(() {
                  _currentScreen = 'login';
                });
              },
            ),
            title: const Text('Complete Your Profile'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Detailed signup form would go here'),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _handleSignupComplete,
                    child: const Text('Complete Signup'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      switch (_currentScreen) {
        case 'signup':
          return _buildSignupScreen();
        case 'detailed-signup':
          return _buildDetailedSignupScreen();
        case 'forgot':
          return _buildForgotPasswordScreen();
        case 'onboarding':
          return _buildOnboardingScreen();
        default:
          return _buildLoginScreen();
      }
    } catch (error) {
      print('Error in AuthScreens: $error');
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.landscape, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your outdoor adventure companion',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Enter App'),
              ),
            ],
          ),
        ),
      );
    }
  }
}