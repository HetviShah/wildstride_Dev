import 'package:flutter/material.dart';

// Main Navigation Menu component
class NavigationMenu extends StatelessWidget {
  final List<Widget> children;
  final bool viewport;
  final AlignmentGeometry alignment;

  const NavigationMenu({
    super.key,
    required this.children,
    this.viewport = true,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: alignment,
          child: _NavigationMenuScope(
            hasViewport: viewport,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
        if (viewport) const NavigationMenuViewport(),
      ],
    );
  }
}

// Scope to provide viewport state
class _NavigationMenuScope extends InheritedWidget {
  final bool hasViewport;

  const _NavigationMenuScope({
    required this.hasViewport,
    required super.child,
  });

  static _NavigationMenuScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_NavigationMenuScope>();
  }

  @override
  bool updateShouldNotify(_NavigationMenuScope oldWidget) {
    return hasViewport != oldWidget.hasViewport;
  }
}

// Navigation Menu List
class NavigationMenuList extends StatelessWidget {
  final List<Widget> children;
  final double gap;

  const NavigationMenuList({
    super.key,
    required this.children,
    this.gap = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children
          .expand((child) => [child, SizedBox(width: gap)])
          .take(children.length * 2 - 1)
          .toList(),
    );
  }
}

// Navigation Menu Item (handles dropdown state)
class NavigationMenuItem extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final AlignmentGeometry contentAlignment;

  const NavigationMenuItem({
    super.key,
    required this.trigger,
    required this.content,
    this.contentAlignment = Alignment.center,
  });

  @override
  State<NavigationMenuItem> createState() => _NavigationMenuItemState();
}

class _NavigationMenuItemState extends State<NavigationMenuItem> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _openMenu() {
    if (_isOpen) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeMenu,
        behavior: HitTestBehavior.translucent,
        child: Material(
          color: Colors.transparent,
          child: CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: Alignment.bottomCenter,
            followerAnchor: Alignment.topCenter,
            offset: const Offset(0, 8),
            child: MouseRegion(
              onExit: (event) => _closeMenu(),
              child: widget.content,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onHover: (event) => _openMenu(),
        child: GestureDetector(
          onTap: _openMenu,
          child: widget.trigger,
        ),
      ),
    );
  }
}

