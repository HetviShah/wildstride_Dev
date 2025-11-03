import 'package:flutter/material.dart';

// Constants
const double sidebarWidth = 256.0; // 16rem
const double sidebarWidthMobile = 288.0; // 18rem
const double sidebarWidthIcon = 48.0; // 3rem

// Enums
enum SidebarState { expanded, collapsed }
enum SidebarSide { left, right }
enum SidebarVariant { sidebar, floating, inset }
enum SidebarCollapsible { offcanvas, icon, none }
enum SidebarSize { sm, defaultSize, lg }
enum SubButtonSize { sm, md }

// Sidebar Provider and State Management
class SidebarController extends ChangeNotifier {
  SidebarState _state = SidebarState.expanded;
  bool _open = true;
  bool _openMobile = false;
  bool _isMobile = false;

  SidebarState get state => _state;
  bool get open => _open;
  bool get openMobile => _openMobile;
  bool get isMobile => _isMobile;

  set open(bool value) {
    _open = value;
    _state = value ? SidebarState.expanded : SidebarState.collapsed;
    notifyListeners();
  }

  set openMobile(bool value) {
    _openMobile = value;
    notifyListeners();
  }

  set isMobile(bool value) {
    _isMobile = value;
    notifyListeners();
  }

  void toggleSidebar() {
    if (_isMobile) {
      _openMobile = !_openMobile;
    } else {
      _open = !_open;
      _state = _open ? SidebarState.expanded : SidebarState.collapsed;
    }
    notifyListeners();
  }
}

// InheritedWidget for sharing the controller
class SidebarInherited extends InheritedWidget {
  final SidebarController controller;

  const SidebarInherited({
    super.key,
    required this.controller,
    required super.child,
  });

  static SidebarInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SidebarInherited>();
  }

  @override
  bool updateShouldNotify(SidebarInherited oldWidget) {
    return controller != oldWidget.controller;
  }
}

// Main Sidebar Widget
class Sidebar extends StatelessWidget {
  final SidebarSide side;
  final SidebarVariant variant;
  final SidebarCollapsible collapsible;
  final Widget child;

  const Sidebar({
    super.key,
    this.side = SidebarSide.left,
    this.variant = SidebarVariant.sidebar,
    this.collapsible = SidebarCollapsible.offcanvas,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final inherited = SidebarInherited.of(context);
    if (inherited == null) {
      throw FlutterError('Sidebar must be used within a SidebarInherited widget');
    }
    final controller = inherited.controller;
    
    if (collapsible == SidebarCollapsible.none) {
      return Container(
        width: sidebarWidth,
        color: Theme.of(context).colorScheme.surface,
        child: child,
      );
    }

    if (controller.isMobile) {
      return _buildMobileSidebar(context, controller);
    }

    return _buildDesktopSidebar(context, controller);
  }

  Widget _buildMobileSidebar(BuildContext context, SidebarController controller) {
    return BottomSheet(
      onClosing: () => controller.openMobile = false,
      builder: (context) => Container(
        width: sidebarWidthMobile,
        height: MediaQuery.of(context).size.height * 0.8,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            AppBar(
              title: const Text('Sidebar'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => controller.openMobile = false,
                ),
              ],
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopSidebar(BuildContext context, SidebarController controller) {
    final width = controller.state == SidebarState.collapsed && collapsible == SidebarCollapsible.icon
        ? sidebarWidthIcon
        : sidebarWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      curve: Curves.easeInOut,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: variant == SidebarVariant.floating ? 4 : 0,
        borderRadius: variant == SidebarVariant.floating 
            ? BorderRadius.circular(8) 
            : BorderRadius.zero,
        child: child,
      ),
    );
  }
}

// Sidebar Trigger
class SidebarTrigger extends StatelessWidget {
  final VoidCallback? onTap;

  const SidebarTrigger({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final inherited = SidebarInherited.of(context);
    if (inherited == null) {
      throw FlutterError('SidebarTrigger must be used within a SidebarInherited widget');
    }
    final controller = inherited.controller;
    
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        onTap?.call();
        controller.toggleSidebar();
      },
      tooltip: 'Toggle Sidebar',
    );
  }
}

// Sidebar Inset
class SidebarInset extends StatelessWidget {
  final Widget child;

