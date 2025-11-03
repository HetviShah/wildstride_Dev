import 'package:flutter/material.dart';

class Dialog extends StatefulWidget {
  final Widget? child;
  final List<Widget>? children;
  final bool open;
  final VoidCallback? onOpenChange;
  final bool dismissible;
  final Color? overlayColor;
  final Duration animationDuration;
  final Curve animationCurve;

  const Dialog({
    super.key,
    this.child,
    this.children,
    this.open = false,
    this.onOpenChange,
    this.dismissible = true,
    this.overlayColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  State<Dialog> createState() => _DialogState();
}

class _DialogState extends State<Dialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  bool get _isOpen => widget.open;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    if (_isOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(Dialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (widget.dismissible) {
      widget.onOpenChange?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOpen && _controller.value == 0.0) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Overlay
        if (_isOpen || _controller.value > 0.0)
          Positioned.fill(
            child: GestureDetector(
              onTap: _handleClose,
              child: Container(
                color: widget.overlayColor ?? Colors.black54,
              ),
            ),
          ),

        // Dialog content
        if (_isOpen || _controller.value > 0.0)
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Material(
                color: Colors.transparent,
                child: widget.child ?? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.children ?? [],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class DialogTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const DialogTrigger({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
}

class DialogContent extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final double? width;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double borderRadius;
  final bool showCloseButton;

  const DialogContent({
    super.key,
    this.child,
    this.children,
    this.width,
    this.maxWidth = 500,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 12,
    this.showCloseButton = true,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      constraints: BoxConstraints(maxWidth: maxWidth ?? 500),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.background,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: padding ?? const EdgeInsets.all(24),
            child: child ?? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children ?? [],
            ),
          ),
          
          if (showCloseButton)
            Positioned(
              top: 16,
              right: 16,
              child: DialogClose(
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // Close logic handled by parent Dialog
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DialogClose extends StatelessWidget {
  final Widget child;

  const DialogClose({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DialogHeader extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsetsGeometry? padding;

  const DialogHeader({
    super.key,
    this.child,
    this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.padding,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(bottom: 16),
      child: child ?? Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: children ?? [],
      ),
    );
  }
}

class DialogFooter extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsetsGeometry? padding;

  const DialogFooter({
    super.key,
    this.child,
    this.children,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.padding,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.only(top: 24),
      child: child ?? Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (children != null) ...children!,
        ],
      ),
    );
  }
}

class DialogTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const DialogTitle({
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
      textAlign: textAlign,
      style: style ?? theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class DialogDescription extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;

  const DialogDescription({
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
      textAlign: textAlign,
      maxLines: maxLines,
      style: style ?? theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
    );
  }
}

class DialogOverlay extends StatelessWidget {
  final Color? color;
  final bool dismissible;
  final VoidCallback? onDismiss;

  const DialogOverlay({
    super.key,
    this.color,
    this.dismissible = true,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissible ? onDismiss : null,
      child: Container(
        color: color ?? Colors.black54,
      ),
    );
  }
}

// Helper class for managing dialog state
class DialogController extends ChangeNotifier {
  bool _isOpen = false;

  bool get isOpen => _isOpen;

  void open() {
    if (!_isOpen) {
      _isOpen = true;
      notifyListeners();
    }
  }

  void close() {
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }

  void toggle() {
    _isOpen ? close() : open();
  }
}