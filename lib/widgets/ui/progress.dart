import 'package:flutter/material.dart';

// Utility function similar to cn
String cn(String baseClass, [String? additionalClasses]) {
  if (additionalClasses == null || additionalClasses.isEmpty) {
    return baseClass;
  }
  return '$baseClass $additionalClasses';
}

class Progress extends StatelessWidget {
  final double? value;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final BorderRadiusGeometry borderRadius;
  final Duration animationDuration;
  final Curve animationCurve;

  const Progress({
    super.key,
    this.value,
    this.height = 8.0,
    this.backgroundColor = const Color(0x1A007AFF), // primary/20 equivalent
    this.progressColor = const Color(0xFF007AFF), // primary color
    this.borderRadius = const BorderRadius.all(Radius.circular(9999)),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = (value ?? 0.0).clamp(0.0, 100.0);
    final double percentage = progressValue / 100.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background
              Container(
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: borderRadius,
                ),
              ),
              
              // Progress indicator
              AnimatedContainer(
                duration: animationDuration,
                curve: animationCurve,
                width: constraints.maxWidth * percentage,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: borderRadius,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Alternative implementation using TweenAnimationBuilder for smoother animations
class AnimatedProgress extends StatelessWidget {
  final double? value;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final BorderRadiusGeometry borderRadius;
  final Duration animationDuration;
  final Curve animationCurve;

  const AnimatedProgress({
    super.key,
    this.value,
    this.height = 8.0,
    this.backgroundColor = const Color(0x1A007AFF),
    this.progressColor = const Color(0xFF007AFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(9999)),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = (value ?? 0.0).clamp(0.0, 100.0);
    final double percentage = progressValue / 100.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return TweenAnimationBuilder<double>(
            duration: animationDuration,
            curve: animationCurve,
            tween: Tween<double>(
              begin: 0.0,
              end: percentage,
            ),
            builder: (context, animatedPercentage, child) {
              return Stack(
                children: [
                  // Background
                  Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: borderRadius,
                    ),
                  ),
                  
                  // Progress indicator
                  Container(
                    width: constraints.maxWidth * animatedPercentage,
                    decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: borderRadius,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// Progress with more customization options
class CustomizableProgress extends StatelessWidget {
  final double? value;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final List<BoxShadow>? shadow;
  final BorderRadiusGeometry borderRadius;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget? child;

  const CustomizableProgress({
    super.key,
    this.value,
    this.height = 8.0,
    this.backgroundColor = const Color(0x1A007AFF),
    this.progressColor = const Color(0xFF007AFF),
    this.shadow,
    this.borderRadius = const BorderRadius.all(Radius.circular(9999)),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double progressValue = (value ?? 0.0).clamp(0.0, 100.0);
    final double percentage = progressValue / 100.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: shadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              color: backgroundColor,
            ),
            
            // Progress indicator
            AnimatedContainer(
              duration: animationDuration,
              curve: animationCurve,
              width: percentage * 100, // This will be constrained by parent
              height: double.infinity,
              color: progressColor,
            ),
            
            // Child widget (for text labels, etc.)
            if (child != null)
              Center(child: child!),
          ],
        ),
      ),
    );
  }
}

// Version that actually uses Theme data for more dynamic styling
class ThemedProgress extends StatelessWidget {
  final double? value;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadiusGeometry borderRadius;
  final Duration animationDuration;
  final Curve animationCurve;

  const ThemedProgress({
    super.key,
    this.value,
    this.height = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(9999)),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color effectiveBackgroundColor = backgroundColor ?? 
        theme.colorScheme.primary.withOpacity(0.2);
    final Color effectiveProgressColor = progressColor ?? theme.colorScheme.primary;

    final double progressValue = (value ?? 0.0).clamp(0.0, 100.0);
    final double percentage = progressValue / 100.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: borderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background
              Container(
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  color: effectiveBackgroundColor,
                  borderRadius: borderRadius,
                ),
              ),
              
              // Progress indicator
              AnimatedContainer(
                duration: animationDuration,
                curve: animationCurve,
                width: constraints.maxWidth * percentage,
                decoration: BoxDecoration(
                  color: effectiveProgressColor,
                  borderRadius: borderRadius,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Usage Examples
class ProgressExample extends StatefulWidget {
  const ProgressExample({super.key});

  @override
  State<ProgressExample> createState() => _ProgressExampleState();
}

class _ProgressExampleState extends State<ProgressExample> {
  double _progressValue = 30.0;

  void _incrementProgress() {
    setState(() {
      _progressValue = (_progressValue + 10).clamp(0.0, 100.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Basic Progress
            const Text('Basic Progress:'),
            const SizedBox(height: 10),
            Progress(value: 25),
            
            const SizedBox(height: 30),
            
            // Animated Progress
            const Text('Animated Progress:'),
            const SizedBox(height: 10),
            AnimatedProgress(value: _progressValue),
            
            const SizedBox(height: 30),
            
            // Themed Progress (uses theme colors)
            const Text('Themed Progress:'),
            const SizedBox(height: 10),
            ThemedProgress(value: _progressValue),
            
            const SizedBox(height: 30),
            
            // Customizable Progress
            const Text('Customizable Progress:'),
            const SizedBox(height: 10),
            CustomizableProgress(
              value: _progressValue,
              height: 12,
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.green,
              shadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Progress with label
            const Text('Progress with Label:'),
            const SizedBox(height: 10),
            CustomizableProgress(
              value: _progressValue,
              height: 20,
              backgroundColor: Colors.blueGrey[100]!,
              progressColor: Colors.deepPurple,
              child: Text(
                '${_progressValue.round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Control buttons
            ElevatedButton(
              onPressed: _incrementProgress,
              child: const Text('Increase Progress by 10%'),
            ),
            
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _progressValue = 0;
                });
              },
              child: const Text('Reset Progress'),
            ),
          ],
        ),
      ),
    );
  }
}