import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SignupStepLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String nextLabel;
  final String backLabel;
  final bool isNextEnabled;

  const SignupStepLayout({
    super.key,
    required this.title,
    required this.child,
    required this.onBack,
    required this.onNext,
    this.nextLabel = "Next",
    this.backLabel = "Back",
    this.isNextEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final formContent = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400), // same width as login
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Step-specific content
          child,

          const SizedBox(height: 32),

          // Buttons row
          Row(
            children: [
              // Back
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(backLabel),
                ),
              ),
              const SizedBox(width: 12),

              // Next / Continue
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isNextEnabled ? onNext : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (states) {
                        if (!isNextEnabled) {
                          return Colors.green.withOpacity(0.4); // ✅ visible disabled
                        }
                        return Colors.green; // enabled
                      },
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  icon: nextLabel == "Create Account"
                      ? const Icon(Icons.check)
                      : const Icon(Icons.arrow_forward),
                  label: Text(nextLabel),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWebWide = kIsWeb && constraints.maxWidth > 600;

          // ✅ Web/Desktop → center like Instagram login
          if (isWebWide) {
            return Center(
              child: SingleChildScrollView(
                child: Card(
                  color: Colors.transparent,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 24),
                    child: formContent,
                  ),
                ),
              ),
            );
          }

          // ✅ Mobile → scrollable
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: formContent,
          );
        },
      ),
    );
  }
}