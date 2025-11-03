import 'package:flutter/material.dart';
import 'dart:async'; // Add this import for Timer

class TooltipProvider extends InheritedWidget {
  final Duration delayDuration;

  const TooltipProvider({
    Key? key,
    this.delayDuration = Duration.zero,
    required Widget child,
  }) : super(key: key, child: child);

  static TooltipProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TooltipProvider>();
  }

  @override
  bool updateShouldNotify(TooltipProvider oldWidget) {
    return delayDuration != oldWidget.delayDuration;
  }
}

class Tooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration delayDuration;
  final TooltipTriggerMode triggerMode;
  final bool enableFeedback;
  final EdgeInsetsGeometry margin;
  final double verticalOffset;
  final Widget? preferBelow;

  const Tooltip({
    Key? key,
    required this.message,
    required this.child,
    this.delayDuration = Duration.zero,
    this.triggerMode = TooltipTriggerMode.tap,
    this.enableFeedback = true,
    this.margin = const EdgeInsets.all(16.0),
    this.verticalOffset = 24.0,
    this.preferBelow,
  }) : super(key: key);

  @override
  State<Tooltip> createState() => _TooltipState();
}

class _TooltipState extends State<Tooltip> {
  @override
  Widget build(BuildContext context) {
    final provider = TooltipProvider.of(context);
    final effectiveDelay = provider?.delayDuration ?? widget.delayDuration;

    // Flutter's built-in Tooltip doesn't support waitDuration or custom styling
    // We'll use our custom implementation instead
    return CustomTooltip(
      message: widget.message,
      delayDuration: effectiveDelay,
      child: widget.child,
    );
  }
}

class TooltipTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;

  const TooltipTrigger({
    Key? key,
    required this.child,
    this.onPressed,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onLongPress,
      child: child,
    );
  }
}

class TooltipContent extends StatelessWidget {
  final Widget child;
  final String? semanticLabel;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool excludeFromSemantics;
  final Decoration? decoration;
  final TextStyle? textStyle;

  const TooltipContent({
    Key? key,
    required this.child,
    this.semanticLabel,
    this.height = 32.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    this.excludeFromSemantics = false,
    this.decoration,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultDecoration = BoxDecoration(
      color: theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(6.0),
    );

    final defaultTextStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onPrimary,
      fontSize: 12.0,
    );

    return Container(
      decoration: decoration ?? defaultDecoration,
      padding: padding,
      constraints: BoxConstraints(minHeight: height),
      child: DefaultTextStyle(
        style: defaultTextStyle?.merge(textStyle) ?? const TextStyle(),
        child: child,
      ),
    );
  }
}

// Custom tooltip that mimics the Radix UI styling more closely
class CustomTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final Duration delayDuration;
  final TooltipSide side;
  final double sideOffset;
  final Widget Function(BuildContext context, Widget child)? contentBuilder;

  const CustomTooltip({
    Key? key,
    required this.child,
    required this.message,
    this.delayDuration = Duration.zero,
    this.side = TooltipSide.bottom,
    this.sideOffset = 0,
    this.contentBuilder,
  }) : super(key: key);

  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

enum TooltipSide { top, bottom, left, right }

class _CustomTooltipState extends State<CustomTooltip> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  final _layerLink = LayerLink();
  bool _isVisible = false;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hideTooltip();
    _delayTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _showTooltip() {
    if (_isVisible) return;

    _delayTimer?.cancel();
    _delayTimer = Timer(widget.delayDuration, () {
      if (!mounted) return;
      
      _isVisible = true;
      _animationController.forward();

      _overlayEntry = OverlayEntry(
        builder: (context) => _buildTooltipContent(),
      );

      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _hideTooltip() {
    _delayTimer?.cancel();
    if (!_isVisible) return;

    _isVisible = false;
    _animationController.reverse().then((value) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  Widget _buildTooltipContent() {
    final theme = Theme.of(context);
    
    // Calculate position based on side
    Offset offset;
    switch (widget.side) {
      case TooltipSide.top:
        offset = Offset(0, -20 - widget.sideOffset);
        break;
      case TooltipSide.bottom:
        offset = Offset(0, 20 + widget.sideOffset);
        break;
      case TooltipSide.left:
        offset = Offset(-20 - widget.sideOffset, 0);
        break;
      case TooltipSide.right:
        offset = Offset(20 + widget.sideOffset, 0);
        break;
    }

    return Positioned.fill(
      child: CompositedTransformFollower(
        link: _layerLink,
        showWhenUnlinked: false,
        offset: offset,
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: FadeTransition(
              opacity: _animationController,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
                ),
                child: _buildTooltipBox(theme),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltipBox(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        widget.message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _showTooltip(),
        onExit: (_) => _hideTooltip(),
        child: GestureDetector(
          onTapDown: (_) => _showTooltip(),
          onTapUp: (_) => _hideTooltip(),
          onTapCancel: _hideTooltip,
          onLongPress: _showTooltip,
          onLongPressEnd: (_) => _hideTooltip(),
          child: widget.child,
        ),
      ),
    );
  }
}

// Example usage
class TooltipExample extends StatelessWidget {
  const TooltipExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tooltip Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using custom tooltip with delay
            CustomTooltip(
              message: 'This is a custom tooltip with delay',
              delayDuration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue,
                child: const Text(
                  'Hover or tap me',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Using tooltip with provider
            TooltipProvider(
              delayDuration: const Duration(milliseconds: 1000),
              child: CustomTooltip(
                message: 'Tooltip with provider delay',
                side: TooltipSide.bottom,
                sideOffset: 8,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.green,
                  child: const Text(
                    'Provider Tooltip',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Different sides
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTooltip(
                  message: 'Top tooltip',
                  side: TooltipSide.top,
                  child: const Text('Top'),
                ),
                const SizedBox(width: 20),
                CustomTooltip(
                  message: 'Right tooltip',
                  side: TooltipSide.right,
                  child: const Text('Right'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}