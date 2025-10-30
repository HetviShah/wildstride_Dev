import 'package:flutter/material.dart';

// Sheet Root Component
class Sheet extends StatelessWidget {
  final bool open;
  final VoidCallback? onOpenChange;
  final Widget child;

  const Sheet({
    super.key,
    required this.open,
    this.onOpenChange,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

// Sheet Trigger Component
class SheetTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const SheetTrigger({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
}

// Sheet Close Component
class SheetClose extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const SheetClose({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: child,
    );
  }
}

// Main Sheet Content Component
class SheetContent extends StatefulWidget {
  final bool open;
  final VoidCallback? onOpenChange;
  final SheetSide side;
  final Widget child;
  final bool showCloseButton;

  const SheetContent({
    super.key,
    required this.open,
    this.onOpenChange,
    this.side = SheetSide.right,
    required this.child,
    this.showCloseButton = true,
  });

  @override
  State<SheetContent> createState() => _SheetContentState();
}

class _SheetContentState extends State<SheetContent> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    if (widget.open) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(SheetContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _animationController.forward();
      } else {
        _animationController.reverse().then((_) {
          widget.onOpenChange?.call();
        });
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.open && _animationController.value == 0) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // Overlay
        if (widget.open)
          GestureDetector(
            onTap: () {
              if (widget.onOpenChange != null) {
                widget.onOpenChange!();
              }
            },
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),

        // Sheet Content
        Positioned(
          top: widget.side == SheetSide.top ? 0 : null,
          bottom: widget.side == SheetSide.bottom ? 0 : null,
          left: widget.side == SheetSide.left ? 0 : null,
          right: widget.side == SheetSide.right ? 0 : null,
          child: SlideTransition(
            position: _getSlideAnimation(widget.side),
            child: Material(
              color: Theme.of(context).colorScheme.background,
              elevation: 8,
              child: Container(
                width: _getWidth(context),
                height: _getHeight(context),
                decoration: BoxDecoration(
                  border: _getBorder(widget.side),
                ),
                child: Column(
                  children: [
                    if (widget.showCloseButton && widget.side != SheetSide.top)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            if (widget.onOpenChange != null) {
                              widget.onOpenChange!();
                            }
                          },
                        ),
                      ),
                    Expanded(child: widget.child),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Animation<Offset> _getSlideAnimation(SheetSide side) {
    switch (side) {
      case SheetSide.right:
        return Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
      case SheetSide.left:
        return Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
      case SheetSide.top:
        return Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
      case SheetSide.bottom:
        return Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
    }
  }

  double? _getWidth(BuildContext context) {
    switch (widget.side) {
      case SheetSide.left:
      case SheetSide.right:
        return MediaQuery.of(context).size.width * 0.75;
      case SheetSide.top:
      case SheetSide.bottom:
        return MediaQuery.of(context).size.width;
    }
  }

  double? _getHeight(BuildContext context) {
    switch (widget.side) {
      case SheetSide.left:
      case SheetSide.right:
        return MediaQuery.of(context).size.height;
      case SheetSide.top:
      case SheetSide.bottom:
        return null; // Auto height for top/bottom
    }
  }

  Border? _getBorder(SheetSide side) {
    switch (side) {
      case SheetSide.right:
        return Border(left: BorderSide(color: Theme.of(context).dividerColor));
      case SheetSide.left:
        return Border(right: BorderSide(color: Theme.of(context).dividerColor));
      case SheetSide.top:
        return Border(bottom: BorderSide(color: Theme.of(context).dividerColor));
      case SheetSide.bottom:
        return Border(top: BorderSide(color: Theme.of(context).dividerColor));
    }
  }
}

// Sheet Side Enum
enum SheetSide { top, right, bottom, left }

// Sheet Header Component
class SheetHeader extends StatelessWidget {
  final Widget child;

  const SheetHeader({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

// Sheet Footer Component
class SheetFooter extends StatelessWidget {
  final Widget child;

  const SheetFooter({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

// Sheet Title Component
class SheetTitle extends StatelessWidget {
  final String text;

  const SheetTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
  }
}

// Sheet Description Component
class SheetDescription extends StatelessWidget {
  final String text;

  const SheetDescription({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
    );
  }
}

// Example usage
class SheetExample extends StatefulWidget {
  const SheetExample({super.key});

  @override
  State<SheetExample> createState() => _SheetExampleState();
}

class _SheetExampleState extends State<SheetExample> {
  bool _sheetOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SheetTrigger(
              onPressed: () {
                setState(() {
                  _sheetOpen = true;
                });
              },
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _sheetOpen = true;
                  });
                },
                child: const Text('Open Sheet'),
              ),
            ),
            Sheet(
              open: _sheetOpen,
              onOpenChange: () {
                setState(() {
                  _sheetOpen = false;
                });
              },
              child: SheetContent(
                open: _sheetOpen,
                onOpenChange: () {
                  setState(() {
                    _sheetOpen = false;
                  });
                },
                side: SheetSide.right,
                child: Column(
                  children: [
                    SheetHeader(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SheetTitle(text: 'Sheet Title'),
                          const SizedBox(height: 8),
                          SheetDescription(text: 'This is a sheet description.'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text('Item ${index + 1}'),
                            );
                          },
                        ),
                      ),
                    ),
                    SheetFooter(
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _sheetOpen = false;
                                });
                              },
                              child: const Text('Close'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}