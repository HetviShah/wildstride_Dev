import 'package:flutter/material.dart';

enum ButtonVariant {
  primary,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}

enum ButtonSize {
  small,
  medium,
  large,
  icon,
}

class Button extends StatelessWidget {
  final Widget? child;
  final String? text;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool asChild;
  final VoidCallback? onPressed;
  final bool disabled;
  final Widget? icon;
  final double gap;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final FocusNode? focusNode;
  final bool autofocus;

  const Button({
    super.key,
    this.child,
    this.text,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.asChild = false,
    this.onPressed,
    this.disabled = false,
    this.icon,
    this.gap = 8,
    this.padding,
    this.borderRadius = 6,
    this.focusNode,
    this.autofocus = false,
  }) : assert(child != null || text != null, 'Either child or text must be provided');

  // Named constructors
  const Button.primary({
    super.key,
    this.child,
    this.text,
    this.size = ButtonSize.medium,
    this.asChild = false,
    this.onPressed,
    this.disabled = false,
    this.icon,
    this.gap = 8,
    this.padding,
    this.borderRadius = 6,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.primary;

  const Button.destructive({
    super.key,
    this.child,
    this.text,
    this.size = ButtonSize.medium,
    this.asChild = false,
    this.onPressed,
    this.disabled = false,
    this.icon,
    this.gap = 8,
    this.padding,
    this.borderRadius = 6,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.destructive;

  const Button.outline({
    super.key,
    this.child,
    this.text,
    this.size = ButtonSize.medium,
    this.asChild = false,
    this.onPressed,
    this.disabled = false,
    this.icon,
    this.gap = 8,
    this.padding,
    this.borderRadius = 6,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.outline;

  const Button.secondary({
    super.key,
    this.child,
    this.text,
    this.size = ButtonSize.medium,
    this.asChild = false,
    this.onPressed,
    this.disabled = false,
    this.icon,
    this.gap = 8,
    this.padding,
    this.borderRadius = 6,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.secondary;

  const Button.ghost({
    super.key,
    this.child,
    this.text,
    this.size = ButtonSize.medium,
    this.asChild = false,
    this.onPressed,
    this.disabled = false,
    this.icon,
    this.gap = 8,
    this.padding,
    this.borderRadius = 6,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.ghost;

  const Button.link({
    super.key,
    this.child,
    this.text,
    this.size = ButtonSize.medium,
    this.asChild = false,
    this.onPressed,
    this.disabled = false,
    this.icon,
    this.gap = 8,
    this.padding,
    this.borderRadius = 6,
    this.focusNode,
    this.autofocus = false,
  }) : variant = ButtonVariant.link;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (asChild) {
      return _buildButtonContent();
    }

    final buttonStyle = _getButtonStyle(theme, colorScheme);

    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: buttonStyle,
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) icon!,
        if (icon != null && (child != null || text != null) && gap > 0) 
          SizedBox(width: gap),
        if (child != null) child!,
        if (text != null) Text(text!),
      ],
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme, ColorScheme colorScheme) {
    final backgroundColor = _getBackgroundColor(colorScheme);
    final foregroundColor = _getForegroundColor(colorScheme);
    final overlayColor = _getOverlayColor(colorScheme);
    final shadowColor = _getShadowColor(colorScheme);
    final side = _getBorderSide(colorScheme);

    final padding = _getPadding();
    final minimumSize = _getMinimumSize();

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
      disabledForegroundColor: colorScheme.onSurface.withOpacity(0.38),
      shadowColor: shadowColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      padding: padding,
      minimumSize: minimumSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: side ?? BorderSide.none,
      ),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return overlayColor?.withOpacity(0.2);
        }
        if (states.contains(WidgetState.hovered)) {
          return overlayColor?.withOpacity(0.1);
        }
        if (states.contains(WidgetState.focused)) {
          return overlayColor?.withOpacity(0.12);
        }
        return null;
      }),
    );
  }

  Color? _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ButtonVariant.primary:
        return colorScheme.primary;
      case ButtonVariant.destructive:
        return colorScheme.error;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.secondary:
        return colorScheme.secondary;
      case ButtonVariant.ghost:
        return Colors.transparent;
      case ButtonVariant.link:
        return Colors.transparent;
    }
  }

  Color? _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case ButtonVariant.primary:
        return colorScheme.onPrimary;
      case ButtonVariant.destructive:
        return colorScheme.onError;
      case ButtonVariant.outline:
        return colorScheme.onSurface;
      case ButtonVariant.secondary:
        return colorScheme.onSecondary;
      case ButtonVariant.ghost:
        return colorScheme.onSurface;
      case ButtonVariant.link:
        return colorScheme.primary;
    }
  }

  Color? _getOverlayColor(ColorScheme colorScheme) {
    switch (variant) {
      case ButtonVariant.primary:
        return colorScheme.onPrimary;
      case ButtonVariant.destructive:
        return colorScheme.onError;
      case ButtonVariant.outline:
        return colorScheme.onSurface;
      case ButtonVariant.secondary:
        return colorScheme.onSecondary;
      case ButtonVariant.ghost:
        return colorScheme.onSurface;
      case ButtonVariant.link:
        return colorScheme.primary;
    }
  }

  Color? _getShadowColor(ColorScheme colorScheme) {
    return variant == ButtonVariant.ghost || variant == ButtonVariant.link 
        ? Colors.transparent 
        : null;
  }

  BorderSide? _getBorderSide(ColorScheme colorScheme) {
    switch (variant) {
      case ButtonVariant.outline:
        return BorderSide(color: colorScheme.outline);
      default:
        return null;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case ButtonSize.large:
        return padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.icon:
        return padding ?? const EdgeInsets.all(12);
    }
  }

  Size? _getMinimumSize() {
    switch (size) {
      case ButtonSize.small:
        return const Size(64, 32);
      case ButtonSize.medium:
        return const Size(64, 36);
      case ButtonSize.large:
        return const Size(64, 40);
      case ButtonSize.icon:
        return const Size(36, 36);
    }
  }
}