  const SidebarInset({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
}

// Sidebar Input
class SidebarInput extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SidebarInput({super.key, this.hintText = 'Search...', this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// Sidebar Header
class SidebarHeader extends StatelessWidget {
  final Widget child;

  const SidebarHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}

// Sidebar Footer
class SidebarFooter extends StatelessWidget {
  final Widget child;

  const SidebarFooter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}

// Sidebar Separator
class SidebarSeparator extends StatelessWidget {
  const SidebarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1);
  }
}

// Sidebar Content
class SidebarContent extends StatelessWidget {
  final Widget child;

  const SidebarContent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

// Sidebar Group
class SidebarGroup extends StatelessWidget {
  final Widget child;

  const SidebarGroup({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    );
  }
}

// Sidebar Group Label
class SidebarGroupLabel extends StatelessWidget {
  final String text;
  final Widget? icon;

  const SidebarGroupLabel({super.key, required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    final inherited = SidebarInherited.of(context);
    if (inherited == null) {
      throw FlutterError('SidebarGroupLabel must be used within a SidebarInherited widget');
    }
    final controller = inherited.controller;
    
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: controller.state == SidebarState.collapsed ? 0 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sidebar Menu
class SidebarMenu extends StatelessWidget {
  final List<Widget> children;

  const SidebarMenu({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

// Sidebar Menu Item
class SidebarMenuItem extends StatelessWidget {
  final Widget child;

  const SidebarMenuItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

// Sidebar Menu Button
class SidebarMenuButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool isActive;
  final SidebarSize size;
  final String? tooltip;

  const SidebarMenuButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.isActive = false,
    this.size = SidebarSize.defaultSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final inherited = SidebarInherited.of(context);
    if (inherited == null) {
      throw FlutterError('SidebarMenuButton must be used within a SidebarInherited widget');
    }
    final controller = inherited.controller;
    final theme = Theme.of(context);
    
    final height = switch (size) {
      SidebarSize.sm => 28.0,
      SidebarSize.defaultSize => 32.0,
      SidebarSize.lg => 48.0,
    };

    Widget button = Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive 
            ? theme.colorScheme.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                if (controller.state == SidebarState.expanded)
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                        color: isActive 
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (tooltip != null && controller.state == SidebarState.collapsed) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

// Sidebar Menu Action
class SidebarMenuAction extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final bool showOnHover;

  const SidebarMenuAction({
    super.key,
    required this.icon,
    this.onTap,
    this.showOnHover = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: onTap,
      iconSize: 16,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
    );
  }
}

// Sidebar Menu Badge
class SidebarMenuBadge extends StatelessWidget {
  final String text;
  final Color? color;

  const SidebarMenuBadge({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

// Sidebar Menu Skeleton
class SidebarMenuSkeleton extends StatelessWidget {
  final bool showIcon;

  const SidebarMenuSkeleton({super.key, this.showIcon = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          if (showIcon)
            Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          Expanded(
            child: Container(
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sidebar Sub Menu
class SidebarMenuSub extends StatelessWidget {
  final List<Widget> children;

  const SidebarMenuSub({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

// Sidebar Sub Button
class SidebarMenuSubButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isActive;
  final SubButtonSize size;

  const SidebarMenuSubButton({
    super.key,
    required this.text,
    this.onTap,
    this.isActive = false,
    this.size = SubButtonSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: size == SubButtonSize.sm ? 24 : 28,
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: (size == SubButtonSize.sm 
                    ? theme.textTheme.bodySmall 
                    : theme.textTheme.bodyMedium)?.copyWith(
                  color: isActive 
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Example Usage
class SidebarExample extends StatefulWidget {
  const SidebarExample({super.key});

  @override
  State<SidebarExample> createState() => _SidebarExampleState();
}

class _SidebarExampleState extends State<SidebarExample> {
  final SidebarController _controller = SidebarController();

  @override
  Widget build(BuildContext context) {
    return SidebarInherited(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sidebar Example'),
          leading: const SidebarTrigger(),
        ),
        body: Row(
          children: [
            const Sidebar(
              child: SidebarContent(
                child: Column(
                  children: [
                    SidebarHeader(
                      child: Text('Header'),
                    ),
                    SidebarMenu(
                      children: [
                        SidebarMenuItem(
                          child: SidebarMenuButton(
                            text: 'Dashboard',
                            icon: Icon(Icons.dashboard, size: 16),
                            isActive: true,
                          ),
                        ),
                        SidebarMenuItem(
                          child: SidebarMenuButton(
                            text: 'Settings',
                            icon: Icon(Icons.settings, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SidebarInset(
                child: Center(
                  child: Text('Main Content'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}