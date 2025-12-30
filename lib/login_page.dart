import 'package:flutter/material.dart';
import 'logo_widget.dart';
import 'SignUp/sign_up_flow.dart';
import 'screens/auth/forgot_password_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  String? _emailError;
  String? _passwordError;
  bool _isButtonEnabled = false;

  void _validateInputs() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    String? emailError;
    String? passwordError;

    // ✅ Email validation
    if (email.isEmpty) {
      emailError = 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = 'Enter a valid email address';
    }

    // ✅ Password validation
    if (password.isEmpty) {
      passwordError = 'Please enter your password';
    } else if (password.length < 8) {
      passwordError = 'Password must be at least 8 characters';
    } else if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
      passwordError = 'Must contain letters and numbers';
    }

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
      _isButtonEnabled = emailError == null && passwordError == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = const Color(0xFF0A4D1C);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              width: constraints.maxWidth > 600 ? 400 : double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              decoration: constraints.maxWidth > 600
                  ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              )
                  : null,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min, // shrink vertically
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ✅ Logo
                    const Logo(size: "xl", showText: true),
                    const SizedBox(height: 0),

                    // Welcome text
                    Text(
                      "Welcome to Wildstride",
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Stride Into The Wild",
                      style:
                      TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 28),

                    // Email field
                    TextField(
                      controller: _emailController,
                      onChanged: (_) => _validateInputs(),
                      decoration: InputDecoration(
                        hintText: "Email address",
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _emailError,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextField(
                      controller: _passwordController,
                      onChanged: (_) => _validateInputs(),
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _passwordError,
                      ),
                    ),
                    const SizedBox(height: 24),

// Sign-In button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () {
                          // TODO: You can add your validation or Firebase auth check here later.
                          Navigator.pushReplacementNamed(context, '/landing');
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          _isButtonEnabled ? const Color(0xFF004D2C) : Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Forgot password
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider with text
                    Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("Or continue with"),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Social login row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _socialButton("assets/images/google.png"),
                        _socialButton("assets/images/facebook.png"),
                        _socialButton("assets/images/instagram.png"),
                        _socialButton("assets/images/apple.png"),
                        _socialButton("assets/images/wechat.png"),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignupFlow()),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: primaryGreen,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _socialButton(String asset) {
    return GestureDetector(
      onTap: () {
        // Navigate to Landing Page when tapped
        Navigator.pushReplacementNamed(context, '/landing');
      },
      child: Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }

}