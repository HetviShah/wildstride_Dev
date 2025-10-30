import 'package:flutter/material.dart';

// Main Menubar widget
class Menubar extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final double gap;

  const Menubar({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(4),
    this.borderRadius = 6,
    this.backgroundColor,
    this.border,
    this.shadow,
    this.gap = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: border ?? Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow ?? [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children
            .expand((child) => [child, SizedBox(width: gap)])
            .take(children.length * 2 - 1)
            .toList(),
      ),
    );
  }
}

// Menubar Menu (handles the dropdown state)
class MenubarMenu extends StatefulWidget {
  final Widget trigger;
  final Widget content;
  final AlignmentGeometry alignment;
  final double offset;

  const MenubarMenu({
    super.key,
    required this.trigger,
    required this.content,
    this.alignment = Alignment.center,
    this.offset = 8,
  });

  @override
  State<MenubarMenu> createState() => _MenubarMenuState();
}

class _MenubarMenuState extends State<MenubarMenu> {
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
            offset: Offset(0, widget.offset),
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
      child: GestureDetector(
        onTap: _openMenu,
        child: MouseRegion(
          onHover: (event) => _openMenu(),
          child: widget.trigger,
        ),
      ),
    );
  }
}

// Menubar Trigger
class MenubarTrigger extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isOpen;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? hoverColor;
  final Color? activeColor;

  const MenubarTrigger({
    super.key,
    required this.child,
    this.onPressed,
    this.isOpen = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.borderRadius = 4,
    this.hoverColor,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isOpen 
            ? (activeColor ?? theme.colorScheme.secondary.withOpacity(0.1))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          hoverColor: hoverColor ?? theme.colorScheme.secondary.withOpacity(0.1),
          child: Padding(
            padding: padding,
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isOpen 
                    ? theme.colorScheme.secondary
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

// Menubar Content (dropdown menu)
class MenubarContent extends StatelessWidget {
  final List<Widget> children;
  final double width;
  final double borderRadius;
  final Color? backgroundColor;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final EdgeInsetsGeometry padding;

  const MenubarContent({
    super.key,
    required this.children,
    this.width = 192,
    this.borderRadius = 6,
    this.backgroundColor,
    this.border,
    this.shadow,
    this.padding = const EdgeInsets.all(4),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
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
    );
  }
}

// Menubar Item
class MenubarItem extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool inset;
  final MenubarItemVariant variant;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? hoverColor;

  const MenubarItem({
    super.key,
    required this.child,
    this.onPressed,
    this.enabled = true,
    this.inset = false,
    this.variant = MenubarItemVariant.defaultVariant,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.borderRadius = 4,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? textColor = theme.colorScheme.onSurface;
    Color? resolvedHoverColor = hoverColor;

    if (variant == MenubarItemVariant.destructive) {
      textColor = theme.colorScheme.error;
      resolvedHoverColor = theme.colorScheme.error.withOpacity(0.1);
    }

    if (!enabled) {
      textColor = textColor.withOpacity(0.5);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          hoverColor: resolvedHoverColor ?? theme.colorScheme.secondary.withOpacity(0.1),
          child: Padding(
            padding: _getAdjustedPadding(padding, inset),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: textColor,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry _getAdjustedPadding(EdgeInsetsGeometry padding, bool inset) {
    if (padding is EdgeInsets) {
      return padding.copyWith(
        left: inset ? padding.left + 16 : padding.left,
      );
    }
    // Fallback for other EdgeInsetsGeometry types
    return inset 
        ? EdgeInsets.only(
            left: 16 + _getHorizontalPadding(padding) / 2,
            top: _getVerticalPadding(padding) / 2,
            right: _getHorizontalPadding(padding) / 2,
            bottom: _getVerticalPadding(padding) / 2,
          )
        : padding;
  }

  double _getHorizontalPadding(EdgeInsetsGeometry padding) {
    if (padding is EdgeInsets) {
      return padding.left + padding.right;
    }
    return 16; // Default fallback
  }

  double _getVerticalPadding(EdgeInsetsGeometry padding) {
    if (padding is EdgeInsets) {
      return padding.top + padding.bottom;
    }
    return 12; // Default fallback
  }
}

enum MenubarItemVariant {
  defaultVariant,
  destructive,
}

// Menubar Checkbox Item
class MenubarCheckboxItem extends StatelessWidget {
  final Widget child;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  const MenubarCheckboxItem({
    super.key,
    required this.child,
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MenubarItem(
      onPressed: enabled ? () => onChanged?.call(!value) : null,
      enabled: enabled,
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(2),
            ),
            child: value
                ? Icon(
                    Icons.check,
                    size: 14,
                    color: theme.colorScheme.primary,
                  )
                : null,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// Menubar Radio Item
class MenubarRadioItem<T> extends StatelessWidget {
  final Widget child;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  const MenubarRadioItem({
    super.key,
    required this.child,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return MenubarItem(
      onPressed: enabled ? () => onChanged?.call(value) : null,
      enabled: enabled,
      padding: padding,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// Menubar Label
class MenubarLabel extends StatelessWidget {
  final String text;
  final bool inset;
  final TextStyle? style;

  const MenubarLabel({
    super.key,
    required this.text,
    this.inset = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: inset ? 16 : 8,
        top: 8,
        bottom: 4,
      ),
      child: Text(
        text,
        style: (style ?? TextStyle()).copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
    );
  }
}

// Menubar Separator
class MenubarSeparator extends StatelessWidget {
  final Color? color;
  final double thickness;
  final EdgeInsetsGeometry margin;

  const MenubarSeparator({
    super.key,
    this.color,
    this.thickness = 1,
    this.margin = const EdgeInsets.symmetric(vertical: 4),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: margin,
      height: thickness,
      color: color ?? theme.colorScheme.outline.withOpacity(0.2),
    );
  }
}

// Menubar Shortcut
class MenubarShortcut extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const MenubarShortcut({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: (style ?? TextStyle()).copyWith(
        fontSize: 12,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
        letterSpacing: 1,
      ),
    );
  }
}

// Menubar Item with Icon
class MenubarItemWithIcon extends StatelessWidget {
  final Widget child;
  final Widget? icon;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool inset;
  final MenubarItemVariant variant;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? hoverColor;

  const MenubarItemWithIcon({
    super.key,
    required this.child,
    this.icon,
    this.onPressed,
    this.enabled = true,
    this.inset = false,
    this.variant = MenubarItemVariant.defaultVariant,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.borderRadius = 4,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return MenubarItem(
      onPressed: onPressed,
      enabled: enabled,
      inset: inset,
      variant: variant,
      padding: padding,
      borderRadius: borderRadius,
      hoverColor: hoverColor,
      child: Row(
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Expanded(child: child),
        ],
      ),
    );
  }
}

// Menubar Item with Shortcut
class MenubarItemWithShortcut extends StatelessWidget {
  final String label;
  final String shortcut;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool inset;
  final MenubarItemVariant variant;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? hoverColor;

  const MenubarItemWithShortcut({
    super.key,
    required this.label,
    required this.shortcut,
    this.onPressed,
    this.enabled = true,
    this.inset = false,
    this.variant = MenubarItemVariant.defaultVariant,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    this.borderRadius = 4,
    this.hoverColor,
  });

  @override
  Widget build(BuildContext context) {
    return MenubarItem(
      onPressed: onPressed,
      enabled: enabled,
      inset: inset,
      variant: variant,
      padding: padding,
      borderRadius: borderRadius,
      hoverColor: hoverColor,
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 16),
          MenubarShortcut(text: shortcut),
        ],
      ),
    );
  }
}

// Usage Example
class MenubarExample extends StatelessWidget {
  const MenubarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Menubar(
        children: [
          MenubarMenu(
            trigger: const MenubarTrigger(
              child: Text('File'),
            ),
            content: MenubarContent(
              children: [
                const MenubarLabel(text: 'File Operations'),
                MenubarItem(
                  child: const Text('New File'),
                  onPressed: () => print('New File'),
                ),
                MenubarItem(
                  child: const Text('Open'),
                  onPressed: () => print('Open'),
                ),
                MenubarItemWithShortcut(
                  label: 'Save',
                  shortcut: 'Ctrl+S',
                  onPressed: () => print('Save'),
                ),
                const MenubarSeparator(),
                MenubarItem(
                  child: const Text('Exit'),
                  variant: MenubarItemVariant.destructive,
                  onPressed: () => print('Exit'),
                ),
              ],
            ),
          ),
          MenubarMenu(
            trigger: const MenubarTrigger(
              child: Text('Edit'),
            ),
            content: MenubarContent(
              children: [
                MenubarCheckboxItem(
                  value: true,
                  onChanged: (value) => print('Checkbox: $value'),
                  child: const Text('Auto-save'),
                ),
                MenubarRadioItem(
                  value: 1,
                  groupValue: 1,
                  onChanged: (value) => print('Radio: $value'),
                  child: const Text('Option 1'),
                ),
                MenubarRadioItem(
                  value: 2,
                  groupValue: 1,
                  onChanged: (value) => print('Radio: $value'),
                  child: const Text('Option 2'),
                ),
              ],
            ),
          ),
          MenubarMenu(
            trigger: const MenubarTrigger(
              child: Text('View'),
            ),
            content: MenubarContent(
              children: [
                MenubarItemWithIcon(
                  icon: const Icon(Icons.zoom_in, size: 16),
                  child: const Text('Zoom In'),
                  onPressed: () => print('Zoom In'),
                ),
                MenubarItemWithIcon(
                  icon: const Icon(Icons.zoom_out, size: 16),
                  child: const Text('Zoom Out'),
                  onPressed: () => print('Zoom Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}