import 'package:flutter/material.dart';

enum DrawerDirection {
  top,
  bottom,
  left,
  right,
}

class Drawer extends StatefulWidget {
  final Widget? child;
  final List<Widget>? children;
  final bool open;
  final VoidCallback? onOpenChange;
  final DrawerDirection direction;
  final bool dismissible;
  final Color? overlayColor;
  final Duration animationDuration;
  final Curve animationCurve;
  final double maxSize;

  const Drawer({
    super.key,
    this.child,
    this.children,
    this.open = false,
    this.onOpenChange,
    this.direction = DrawerDirection.right,
    this.dismissible = true,
    this.overlayColor,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.maxSize = 0.8,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  State<Drawer> createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

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
    
    _slideAnimation = Tween<Offset>(
      begin: _getInitialOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.animationCurve));

    if (_isOpen) {
      _controller.forward();
    }
  }

  Offset _getInitialOffset() {
    switch (widget.direction) {
      case DrawerDirection.top:
        return const Offset(0, -1);
      case DrawerDirection.bottom:
        return const Offset(0, 1);
      case DrawerDirection.left:
        return const Offset(-1, 0);
      case DrawerDirection.right:
        return const Offset(1, 0);
    }
  }

  @override
  void didUpdateWidget(Drawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    
    if (widget.direction != oldWidget.direction) {
      _slideAnimation = Tween<Offset>(
        begin: _getInitialOffset(),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.animationCurve));
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
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  color: widget.overlayColor ?? Colors.black54,
                ),
              ),
            ),
          ),

        // Drawer content
        if (_isOpen || _controller.value > 0.0)
          Positioned.fill(
            child: SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: _getAlignment(),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: _getMaxWidth(context),
                    maxHeight: _getMaxHeight(context),
                  ),
                  child: Material(
                    color: Theme.of(context).colorScheme.background,
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Alignment _getAlignment() {
    switch (widget.direction) {
      case DrawerDirection.top:
        return Alignment.topCenter;
      case DrawerDirection.bottom:
        return Alignment.bottomCenter;
      case DrawerDirection.left:
        return Alignment.centerLeft;
      case DrawerDirection.right:
        return Alignment.centerRight;
    }
  }

  double _getMaxWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    switch (widget.direction) {
      case DrawerDirection.top:
      case DrawerDirection.bottom:
        return screenWidth;
      case DrawerDirection.left:
      case DrawerDirection.right:
        return screenWidth * widget.maxSize;
    }
  }

  double _getMaxHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    switch (widget.direction) {
      case DrawerDirection.top:
      case DrawerDirection.bottom:
        return screenHeight * widget.maxSize;
      case DrawerDirection.left:
      case DrawerDirection.right:
        return screenHeight;
    }
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _getCrossAxisAlignment(),
      children: [
        // Handle for bottom drawer
        if (widget.direction == DrawerDirection.bottom)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        
        Expanded(
          child: widget.child ?? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: _getCrossAxisAlignment(),
            children: widget.children ?? [],
          ),
        ),
      ],
    );
  }

  CrossAxisAlignment _getCrossAxisAlignment() {
    switch (widget.direction) {
      case DrawerDirection.top:
      case DrawerDirection.bottom:
        return CrossAxisAlignment.center;
      case DrawerDirection.left:
      case DrawerDirection.right:
        return CrossAxisAlignment.start;
    }
  }
}

class DrawerTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const DrawerTrigger({
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

class DrawerClose extends StatelessWidget {
  final Widget child;

  const DrawerClose({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DrawerContent extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;

  const DrawerContent({
    super.key,
    this.child,
    this.children,
    this.padding,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child ?? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children ?? [],
        ),
      ),
    );
  }
}

class DrawerHeader extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;

  const DrawerHeader({
    super.key,
    this.child,
    this.children,
    this.padding,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: child ?? Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children ?? [],
      ),
    );
  }
}

class DrawerFooter extends StatelessWidget {
  final Widget? child;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;

  const DrawerFooter({
    super.key,
    this.child,
    this.children,
    this.padding,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: child ?? Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children ?? [],
      ),
    );
  }
}

class DrawerTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const DrawerTitle({
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

class DrawerDescription extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;

  const DrawerDescription({
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

class DrawerOverlay extends StatelessWidget {
  final Color? color;
  final bool dismissible;
  final VoidCallback? onDismiss;

  const DrawerOverlay({
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

// Helper class for managing drawer state
class DrawerController extends ChangeNotifier {
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