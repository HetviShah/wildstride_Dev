import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final Widget? child;
  final double size;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  
  const Avatar({
    super.key,
    this.child,
    this.size = 40,
    this.decoration,
    this.padding,
    this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: decoration ?? BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: ClipOval(
        child: child,
      ),
    );
    
    if (onPressed != null) {
      return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: avatar,
      );
    }
    
    return avatar;
  }
}

class AvatarImage extends StatelessWidget {
  final ImageProvider image;
  final double size;
  final BoxFit fit;
  final Widget? placeholder;
  
  const AvatarImage({
    super.key,
    required this.image,
    this.size = 40,
    this.fit = BoxFit.cover,
    this.placeholder,
  });
  
  @override
  Widget build(BuildContext context) {
    return Avatar(
      size: size,
      child: Image(
        image: image,
        fit: fit,
        width: size,
        height: size,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? const CircularProgressIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return placeholder ?? const Icon(Icons.person);
        },
      ),
    );
  }
}

class AvatarFallback extends StatelessWidget {
  final Widget child;
  final double size;
  final Color? backgroundColor;
  
  const AvatarFallback({
    super.key,
    required this.child,
    this.size = 40,
    this.backgroundColor,
  });
  
  @override
  Widget build(BuildContext context) {
    return Avatar(
      size: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Center(child: child),
    );
  }
}

// Utility class for conditional styling (similar to React's cn function)
class Cn {
  static String join(List<String?> classes) {
    return classes.where((c) => c != null && c.isNotEmpty).join(' ');
  }
}