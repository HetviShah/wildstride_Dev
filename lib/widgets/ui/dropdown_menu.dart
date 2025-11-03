import 'package:flutter/material.dart';

class DropdownMenu extends StatefulWidget {
  final Widget trigger;
  final List<DropdownMenuItem> items;
  final bool open;
  final VoidCallback? onOpenChange;
  final AlignmentGeometry alignment;
  final Offset offset;
  final double? width;
  final double? maxHeight;
  final bool dismissible;

  const DropdownMenu({
    super.key,
    required this.trigger,
    required this.items,
    this.open = false,
    this.onOpenChange,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.width,
    this.maxHeight,
    this.dismissible = true,
  });

  @override
  State<DropdownMenu> createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.open;
  }

  @override
  void didUpdateWidget(DropdownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
        _showMenu();
      } else {
        _hideMenu();
      }
    }
  }

  void _showMenu() {
    if (_isOpen) return;

    setState(() {
      _isOpen = true;
    });

    _overlayEntry = OverlayEntry(
      builder: (context) => _DropdownOverlay(
        triggerKey: _triggerKey,
        items: widget.items,
        onClose: _hideMenu,
        alignment: widget.alignment,
        offset: widget.offset,
        width: widget.width,
        maxHeight: widget.maxHeight,
        dismissible: widget.dismissible,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    widget.onOpenChange?.call();
  }

  void _hideMenu() {
    if (!_isOpen) return;

    setState(() {
      _isOpen = false;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onOpenChange?.call();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _hideMenu();
    } else {
      _showMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleMenu,
      child: KeyedSubtree(
        key: _triggerKey,
        child: widget.trigger,
      ),
    );
  }
}

class _DropdownOverlay extends StatefulWidget {
  final GlobalKey triggerKey;
  final List<DropdownMenuItem> items;
  final VoidCallback onClose;
  final AlignmentGeometry alignment;
  final Offset offset;
  final double? width;
  final double? maxHeight;
  final bool dismissible;

  const _DropdownOverlay({
    required this.triggerKey,
    required this.items,
    required this.onClose,
    required this.alignment,
    required this.offset,
    this.width,
    this.maxHeight,
    this.dismissible = true,
  });

  @override
  State<_DropdownOverlay> createState() => _DropdownOverlayState();
}

class _DropdownOverlayState extends State<_DropdownOverlay> {
  @override
  Widget build(BuildContext context) {
    final renderBox = widget.triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return const SizedBox.shrink();

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    return Stack(
      children: [
        // Background overlay
        if (widget.dismissible)
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

        // Dropdown content
        Positioned(
          left: offset.dx + widget.offset.dx,
          top: offset.dy + size.height + widget.offset.dy,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: widget.width ?? size.width,
              constraints: BoxConstraints(
                maxHeight: widget.maxHeight ?? 400,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: _DropdownContent(
                items: widget.items,
                onItemSelected: widget.onClose,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownContent extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final VoidCallback onItemSelected;

  const _DropdownContent({
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = <Widget>[];
    
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      
      if (item is DropdownMenuSeparator) {
        if (i > 0 && i < items.length - 1) {
          menuItems.add(const _DropdownMenuSeparator());
        }
      } else {
        menuItems.add(_buildMenuItem(item, context));
      }
    }

    return ListView(
      padding: const EdgeInsets.all(4),
      shrinkWrap: true,
      children: menuItems,
    );
  }

  Widget _buildMenuItem(DropdownMenuItem item, BuildContext context) {
    if (item is DropdownMenuLabel) {
      return _DropdownMenuLabel(
        label: item.label,
        inset: item.inset,
      );
    } else if (item is DropdownMenuAction) {
      return _DropdownMenuAction(
        label: item.label,
        icon: item.icon,
        shortcut: item.shortcut,
        variant: item.variant,
        inset: item.inset,
        onSelected: () {
          item.onSelected?.call();
          onItemSelected();
        },
      );
    } else if (item is DropdownMenuCheckbox) {
      return _DropdownMenuCheckbox(
        label: item.label,
        value: item.value,
        onChanged: item.onChanged,
      );
    } else if (item is DropdownMenuRadio) {
      return _DropdownMenuRadio(
        label: item.label,
        value: item.value,
        groupValue: item.groupValue,
        onChanged: item.onChanged,
      );
    }

    return const SizedBox.shrink();
  }
}

// Base class for all dropdown menu items
abstract class DropdownMenuItem {
  const DropdownMenuItem();
}

class DropdownMenuAction extends DropdownMenuItem {
  final String label;
  final IconData? icon;
  final String? shortcut;
  final DropdownMenuItemVariant variant;
  final bool inset;
  final VoidCallback? onSelected;

  const DropdownMenuAction({
    required this.label,
    this.icon,
    this.shortcut,
    this.variant = DropdownMenuItemVariant.defaultVariant,
    this.inset = false,
    this.onSelected,
  });
}

class DropdownMenuCheckbox extends DropdownMenuItem {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const DropdownMenuCheckbox({
    required this.label,
    required this.value,
    this.onChanged,
  });
}

class DropdownMenuRadio<T> extends DropdownMenuItem {
  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  const DropdownMenuRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });
}

class DropdownMenuLabel extends DropdownMenuItem {
  final String label;
  final bool inset;

  const DropdownMenuLabel({
    required this.label,
    this.inset = false,
  });
}

class DropdownMenuSeparator extends DropdownMenuItem {
  const DropdownMenuSeparator();
}

enum DropdownMenuItemVariant {
  defaultVariant,
  destructive,
}

// Widget implementations
class _DropdownMenuLabel extends StatelessWidget {
  final String label;
  final bool inset;

  const _DropdownMenuLabel({
    required this.label,
    required this.inset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(inset ? 32 : 16, 12, 16, 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DropdownMenuAction extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? shortcut;
  final DropdownMenuItemVariant variant;
  final bool inset;
  final VoidCallback? onSelected;

  const _DropdownMenuAction({
    required this.label,
    this.icon,
    this.shortcut,
    this.variant = DropdownMenuItemVariant.defaultVariant,
    this.inset = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDestructive = variant == DropdownMenuItemVariant.destructive;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: EdgeInsets.fromLTRB(inset ? 32 : 16, 8, 16, 8),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isDestructive ? colorScheme.error : colorScheme.onSurface.withOpacity(0.8),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDestructive ? colorScheme.error : colorScheme.onSurface,
                  ),
                ),
              ),
              if (shortcut != null) ...[
                const SizedBox(width: 12),
                Text(
                  shortcut!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _DropdownMenuCheckbox({
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onChanged != null ? () => onChanged!(!value) : null,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(2),
                  color: value ? Theme.of(context).colorScheme.primary : Colors.transparent,
                ),
                child: value
                    ? Icon(
                        Icons.check,
                        size: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuRadio<T> extends StatelessWidget {
  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  const _DropdownMenuRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onChanged != null ? () => onChanged!(value) : null,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 8, 16, 8),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownMenuSeparator extends StatelessWidget {
  const _DropdownMenuSeparator();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
    );
  }
}

// Helper class for managing dropdown state
class DropdownMenuController extends ChangeNotifier {
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