import 'package:flutter/material.dart';

class Collapsible extends StatefulWidget {
  final Widget? child;
  final List<Widget>? children;
  final bool defaultOpen;
  final bool? open;
  final Function(bool)? onOpenChange;
  final Duration duration;
  final Curve curve;

  const Collapsible({
    super.key,
    this.child,
    this.children,
    this.defaultOpen = false,
    this.open,
    this.onOpenChange,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  }) : assert(child == null || children == null, 'Cannot provide both child and children');

  @override
  State<Collapsible> createState() => _CollapsibleState();
}

class _CollapsibleState extends State<Collapsible> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool get _isOpen => widget.open ?? (_controller.value > 0.5);
  bool get _isControlled => widget.open != null;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
      value: widget.open ?? widget.defaultOpen ? 1.0 : 0.0,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
  }

  @override
  void didUpdateWidget(Collapsible oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.open != oldWidget.open && _isControlled) {
      if (widget.open == true) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _toggle() {
    if (_isControlled) {
      widget.onOpenChange?.call(!_isOpen);
    } else {
      if (_isOpen) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      widget.onOpenChange?.call(!_isOpen);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.child != null) widget.child!,
        if (widget.children != null) ...widget.children!,
      ],
    );
  }
}

class CollapsibleTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool asChild;

  const CollapsibleTrigger({
    super.key,
    required this.child,
    this.onTap,
    this.asChild = false,
  });

  @override
  Widget build(BuildContext context) {
    final collapsibleState = context.findAncestorStateOfType<_CollapsibleState>();
    
    if (collapsibleState == null) {
      throw FlutterError('CollapsibleTrigger must be used within a Collapsible widget');
    }

    if (asChild) {
      return child;
    }

    return GestureDetector(
      onTap: onTap ?? collapsibleState._toggle,
      child: child,
    );
  }
}

class CollapsibleContent extends StatelessWidget {
  final Widget child;
  final bool maintainState;
  final EdgeInsetsGeometry? padding;

  const CollapsibleContent({
    super.key,
    required this.child,
    this.maintainState = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final collapsibleState = context.findAncestorStateOfType<_CollapsibleState>();
    
    if (collapsibleState == null) {
      throw FlutterError('CollapsibleContent must be used within a Collapsible widget');
    }

    return AnimatedBuilder(
      animation: collapsibleState._animation,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: collapsibleState._animation,
          child: Opacity(
            opacity: collapsibleState._animation.value,
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        );
      },
      child: maintainState || collapsibleState._isOpen ? child : null,
    );
  }
}

// Alternative: Simpler version using AnimatedContainer
class SimpleCollapsible extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final bool initiallyExpanded;
  final Duration duration;

  const SimpleCollapsible({
    super.key,
    required this.trigger,
    required this.content,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<SimpleCollapsible> createState() => _SimpleCollapsibleState();
}

class _SimpleCollapsibleState extends State<SimpleCollapsible> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Trigger
        GestureDetector(
          onTap: _toggleExpanded,
          child: widget.trigger,
        ),
        
        // Content
        AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeInOut,
          height: _isExpanded ? null : 0,
          child: AnimatedOpacity(
            duration: widget.duration,
            opacity: _isExpanded ? 1.0 : 0.0,
            child: widget.content,
          ),
        ),
      ],
    );
  }
}