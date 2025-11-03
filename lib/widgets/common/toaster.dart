import 'package:flutter/material.dart';

class Toaster extends StatelessWidget {
  const Toaster({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 100,
      left: 0,
      right: 0,
      child: SizedBox(), // Empty container for toast notifications
    );
  }
}