import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BoxShadow? shadow;

  const Card({
    super.key,
    this.child,
    this.children,
    this.padding,
    this.margin,
    this.borderRadius = 12,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.shadow,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Removed unused colorScheme variable

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth,
              )
            : null,
        boxShadow: shadow != null ? [shadow!] : [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: child ?? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children ?? [],
        ),
      ),
    );
  }
}

class CardHeader extends StatelessWidget {
  final Widget? title;
  final Widget? description;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final bool showBottomBorder;

  const CardHeader({
    super.key,
    this.title,
    this.description,
    this.action,
    this.padding,
    this.showBottomBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasAction = action != null;

    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: showBottomBorder
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            )
          : null,
      child: hasAction
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) title!,
                      if (description != null) 
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: description!,
                        ),
                    ],
                  ),
                ),
                if (action != null) action!,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) title!,
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: description!,
                  ),
              ],
            ),
    );
  }
}

class CardTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const CardTitle({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: style ?? theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      textAlign: textAlign,
    );
  }
}

class CardDescription extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;

  const CardDescription({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.left,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: style ?? theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}

class CardAction extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const CardAction({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return onPressed != null
        ? InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: child,
            ),
          )
        : child;
  }
}

class CardContent extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final bool isLastChild;

  const CardContent({
    super.key,
    this.child,
    this.children,
    this.padding,
    this.isLastChild = false,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(24, 0, 24, isLastChild ? 24 : 0),
      child: child ?? Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children ?? [],
      ),
    );
  }
}

class CardFooter extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment alignment;
  final bool showTopBorder;

  const CardFooter({
    super.key,
    this.child,
    this.children,
    this.padding,
    this.alignment = MainAxisAlignment.start,
    this.showTopBorder = false,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: showTopBorder
          ? BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            )
          : null,
      child: child ?? Row(
        mainAxisAlignment: alignment,
        children: children ?? [],
      ),
    );
  }
}