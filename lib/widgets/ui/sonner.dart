import 'package:flutter/material.dart';

// Toast types enum
enum ToastType {
  success,
  error,
  warning,
  info,
  loading,
}

// Toast position enum
enum ToastPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

// Toast data class
class ToastData {
  final String id;
  final String title;
  final String? description;
  final ToastType type;
  final Duration duration;
  final Widget? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  ToastData({
    required this.id,
    required this.title,
    this.description,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 4),
    this.icon,
    this.onAction,
    this.actionLabel,
  });
}

// Toast widget
class Toast extends StatelessWidget {
  final ToastData toast;
  final VoidCallback onDismiss;
  final ThemeData theme;

  const Toast({
    super.key,
    required this.toast,
    required this.onDismiss,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Get colors based on toast type
    final (Color backgroundColor, Color borderColor, Color textColor) = 
        _getToastColors(colorScheme, toast.type);

    return Dismissible(
      key: Key(toast.id),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) => onDismiss(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        color: backgroundColor,
        surfaceTintColor: backgroundColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              if (toast.icon != null || _getDefaultIcon(toast.type) != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconTheme(
                    data: IconThemeData(
                      color: textColor,
                      size: 16,
                    ),
                    child: toast.icon ?? _getDefaultIcon(toast.type)!,
                  ),
                ),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      toast.title,
                      style: textTheme.bodyMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (toast.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        toast.description!,
                        style: textTheme.bodySmall?.copyWith(
                          color: textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Action button
              if (toast.onAction != null && toast.actionLabel != null) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: toast.onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: textColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    toast.actionLabel!,
                    style: textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              
              // Close button
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close, size: 16, color: textColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (Color, Color, Color) _getToastColors(ColorScheme colorScheme, ToastType type) {
    return switch (type) {
      ToastType.success => (
          colorScheme.surface,
          colorScheme.primary.withOpacity(0.2),
          colorScheme.onSurface,
        ),
      ToastType.error => (
          colorScheme.errorContainer,
          colorScheme.error.withOpacity(0.2),
          colorScheme.onErrorContainer,
        ),
      ToastType.warning => (
          colorScheme.surfaceVariant,
          colorScheme.secondary.withOpacity(0.2),
          colorScheme.onSurfaceVariant,
        ),
      ToastType.info => (
          colorScheme.surface,
          colorScheme.outline.withOpacity(0.2),
          colorScheme.onSurface,
        ),
      ToastType.loading => (
          colorScheme.surface,
          colorScheme.primary.withOpacity(0.2),
          colorScheme.onSurface,
        ),
    };
  }

  Widget? _getDefaultIcon(ToastType type) {
    return switch (type) {
      ToastType.success => const Icon(Icons.check_circle),
      ToastType.error => const Icon(Icons.error),
      ToastType.warning => const Icon(Icons.warning),
      ToastType.info => const Icon(Icons.info),
      ToastType.loading => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
    };
  }
}

// Toaster controller
class ToasterController extends ChangeNotifier {
  final List<ToastData> _toasts = [];

  List<ToastData> get toasts => _toasts;

  void addToast(ToastData toast) {
    _toasts.add(toast);
    notifyListeners();
    
    // Auto-dismiss after duration
    if (toast.duration != Duration.zero) {
      Future.delayed(toast.duration, () {
        removeToast(toast.id);
      });
    }
  }

  void removeToast(String id) {
    _toasts.removeWhere((toast) => toast.id == id);
    notifyListeners();
  }

  void clearAll() {
    _toasts.clear();
    notifyListeners();
  }
}

// Main Toaster widget
class Toaster extends StatefulWidget {
  final ToastPosition position;
  final Duration duration;
  final bool richColors;
  final bool closeButton;
  final ThemeData? theme;
  final Widget child; // Fixed: Added required child parameter

  const Toaster({
    super.key,
    this.position = ToastPosition.topRight,
    this.duration = const Duration(seconds: 4),
    this.richColors = true,
    this.closeButton = true,
    this.theme,
    required this.child, // Fixed: Made child required
  });

  static ToasterController of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<ToasterInherited>();
    if (inherited == null) {
      throw FlutterError('Toaster must be used within a ToasterInherited widget');
    }
    return inherited.controller;
  }

  @override
  State<Toaster> createState() => _ToasterState();
}

class _ToasterState extends State<Toaster> {
  final ToasterController _controller = ToasterController();

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? Theme.of(context);

    return ToasterInherited(
      controller: _controller,
      child: Stack(
        children: [
          // Your app content
          widget.child,
          
          // Toast overlay
          Positioned.fill(
            child: _buildToasts(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildToasts(ThemeData theme) {
    return Align(
      alignment: _getAlignment(widget.position),
      child: Padding(
        padding: _getPadding(widget.position),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.position.toString().contains('Top')) ...[
              _buildToastList(theme),
              const Spacer(),
            ] else ...[
              const Spacer(),
              _buildToastList(theme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToastList(ThemeData theme) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _controller.toasts.map((toast) => Toast(
          toast: toast,
          onDismiss: () => _controller.removeToast(toast.id),
          theme: theme,
        )).toList(),
      ),
    );
  }

  Alignment _getAlignment(ToastPosition position) {
    return switch (position) {
      ToastPosition.topLeft => Alignment.topLeft,
      ToastPosition.topCenter => Alignment.topCenter,
      ToastPosition.topRight => Alignment.topRight,
      ToastPosition.bottomLeft => Alignment.bottomLeft,
      ToastPosition.bottomCenter => Alignment.bottomCenter,
      ToastPosition.bottomRight => Alignment.bottomRight,
    };
  }

  EdgeInsets _getPadding(ToastPosition position) {
    // Fixed: Removed unused padding variable and simplified
    return switch (position) {
      ToastPosition.topLeft => const EdgeInsets.only(top: 16, left: 16),
      ToastPosition.topCenter => const EdgeInsets.only(top: 16),
      ToastPosition.topRight => const EdgeInsets.only(top: 16, right: 16),
      ToastPosition.bottomLeft => const EdgeInsets.only(bottom: 16, left: 16),
      ToastPosition.bottomCenter => const EdgeInsets.only(bottom: 16),
      ToastPosition.bottomRight => const EdgeInsets.only(bottom: 16, right: 16),
    };
  }
}

// Inherited widget for controller access
class ToasterInherited extends InheritedWidget {
  final ToasterController controller;

  const ToasterInherited({
    super.key,
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(ToasterInherited oldWidget) {
    return controller != oldWidget.controller;
  }
}

// Toast utility functions
class ToastUtils {
  static void showToast({
    required BuildContext context,
    required String title,
    String? description,
    ToastType type = ToastType.info,
    Duration? duration,
    Widget? icon,
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final controller = Toaster.of(context);
    final toast = ToastData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      type: type,
      duration: duration ?? const Duration(seconds: 4),
      icon: icon,
      onAction: onAction,
      actionLabel: actionLabel,
    );
    controller.addToast(toast);
  }

  static void success({
    required BuildContext context,
    required String title,
    String? description,
    Duration? duration,
  }) {
    showToast(
      context: context,
      title: title,
      description: description,
      type: ToastType.success,
      duration: duration,
    );
  }

  static void error({
    required BuildContext context,
    required String title,
    String? description,
    Duration? duration,
  }) {
    showToast(
      context: context,
      title: title,
      description: description,
      type: ToastType.error,
      duration: duration,
    );
  }

  static void warning({
    required BuildContext context,
    required String title,
    String? description,
    Duration? duration,
  }) {
    showToast(
      context: context,
      title: title,
      description: description,
      type: ToastType.warning,
      duration: duration,
    );
  }

  static void info({
    required BuildContext context,
    required String title,
    String? description,
    Duration? duration,
  }) {
    showToast(
      context: context,
      title: title,
      description: description,
      type: ToastType.info,
      duration: duration,
    );
  }

  static void loading({
    required BuildContext context,
    required String title,
    String? description,
  }) {
    showToast(
      context: context,
      title: title,
      description: description,
      type: ToastType.loading,
      duration: Duration.zero, // Loading toasts don't auto-dismiss
    );
  }
}

// Example usage
class ToasterExample extends StatelessWidget {
  const ToasterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toaster Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => ToastUtils.success(
                context: context,
                title: 'Success!',
                description: 'Your action was completed successfully.',
              ),
              child: const Text('Show Success Toast'),
            ),
            ElevatedButton(
              onPressed: () => ToastUtils.error(
                context: context,
                title: 'Error!',
                description: 'Something went wrong.',
              ),
              child: const Text('Show Error Toast'),
            ),
            ElevatedButton(
              onPressed: () => ToastUtils.info(
                context: context,
                title: 'Information',
                description: 'Here is some important information.',
              ),
              child: const Text('Show Info Toast'),
            ),
            ElevatedButton(
              onPressed: () => ToastUtils.loading(
                context: context,
                title: 'Loading...',
                description: 'Please wait while we process your request.',
              ),
              child: const Text('Show Loading Toast'),
            ),
          ],
        ),
      ),
    );
  }
}

// Full app integration example
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toaster Example',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Toaster(
        position: ToastPosition.topRight,
        child: ToasterExample(), // Fixed: Now child is properly passed
      ),
    );
  }
}