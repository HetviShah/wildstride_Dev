import 'package:flutter/material.dart';

// Utility function similar to cn
String cn(String baseClass, [String? additionalClasses]) {
  if (additionalClasses == null || additionalClasses.isEmpty) {
    return baseClass;
  }
  return '$baseClass $additionalClasses';
}

// Main Popover widget (equivalent to PopoverPrimitive.Root)
class Popover extends StatefulWidget {
  final Widget child;
  final bool open;
  final VoidCallback? onOpenChange;
  final Widget? trigger;
  final Widget? content;
  final PopoverAlignment align;
  final double sideOffset;
  final PopoverSide preferredSide;

  const Popover({
    super.key,
    required this.child,
    this.open = false,
    this.onOpenChange,
    this.trigger,
    this.content,
    this.align = PopoverAlignment.center,
    this.sideOffset = 4,
    this.preferredSide = PopoverSide.bottom,
  });

  @override
  State<Popover> createState() => _PopoverState();
}

class _PopoverState extends State<Popover> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;
  final GlobalKey _triggerKey = GlobalKey();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _isOpen = widget.open;
  }

  @override
  void didUpdateWidget(Popover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      _isOpen ? _openPopover() : _closePopover();
    }
  }

  void _openPopover() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => _PopoverContent(
        animationController: _animationController,
        triggerKey: _triggerKey,
        align: widget.align,
        sideOffset: widget.sideOffset,
        preferredSide: widget.preferredSide,
        child: widget.content ?? const SizedBox(),
        onClose: _closePopover,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    widget.onOpenChange?.call();
  }

  void _closePopover() {
    if (_overlayEntry == null) return;

    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      widget.onOpenChange?.call();
    });
  }

  void _togglePopover() {
    setState(() {
      _isOpen = !_isOpen;
    });
    if (_isOpen) {
      _openPopover();
    } else {
      _closePopover();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _triggerKey,
      onTap: _togglePopover,
      child: widget.child,
    );
  }
}

// Popover alignment enum
enum PopoverAlignment {
  start,
  center,
  end,
}

// Popover side enum
enum PopoverSide {
  top,
  bottom,
  left,
  right,
}

// Popover Content widget with animations
class _PopoverContent extends StatefulWidget {
  final AnimationController animationController;
  final GlobalKey triggerKey;
  final PopoverAlignment align;
  final double sideOffset;
  final PopoverSide preferredSide;
  final Widget child;
  final VoidCallback onClose;

  const _PopoverContent({
    required this.animationController,
    required this.triggerKey,
    required this.align,
    required this.sideOffset,
    required this.preferredSide,
    required this.child,
    required this.onClose,
  });

  @override
  State<_PopoverContent> createState() => _PopoverContentState();
}

class _PopoverContentState extends State<_PopoverContent> {
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _scaleAnimation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeOutBack,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final RenderBox? triggerRenderBox = 
        widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
    
    if (triggerRenderBox == null) {
      return const SizedBox();
    }

    final offset = triggerRenderBox.localToGlobal(Offset.zero);
    final size = triggerRenderBox.size;