// Navigation Menu Trigger
class NavigationMenuTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isOpen;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? disabledColor;

  const NavigationMenuTrigger({
    super.key,
    required this.child,
    this.onPressed,
    this.isOpen = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 6,
    this.backgroundColor,
    this.hoverColor,
    this.focusColor,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Removed unused hasViewport variable since it wasn't being used

    return Container(
      decoration: BoxDecoration(
        color: isOpen 
            ? (backgroundColor ?? theme.colorScheme.secondary.withOpacity(0.5))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          hoverColor: hoverColor ?? theme.colorScheme.secondary.withOpacity(0.1),
          focusColor: focusColor ?? theme.colorScheme.secondary.withOpacity(0.2),
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return disabledColor ?? theme.colorScheme.onSurface.withOpacity(0.12);
            }
            if (states.contains(WidgetState.hovered)) {
              return hoverColor ?? theme.colorScheme.secondary.withOpacity(0.1);
            }
            if (states.contains(WidgetState.focused)) {
              return focusColor ?? theme.colorScheme.secondary.withOpacity(0.2);
            }
            return null;
          }),
          child: Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isOpen 
                    ? theme.colorScheme.onSecondary
                    : theme.colorScheme.onSurface,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  child,
                  const SizedBox(width: 4),
                  Icon(
                    Icons.expand_more,
                    size: 16,
                    color: isOpen 
                        ? theme.colorScheme.onSecondary
                        : theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Navigation Menu Content
class NavigationMenuContent extends StatelessWidget {
  final List<Widget> children;
  final double width;
  final double borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final EdgeInsetsGeometry padding;

  const NavigationMenuContent({
    super.key,
    required this.children,
    this.width = 200,
    this.borderRadius = 6,
    this.backgroundColor,
    this.border,
    this.shadow,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasViewport = _NavigationMenuScope.of(context)?.hasViewport ?? true;

    // Actually use the hasViewport variable to conditionally apply different styling
    if (!hasViewport) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          border: border ?? Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadow ?? [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          border: border ?? Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: shadow ?? [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}

// Navigation Menu Viewport
class NavigationMenuViewport extends StatelessWidget {
  const NavigationMenuViewport({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: _NavigationMenuViewportContent(),
    );
  }
}

class _NavigationMenuViewportContent extends StatefulWidget {
  const _NavigationMenuViewportContent();

  @override
  State<_NavigationMenuViewportContent> createState() => _NavigationMenuViewportContentState();
}

class _NavigationMenuViewportContentState extends State<_NavigationMenuViewportContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // This would typically be dynamic based on content
      color: Colors.transparent,
    );
  }
}

// Navigation Menu Link
class NavigationMenuLink extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isActive;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? activeColor;

  const NavigationMenuLink({
    super.key,
    required this.child,
    this.onTap,
    this.isActive = false,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius = 4,
    this.hoverColor,
    this.focusColor,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        hoverColor: hoverColor ?? theme.colorScheme.secondary.withOpacity(0.1),
        focusColor: focusColor ?? theme.colorScheme.secondary.withOpacity(0.2),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return hoverColor ?? theme.colorScheme.secondary.withOpacity(0.1);
          }
          if (states.contains(WidgetState.focused)) {
            return focusColor ?? theme.colorScheme.secondary.withOpacity(0.2);
          }
          return null;
        }),
        child: Container(
          decoration: BoxDecoration(
            color: isActive 
                ? (activeColor ?? theme.colorScheme.secondary.withOpacity(0.5))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: isActive 
                    ? theme.colorScheme.onSecondary
                    : theme.colorScheme.onSurface,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

// Navigation Menu Indicator
class NavigationMenuIndicator extends StatelessWidget {
  final bool isVisible;
  final Color? color;

  const NavigationMenuIndicator({
    super.key,
    this.isVisible = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 6,
        alignment: Alignment.topCenter,
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color ?? theme.colorScheme.outline,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(1),
              topRight: Radius.circular(1),
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.3),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage Example
class NavigationMenuExample extends StatelessWidget {
  const NavigationMenuExample({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationMenu(
      viewport: true,
      children: [
        NavigationMenuList(
          children: [
            NavigationMenuItem(
              trigger: const NavigationMenuTrigger(
                child: Text('Products'),
              ),
              content: NavigationMenuContent(
                children: [
                  NavigationMenuLink(
                    child: const Text('Web SDK'),
                    onTap: () => print('Web SDK clicked'),
                  ),
                  NavigationMenuLink(
                    child: const Text('Mobile SDK'),
                    onTap: () => print('Mobile SDK clicked'),
                  ),
                  NavigationMenuLink(
                    child: const Text('API'),
                    onTap: () => print('API clicked'),
                  ),
                ],
              ),
            ),
            NavigationMenuItem(
              trigger: const NavigationMenuTrigger(
                child: Text('Solutions'),
              ),
              content: NavigationMenuContent(
                children: [
                  NavigationMenuLink(
                    child: const Text('E-commerce'),
                    onTap: () => print('E-commerce clicked'),
                  ),
                  NavigationMenuLink(
                    child: const Text('Healthcare'),
                    onTap: () => print('Healthcare clicked'),
                  ),
                  NavigationMenuLink(
                    child: const Text('Finance'),
                    onTap: () => print('Finance clicked'),
                  ),
                ],
              ),
            ),
            NavigationMenuLink(
              child: const Text('Pricing'),
              onTap: () => print('Pricing clicked'),
            ),
            NavigationMenuLink(
              child: const Text('Docs'),
              onTap: () => print('Docs clicked'),
            ),
          ],
        ),
      ],
    );
  }
}

// Utility class for styling (similar to cn utility in React)
class NavigationMenuStyles {
  static BoxDecoration triggerDecoration(BuildContext context, {bool isOpen = false}) {
    final theme = Theme.of(context);
    return BoxDecoration(
      color: isOpen 
          ? theme.colorScheme.secondary.withOpacity(0.5)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
    );
  }

  static TextStyle triggerTextStyle(BuildContext context, {bool isOpen = false}) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: isOpen 
          ? theme.colorScheme.onSecondary
          : theme.colorScheme.onSurface,
    );
  }

  static TextStyle linkTextStyle(BuildContext context, {bool isActive = false}) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 14,
      color: isActive 
          ? theme.colorScheme.onSecondary
          : theme.colorScheme.onSurface,
    );
  }
}