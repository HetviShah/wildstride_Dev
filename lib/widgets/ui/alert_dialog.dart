import 'package:flutter/material.dart';

class AlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsets? contentPadding;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final bool scrollable;

  const AlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.contentPadding,
    this.shape,
    this.backgroundColor,
    this.scrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.background,
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: contentPadding ?? const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  child: title!,
                ),
                const SizedBox(height: 8),
              ],
              if (content != null) ...[
                Flexible(
                  child: scrollable
                      ? SingleChildScrollView(child: content!)
                      : content!,
                ),
                const SizedBox(height: 16),
              ],
              if (actions != null) ...[
                AlertDialogFooter(children: actions!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AlertDialogFooter extends StatelessWidget {
  final List<Widget> children;

  const AlertDialogFooter({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          children[i],
        ],
      ],
    );
  }
}

// Pre-built alert dialog components
class AlertDialogComponents {
  static Widget title(String text, {TextStyle? style}) {
    return Text(
      text,
      style: style,
      textAlign: TextAlign.center,
    );
  }

  static Widget description(String text, {TextStyle? style}) {
    return Text(
      text,
      style: style ?? TextStyle(
        color: ThemeData().colorScheme.onSurface.withOpacity(0.7),
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    );
  }

  static Widget action({
    required String text,
    required VoidCallback onPressed,
    ButtonStyle? style,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Text(text),
    );
  }

  static Widget cancel({
    required String text,
    required VoidCallback onPressed,
    ButtonStyle? style,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: style,
      child: Text(text),
    );
  }
}

// Custom alert dialog builder with animation
class AnimatedAlertDialog extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const AnimatedAlertDialog({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: duration,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeOutCubic,
        ),
        child: child,
      ),
    );
  }
}

// Usage helper class
class AlertDialogHelper {
  static Future<T?> showAlertDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: AlertDialogComponents.title(title),
        content: AlertDialogComponents.description(content),
        actions: [
          if (cancelText != null)
            AlertDialogComponents.cancel(
              text: cancelText,
              onPressed: onCancel ?? () => Navigator.pop(context),
            ),
          AlertDialogComponents.action(
            text: confirmText,
            onPressed: onConfirm ?? () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    return showAlertDialog<bool>(
      context: context,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: () => Navigator.pop(context, true),
      onCancel: () => Navigator.pop(context, false),
    );
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'OK',
  }) {
    return showAlertDialog<void>(
      context: context,
      title: title,
      content: content,
      confirmText: buttonText,
    );
  }

  static Future<void> showSuccessDialog({
    required BuildContext context,
    required String title,
    required String content,
    String buttonText = 'OK',
  }) {
    return showAlertDialog<void>(
      context: context,
      title: title,
      content: content,
      confirmText: buttonText,
    );
  }
}

// Custom overlay for alert dialog (similar to Radix UI portal)
class AlertDialogOverlay extends StatelessWidget {
  final Widget child;
  final bool dismissible;
  final Color? overlayColor;

  const AlertDialogOverlay({
    super.key,
    required this.child,
    this.dismissible = true,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Overlay
        if (dismissible)
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              color: overlayColor ?? Colors.black.withOpacity(0.5),
            ),
          ),
        // Dialog content
        Center(
          child: AnimatedAlertDialog(child: child),
        ),
      ],
    );
  }
}