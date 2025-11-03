import 'package:flutter/material.dart';

/// ✅ Global responsive layout wrapper for Wildstride.
/// Keeps all pages mobile-sized (≈430 px) on web/tablet and full width on phones.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  const ResponsiveLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth > 600; // web/tablet detection
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430), // Figma width
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              width: isWide ? 430 : double.infinity,
              child: child,
            ),
          ),
        );
      },
    );
  }
}