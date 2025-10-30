import 'package:flutter/material.dart';

class ScrollArea extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? controller;
  final bool primary;
  final ScrollPhysics? physics;
  final EdgeInsets? padding;
  final bool? reverse;
  final String? restorationId;
  final Clip clipBehavior;
  final double? minWidth;
  final double? minHeight;
  final BoxDecoration? decoration;

  const ScrollArea({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.primary = false,
    this.physics,
    this.padding,
    this.reverse,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.minWidth,
    this.minHeight,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollView = _buildScrollView();
    
    return Container(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 0,
        minHeight: minHeight ?? 0,
      ),
      decoration: decoration,
      child: scrollView,
    );
  }

  Widget _buildScrollView() {
    if (scrollDirection == Axis.horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        primary: primary,
        physics: physics ?? const ClampingScrollPhysics(),
        padding: padding,
        reverse: reverse ?? false,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth ?? 0,
          ),
          child: child,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: controller,
      primary: primary,
      physics: physics ?? const ClampingScrollPhysics(),
      padding: padding,
      reverse: reverse ?? false,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight ?? 0,
        ),
        child: child,
      ),
    );
  }
}

class CustomScrollBar extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final Axis direction;
  final bool thumbVisibility;
  final Color? thumbColor;
  final Color? trackColor;
  final double thickness;
  final Radius? radius;
  final bool interactive;
  final ScrollNotificationPredicate? notificationPredicate;

  const CustomScrollBar({
    Key? key,
    required this.child,
    this.controller,
    this.direction = Axis.vertical,
    this.thumbVisibility = false,
    this.thumbColor,
    this.trackColor,
    this.thickness = 8.0,
    this.radius,
    this.interactive = true,
    this.notificationPredicate,
  }) : super(key: key);

  @override
  State<CustomScrollBar> createState() => _CustomScrollBarState();
}

class _CustomScrollBarState extends State<CustomScrollBar> {
  final _scrollController = ScrollController();
  bool _showScrollbar = false;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    final controller = widget.controller ?? _scrollController;
    
    controller.addListener(() {
      final hasScrollableContent = controller.position.maxScrollExtent > 0;
      final isScrolling = controller.position.isScrollingNotifier.value;
      
      if (hasScrollableContent && isScrolling) {
        if (!_showScrollbar) {
          setState(() => _showScrollbar = true);
        }
      } else {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && !controller.position.isScrollingNotifier.value) {
            setState(() => _showScrollbar = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller ?? _scrollController;
    
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        scrollbars: true,
      ),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: widget.thumbVisibility || _showScrollbar,
        trackVisibility: false,
        thickness: widget.thickness,
        radius: widget.radius ?? const Radius.circular(4),
        interactive: widget.interactive,
        notificationPredicate: widget.notificationPredicate ??
            (notification) => notification.depth == 0,
        child: _buildScrollContent(controller),
      ),
    );
  }

  Widget _buildScrollContent(ScrollController controller) {
    return widget.direction == Axis.horizontal
        ? SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            child: widget.child,
          )
        : SingleChildScrollView(
            controller: controller,
            scrollDirection: Axis.vertical,
            child: widget.child,
          );
  }
}

// Enhanced ScrollArea with built-in scrollbar
class ScrollAreaWithBar extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? controller;
  final bool showScrollBar;
  final double scrollBarThickness;
  final Color? scrollBarColor;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final BoxDecoration? decoration;

  const ScrollAreaWithBar({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.showScrollBar = true,
    this.scrollBarThickness = 6.0,
    this.scrollBarColor,
    this.padding,
    this.physics,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget scrollContent = Container(
      decoration: decoration,
      padding: padding,
      child: child,
    );

    if (!showScrollBar) {
      return SingleChildScrollView(
        controller: controller,
        scrollDirection: scrollDirection,
        physics: physics,
        child: scrollContent,
      );
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      trackVisibility: false,
      thickness: scrollBarThickness,
      radius: const Radius.circular(3),
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: scrollDirection,
        physics: physics,
        child: scrollContent,
      ),
    );
  }
}

// Simple alternative using RawScrollbar for more control
class RawCustomScrollBar extends StatefulWidget {
  final Widget child;
  final ScrollController? controller;
  final Color? thumbColor;
  final double thickness;

  const RawCustomScrollBar({
    Key? key,
    required this.child,
    this.controller,
    this.thumbColor,
    this.thickness = 8.0,
  }) : super(key: key);

  @override
  State<RawCustomScrollBar> createState() => _RawCustomScrollBarState();
}

class _RawCustomScrollBarState extends State<RawCustomScrollBar> {
  final _scrollController = ScrollController();
  bool _showScrollbar = false;

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _setupScrollListener() {
    final controller = widget.controller ?? _scrollController;
    
    controller.addListener(() {
      final hasScrollableContent = controller.position.maxScrollExtent > 0;
      final isScrolling = controller.position.isScrollingNotifier.value;
      
      if (hasScrollableContent && isScrolling) {
        if (!_showScrollbar) {
          setState(() => _showScrollbar = true);
        }
      } else {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && !controller.position.isScrollingNotifier.value) {
            setState(() => _showScrollbar = false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final thumbColor = widget.thumbColor ?? theme.colorScheme.outline.withOpacity(0.5);
    final controller = widget.controller ?? _scrollController;

    return RawScrollbar(
      controller: controller,
      thumbVisibility: _showScrollbar,
      thickness: widget.thickness,
      thumbColor: thumbColor,
      child: widget.child,
    );
  }
}

// Usage examples:
class ScrollAreaExamples extends StatelessWidget {
  const ScrollAreaExamples({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scroll Area Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Basic ScrollArea
            const Text('Basic ScrollArea:'),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ScrollArea(
                child: Column(
                  children: List.generate(
                    20,
                    (index) => ListTile(
                      title: Text('Item ${index + 1}'),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // ScrollArea with custom scrollbar
            const Text('ScrollArea with Custom Scrollbar:'),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ScrollAreaWithBar(
                scrollBarThickness: 8,
                child: Row(
                  children: List.generate(
                    15,
                    (index) => Container(
                      width: 100,
                      margin: const EdgeInsets.all(8),
                      color: Colors.blue[100],
                      child: Center(child: Text('Card ${index + 1}')),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Horizontal ScrollArea
            const Text('Horizontal ScrollArea:'),
            const SizedBox(height: 8),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ScrollArea(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    10,
                    (index) => Container(
                      width: 120,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text('Item ${index + 1}')),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Advanced scroll area with fade effect
class FadeScrollArea extends StatelessWidget {
  final Widget child;
  final Axis scrollDirection;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final double fadeHeight;
  final Color fadeColor;

  const FadeScrollArea({
    Key? key,
    required this.child,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.padding,
    this.fadeHeight = 20.0,
    this.fadeColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: controller,
          scrollDirection: scrollDirection,
          padding: padding,
          child: child,
        ),
        
        // Top fade
        if (scrollDirection == Axis.vertical)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: fadeHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    fadeColor.withOpacity(0.8),
                    fadeColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        
        // Bottom fade
        if (scrollDirection == Axis.vertical)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: fadeHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    fadeColor.withOpacity(0.0),
                    fadeColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
      ],
    );
  }
}