import 'package:flutter/material.dart';

class Breadcrumb extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;

  const Breadcrumb({
    super.key,
    required this.child,
    this.semanticLabel = 'breadcrumb',
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: true,
      child: child,
    );
  }
}

class BreadcrumbList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double gap;

  const BreadcrumbList({
    super.key,
    required this.children,
    this.padding,
    this.gap = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ) ?? const TextStyle(),
      child: Wrap(
        spacing: gap,
        runSpacing: gap / 2,
        children: children,
      ),
    );
  }
}

class BreadcrumbItem extends StatelessWidget {
  final Widget child;
  final double gap;

  const BreadcrumbItem({
    super.key,
    required this.child,
    this.gap = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        SizedBox(width: gap),
      ],
    );
  }
}

class BreadcrumbLink extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool asChild;
  final EdgeInsetsGeometry? padding;

  const BreadcrumbLink({
    super.key,
    required this.child,
    this.onTap,
    this.asChild = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (asChild) {
      return child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            decoration: onTap != null ? TextDecoration.underline : TextDecoration.none,
          ) ?? const TextStyle(),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            child: child,
          ),
        ),
      ),
    );
  }
}

class BreadcrumbPage extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const BreadcrumbPage({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Current page',
      container: true,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.normal,
        ) ?? const TextStyle(),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: child,
        ),
      ),
    );
  }
}

class BreadcrumbSeparator extends StatelessWidget {
  final Widget? child;
  final double size;

  const BreadcrumbSeparator({
    super.key,
    this.child,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      hidden: true,
      child: IconTheme(
        data: IconThemeData(
          size: size,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
        child: child ?? const Icon(Icons.chevron_right),
      ),
    );
  }
}

class BreadcrumbEllipsis extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? padding;

  const BreadcrumbEllipsis({
    super.key,
    this.size = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      hidden: true,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: Icon(
          Icons.more_horiz,
          size: size,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }
}