    return Stack(
      children: [
        // Backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        
        // Positioned popover content
        Positioned(
          left: _calculateLeft(offset, size),
          top: _calculateTop(offset, size),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 288, // w-72 equivalent (72 * 4 = 288)
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateLeft(Offset offset, Size size) {
    switch (widget.preferredSide) {
      case PopoverSide.left:
        return offset.dx - 288 - widget.sideOffset;
      case PopoverSide.right:
        return offset.dx + size.width + widget.sideOffset;
      case PopoverSide.top:
      case PopoverSide.bottom:
        return _calculateHorizontalAlignment(offset, size);
    }
  }

  double _calculateTop(Offset offset, Size size) {
    switch (widget.preferredSide) {
      case PopoverSide.top:
        return offset.dy - widget.sideOffset;
      case PopoverSide.bottom:
        return offset.dy + size.height + widget.sideOffset;
      case PopoverSide.left:
      case PopoverSide.right:
        return _calculateVerticalAlignment(offset, size);
    }
  }

  double _calculateHorizontalAlignment(Offset offset, Size size) {
    switch (widget.align) {
      case PopoverAlignment.start:
        return offset.dx;
      case PopoverAlignment.center:
        return offset.dx + (size.width / 2) - (288 / 2);
      case PopoverAlignment.end:
        return offset.dx + size.width - 288;
    }
  }

  double _calculateVerticalAlignment(Offset offset, Size size) {
    switch (widget.align) {
      case PopoverAlignment.start:
        return offset.dy;
      case PopoverAlignment.center:
        return offset.dy + (size.height / 2);
      case PopoverAlignment.end:
        return offset.dy + size.height;
    }
  }
}

// Simplified Popover components for more Flutter-idiomatic usage

/// A simpler popover implementation using Flutter's built-in components
class SimplePopover extends StatelessWidget {
  final Widget trigger;
  final Widget content;
  final PopoverAlignment align;
  final double sideOffset;
  final PopoverSide preferredSide;

  const SimplePopover({
    super.key,
    required this.trigger,
    required this.content,
    this.align = PopoverAlignment.center,
    this.sideOffset = 4,
    this.preferredSide = PopoverSide.bottom,
  });

  @override
  Widget build(BuildContext context) {
    // Use the main Popover widget instead of non-existent PopoverMenuButton
    return Popover(
      align: align,
      sideOffset: sideOffset,
      preferredSide: preferredSide,
      content: content,
      child: trigger,
    );
  }
}

/// Alternative using Flutter's built-in PopupMenuButton with custom styling
class StyledPopover extends StatelessWidget {
  final Widget trigger;
  final Widget content;
  final double width;

  const StyledPopover({
    super.key,
    required this.trigger,
    required this.content,
    this.width = 288,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: SizedBox(
            width: width,
            child: content,
          ),
        ),
      ],
      child: trigger,
    );
  }
}

/// Custom popover using Overlay for more control
class CustomPopover extends StatefulWidget {
  final Widget Function(void Function() close) builder;
  final Widget child;

  const CustomPopover({
    super.key,
    required this.builder,
    required this.child,
  });

  @override
  State<CustomPopover> createState() => _CustomPopoverState();
}

class _CustomPopoverState extends State<CustomPopover> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showPopover() {
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _hidePopover,
        behavior: HitTestBehavior.translucent,
        child: Material(
          color: Colors.transparent,
          child: CompositedTransformFollower(
            link: _layerLink,
            followerAnchor: Alignment.topCenter,
            targetAnchor: Alignment.bottomCenter,
            offset: const Offset(0, 8),
            child: widget.builder(_hidePopover),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hidePopover() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hidePopover();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _showPopover,
        child: widget.child,
      ),
    );
  }
}

// Usage Examples
class PopoverExample extends StatelessWidget {
  const PopoverExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using the main Popover component
            Popover(
              content: Container(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Popover Content'),
                    SizedBox(height: 8),
                    Text('This is a popover with animations.'),
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Open Popover',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Using the simplified version
            SimplePopover(
              content: Container(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Simple Popover'),
                    SizedBox(height: 8),
                    Text('Using the simplified popover component.'),
                  ],
                ),
              ),
              trigger: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Simple Popover',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Using styled popover
            StyledPopover(
              content: Container(
                padding: const EdgeInsets.all(16),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Styled Popover'),
                    SizedBox(height: 8),
                    Text('Using Flutter\'s built-in components.'),
                  ],
                ),
              ),
              trigger: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Styled Popover',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Using custom popover with overlay
            CustomPopover(
              builder: (close) => Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Custom Popover'),
                      SizedBox(height: 8),
                      Text('Using Overlay API for precise positioning.'),
                    ],
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Custom Popover',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}