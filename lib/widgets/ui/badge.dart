import 'package:flutter/material.dart';

enum BadgeVariant {
  primary,
  secondary,
  destructive,
  outline,
}

class Badge extends StatelessWidget {
  final Widget? child;
  final String? text;
  final BadgeVariant variant;
  final bool asChild;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Widget? icon;
  final double gap;

  const Badge({
    super.key,
    this.child,
    this.text,
    this.variant = BadgeVariant.primary,
    this.asChild = false,
    this.onPressed,
    this.padding,
    this.borderRadius = 8,
    this.icon,
    this.gap = 4,
  }) : assert(child != null || text != null, 'Either child or text must be provided');

  // Named constructors instead of extension methods
  const Badge.primary({
    super.key,
    this.child,
    this.text,
    this.asChild = false,
    this.onPressed,
    this.padding,
    this.borderRadius = 8,
    this.icon,
    this.gap = 4,
  }) : variant = BadgeVariant.primary;

  const Badge.secondary({
    super.key,
    this.child,
    this.text,
    this.asChild = false,
    this.onPressed,
    this.padding,
    this.borderRadius = 8,
    this.icon,
    this.gap = 4,
  }) : variant = BadgeVariant.secondary;

  const Badge.destructive({
    super.key,
    this.child,
    this.text,
    this.asChild = false,
    this.onPressed,
    this.padding,
    this.borderRadius = 8,
    this.icon,
    this.gap = 4,
  }) : variant = BadgeVariant.destructive;

  const Badge.outline({
    super.key,
    this.child,
    this.text,
    this.asChild = false,
    this.onPressed,
    this.padding,
    this.borderRadius = 8,
    this.icon,
    this.gap = 4,
  }) : variant = BadgeVariant.outline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final (backgroundColor, textColor, borderColor) = _getVariantColors(colorScheme);

    final badgeContent = Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null ? Border.all(color: borderColor) : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (icon != null && (child != null || text != null)) SizedBox(width: gap),
          if (child != null) child!,
          if (text != null) Text(
            text!,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );

    if (asChild) {
      return badgeContent;
    }

    if (onPressed != null) {
      return InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: badgeContent,
      );
    }

    return badgeContent;
  }

  (Color?, Color, Color?) _getVariantColors(ColorScheme colorScheme) {
    switch (variant) {
      case BadgeVariant.primary:
        return (colorScheme.primary, colorScheme.onPrimary, null);
      case BadgeVariant.secondary:
        return (colorScheme.secondary, colorScheme.onSecondary, null);
      case BadgeVariant.destructive:
        return (colorScheme.error, colorScheme.onError, null);
      case BadgeVariant.outline:
        return (Colors.transparent, colorScheme.onSurface, colorScheme.outline);
    }
  }
}