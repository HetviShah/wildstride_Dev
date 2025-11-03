import 'package:flutter/material.dart';
import 'dart:async'; // Add this import

class HoverCard extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final Duration openDelay;
  final Duration closeDelay;
  final bool open;
  final VoidCallback? onOpenChange;
  final AlignmentGeometry alignment;
  final Offset offset;
  final double? width;

  const HoverCard({
    super.key,
    required this.trigger,
    required this.content,
    this.openDelay = Duration.zero,
    this.closeDelay = const Duration(milliseconds: 300),
    this.open = false,
    this.onOpenChange,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.width,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  Timer? _openTimer;
  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.open;
  }

  @override
  void didUpdateWidget(HoverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _scheduleOpen();
      } else {
        _scheduleClose();
      }
    }
  }

  void _scheduleOpen() {
    _closeTimer?.cancel();
    _openTimer = Timer(widget.openDelay, _showCard);
  }

  void _scheduleClose() {
    _openTimer?.cancel();
    _closeTimer = Timer(widget.closeDelay, _hideCard);
  }

  void _showCard() {
    if (_isOpen) return;

    setState(() {
      _isOpen = true;
    });

    _overlayEntry = OverlayEntry(
      builder: (context) => _HoverCardOverlay(
        triggerKey: _triggerKey,
        content: widget.content,
        alignment: widget.alignment,
        offset: widget.offset,
        width: widget.width,
        onClose: _hideCard,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    widget.onOpenChange?.call();
  }

  void _hideCard() {
    if (!_isOpen) return;

    setState(() {
      _isOpen = false;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onOpenChange?.call();
  }

  void _handleHover(PointerEvent details) {
    _scheduleOpen();
  }

  void _handleHoverExit(PointerEvent details) {
    _scheduleClose();
  }

  @override
  void dispose() {
    _openTimer?.cancel();
    _closeTimer?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _handleHover,
      onExit: _handleHoverExit,
      child: KeyedSubtree(
        key: _triggerKey,
        child: widget.trigger,
      ),
    );
  }
}

class HoverCardTrigger extends StatelessWidget {
  final Widget child;

  const HoverCardTrigger({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class HoverCardContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final double borderRadius;
  final BoxShadow? shadow;
  final double? width;
  final double? maxWidth;

  const HoverCardContent({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 8,
    this.shadow,
    this.width,
    this.maxWidth = 256,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      constraints: BoxConstraints(maxWidth: maxWidth ?? 256),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.background,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          shadow ?? BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _HoverCardOverlay extends StatefulWidget {
  final GlobalKey triggerKey;
  final Widget content;
  final AlignmentGeometry alignment;
  final Offset offset;
  final double? width;
  final VoidCallback onClose;

  const _HoverCardOverlay({
    required this.triggerKey,
    required this.content,
    required this.alignment,
    required this.offset,
    required this.width,
    required this.onClose,
  });

  @override
  State<_HoverCardOverlay> createState() => _HoverCardOverlayState();
}

class _HoverCardOverlayState extends State<_HoverCardOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final renderBox = widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return const SizedBox.shrink();

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return Stack(
      children: [
        // Background overlay (transparent but captures mouse events)
        Positioned.fill(
          child: GestureDetector(
            onTap: () {}, // Empty to prevent closing on click
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),

        // Hover card content
        Positioned(
          left: offset.dx + widget.offset.dx,
          top: offset.dy + size.height + widget.offset.dy,
          child: MouseRegion(
            onEnter: (_) {}, // Keep card open when hovering over content
            onExit: (_) => widget.onClose(),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Material(
                  color: Colors.transparent,
                  child: widget.content,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Alternative simpler version using Tooltip for basic cases
class SimpleHoverCard extends StatelessWidget {
  final Widget child;
  final String message;
  final Duration waitDuration;
  final bool preferBelow;

  const SimpleHoverCard({
    super.key,
    required this.child,
    required this.message,
    this.waitDuration = const Duration(milliseconds: 500),
    this.preferBelow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      preferBelow: preferBelow,
      child: child,
    );
  }
}

// Rich hover card with custom content
class RichHoverCard extends StatelessWidget {
  final Widget trigger;
  final Widget content;
  final Duration delay;

  const RichHoverCard({
    super.key,
    required this.trigger,
    required this.content,
    this.delay = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      trigger: trigger,
      content: content,
      openDelay: delay,
    );
  }
}