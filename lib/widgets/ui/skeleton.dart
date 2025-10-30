import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Color color;
  final BoxShape shape;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const Skeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 4.0,
    this.color = const Color(0xFFE5E7EB),
    this.shape = BoxShape.rectangle,
    this.child,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: shape == BoxShape.rectangle 
            ? BorderRadius.circular(borderRadius) 
            : null,
        shape: shape,
      ),
      child: child,
    );
  }
}

// Animated Skeleton with pulse animation
class AnimatedSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;
  final BoxShape shape;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AnimatedSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 4.0,
    this.baseColor = const Color(0xFFE5E7EB),
    this.highlightColor = const Color(0xFFF3F4F6),
    this.duration = const Duration(milliseconds: 1500),
    this.shape = BoxShape.rectangle,
    this.child,
    this.margin,
    this.padding,
  });

  @override
  State<AnimatedSkeleton> createState() => _AnimatedSkeletonState();
}

class _AnimatedSkeletonState extends State<AnimatedSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: widget.baseColor,
      end: widget.highlightColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _colorAnimation.value,
            borderRadius: widget.shape == BoxShape.rectangle 
                ? BorderRadius.circular(widget.borderRadius) 
                : null,
            shape: widget.shape,
          ),
          child: widget.child,
        );
      },
    );
  }
}

// Pre-built skeleton components for common use cases
class SkeletonCircle extends StatelessWidget {
  final double size;
  final Color color;

  const SkeletonCircle({
    super.key,
    required this.size,
    this.color = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: size,
      height: size,
      shape: BoxShape.circle,
      color: color,
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final Color color;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = 4.0,
    this.color = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      width: width,
      height: height,
      borderRadius: borderRadius,
      color: color,
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double size;
  final Color color;

  const SkeletonAvatar({
    super.key,
    this.size = 40.0,
    this.color = const Color(0xFFE5E7EB),
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonCircle(size: size, color: color);
  }
}

// Example usage
class SkeletonExample extends StatelessWidget {
  const SkeletonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skeleton Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static skeleton
            const Skeleton(
              width: 200,
              height: 20,
              borderRadius: 4,
            ),
            const SizedBox(height: 16),
            
            // Animated skeleton (like the React version)
            const AnimatedSkeleton(
              width: 150,
              height: 16,
              borderRadius: 4,
            ),
            const SizedBox(height: 16),
            
            // Skeleton for a list item
            Row(
              children: [
                const SkeletonCircle(size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AnimatedSkeleton(width: 120, height: 14),
                      const SizedBox(height: 4),
                      const AnimatedSkeleton(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Multiple text skeletons with different widths
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AnimatedSkeleton(width: double.infinity, height: 14),
                const SizedBox(height: 8),
                const AnimatedSkeleton(width: 250, height: 14),
                const SizedBox(height: 8),
                const AnimatedSkeleton(width: 200, height: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Usage in a loading state
class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                AnimatedSkeleton(width: 40, height: 40, shape: BoxShape.circle),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSkeleton(width: 120, height: 16),
                      SizedBox(height: 4),
                      AnimatedSkeleton(width: 80, height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const AnimatedSkeleton(width: double.infinity, height: 100),
            const SizedBox(height: 12),
            const AnimatedSkeleton(width: 100, height: 32),
          ],
        ),
      ),
    );
  }
}