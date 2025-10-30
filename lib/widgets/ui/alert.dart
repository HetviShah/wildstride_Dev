import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final Widget? icon;
  final Widget? title;
  final Widget? description;
  final List<Widget>? actions;
  final AlertVariant variant;
  final EdgeInsetsGeometry? padding;
  final double gap;
  final BorderRadiusGeometry? borderRadius;

  const Alert({
    super.key,
    this.icon,
    this.title,
    this.description,
    this.actions,
    this.variant = AlertVariant.defaultVariant,
    this.padding,
    this.gap = 8.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final (backgroundColor, borderColor, iconColor, textColor) = _getVariantColors(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildContent(context, iconColor, textColor),
          if (actions != null && actions!.isNotEmpty) ...[
            SizedBox(height: gap),
            _buildActions(),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color iconColor, Color textColor) {
    final hasIcon = icon != null;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasIcon) ...[
          IconTheme(
            data: IconThemeData(
              size: 20,
              color: iconColor,
            ),
            child: icon!,
          ),
          SizedBox(width: 12),
        ] else
          const SizedBox(width: 0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  child: title!,
                ),
              if (title != null && description != null)
                SizedBox(height: 4),
              if (description != null)
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: variant == AlertVariant.destructive 
                        ? textColor.withOpacity(0.9)
                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  child: description!,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions!.map((action) => action).toList(),
    );
  }

  (Color, Color, Color, Color) _getVariantColors(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (variant) {
      case AlertVariant.destructive:
        return (
          colorScheme.errorContainer,
          colorScheme.errorContainer,
          colorScheme.onErrorContainer,
          colorScheme.onErrorContainer,
        );
      case AlertVariant.defaultVariant:
        final theme = Theme.of(context);
        return (
          theme.cardTheme.color ?? theme.cardColor,
          theme.dividerColor,
          colorScheme.onSurface,
          colorScheme.onSurface,
        );
    }
  }
}

class AlertTitle extends StatelessWidget {
  final Widget child;
  final TextStyle? style;

  const AlertTitle({
    super.key,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: (style ?? Theme.of(context).textTheme.titleMedium)!.copyWith(
        fontWeight: FontWeight.w500,
      ),
      child: child,
    );
  }
}

class AlertDescription extends StatelessWidget {
  final Widget child;
  final TextStyle? style;

  const AlertDescription({
    super.key,
    required this.child,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: (style ?? Theme.of(context).textTheme.bodyMedium)!.copyWith(
        height: 1.5,
      ),
      child: child,
    );
  }
}

enum AlertVariant {
  defaultVariant,
  destructive,
}

// Pre-built alert components for common use cases
class AlertComponents {
  static Widget iconAlert({
    required IconData icon,
    required String title,
    required String description,
    AlertVariant variant = AlertVariant.defaultVariant,
    List<Widget>? actions,
  }) {
    return Alert(
      icon: Icon(icon),
      title: Text(title),
      description: Text(description),
      variant: variant,
      actions: actions,
    );
  }

  static Widget successAlert({
    required String title,
    required String description,
    List<Widget>? actions,
  }) {
    return Alert(
      icon: Icon(Icons.check_circle, color: Colors.green),
      title: Text(title),
      description: Text(description),
      actions: actions,
    );
  }

  static Widget errorAlert({
    required String title,
    required String description,
    List<Widget>? actions,
  }) {
    return Alert(
      icon: Icon(Icons.error, color: Colors.red),
      title: Text(title),
      description: Text(description),
      variant: AlertVariant.destructive,
      actions: actions,
    );
  }

  static Widget warningAlert({
    required String title,
    required String description,
    List<Widget>? actions,
  }) {
    return Alert(
      icon: Icon(Icons.warning, color: Colors.orange),
      title: Text(title),
      description: Text(description),
      actions: actions,
    );
  }

  static Widget infoAlert({
    required String title,
    required String description,
    List<Widget>? actions,
  }) {
    return Alert(
      icon: Icon(Icons.info, color: Colors.blue),
      title: Text(title),
      description: Text(description),
      actions: actions,
    );
  }
}

// Alert with custom icon widget
class CustomIconAlert extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final AlertVariant variant;
  final List<Widget>? actions;

  const CustomIconAlert({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.variant = AlertVariant.defaultVariant,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Alert(
      icon: icon,
      title: Text(title),
      description: Text(description),
      variant: variant,
      actions: actions,
    );
  }
}