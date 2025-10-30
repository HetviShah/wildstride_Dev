import 'package:flutter/material.dart';

class ContextMenu extends StatefulWidget {
  final Widget child;
  final List<ContextMenuItem> items;
  final ContextMenuController? controller;
  final AlignmentGeometry alignment;
  final Offset offset;

  const ContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.controller,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
  });

  @override
  State<ContextMenu> createState() => _ContextMenuState();
}

class _ContextMenuState extends State<ContextMenu> {
  final GlobalKey _childKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    widget.controller?._addState(this);
  }

  @override
  void dispose() {
    _hideMenu();
    widget.controller?._removeState(this);
    super.dispose();
  }

  void _showMenu(Offset position) {
    if (_isOpen) return;

    _isOpen = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => _ContextMenuOverlay(
        position: position,
        items: widget.items,
        onClose: _hideMenu,
        alignment: widget.alignment,
        offset: widget.offset,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideMenu() {
    if (!_isOpen) return;

    _isOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _handleTapDown(TapDownDetails details) {
    final renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = renderBox.localToGlobal(details.globalPosition);
      _showMenu(offset);
    }
  }

  void _handleLongPressDown(LongPressStartDetails details) {
    final renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = renderBox.localToGlobal(details.globalPosition);
      _showMenu(offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: _handleTapDown,
      onLongPressStart: _handleLongPressDown,
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
  }
}

class _ContextMenuOverlay extends StatefulWidget {
  final Offset position;
  final List<ContextMenuItem> items;
  final VoidCallback onClose;
  final AlignmentGeometry alignment;
  final Offset offset;

  const _ContextMenuOverlay({
    required this.position,
    required this.items,
    required this.onClose,
    required this.alignment,
    required this.offset,
  });

  @override
  State<_ContextMenuOverlay> createState() => _ContextMenuOverlayState();
}

class _ContextMenuOverlayState extends State<_ContextMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        
        // Context menu
        Positioned(
          left: widget.position.dx + widget.offset.dx,
          top: widget.position.dy + widget.offset.dy,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(minWidth: 200),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildMenuItems(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMenuItems() {
    final widgets = <Widget>[];
    
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      
      if (item is ContextMenuSeparatorItem) {
        if (i > 0 && i < widget.items.length - 1) {
          widgets.add(const _ContextMenuSeparator());
        }
      } else {
        widgets.add(_buildMenuItem(item));
      }
    }
    
    return widgets;
  }

  Widget _buildMenuItem(ContextMenuItem item) {
    if (item is ContextMenuLabelItem) {
      return _ContextMenuLabelWidget(
        label: item.label,
        inset: item.inset,
      );
    } else if (item is ContextMenuActionItem) {
      return _ContextMenuActionWidget(
        label: item.label,
        icon: item.icon,
        shortcut: item.shortcut,
        variant: item.variant,
        inset: item.inset,
        onSelected: () {
          item.onSelected?.call();
          widget.onClose();
        },
      );
    } else if (item is ContextMenuCheckboxItem) {
      return _ContextMenuCheckboxWidget(
        label: item.label,
        value: item.value,
        onChanged: item.onChanged,
      );
    } else if (item is ContextMenuRadioItem) {
      return _ContextMenuRadioWidget(
        label: item.label,
        value: item.value,
        groupValue: item.groupValue,
        onChanged: item.onChanged,
      );
    } else if (item is ContextMenuSubmenuItem) {
      return _ContextMenuSubmenuWidget(
        label: item.label,
        icon: item.icon,
        items: item.items,
        inset: item.inset,
        onCloseParent: widget.onClose,
      );
    }
    
    return const SizedBox.shrink();
  }
}

// Base class for all context menu items
abstract class ContextMenuItem {
  const ContextMenuItem();
}

class ContextMenuActionItem extends ContextMenuItem {
  final String label;
  final IconData? icon;
  final String? shortcut;
  final ContextMenuItemVariant variant;
  final bool inset;
  final VoidCallback? onSelected;

  const ContextMenuActionItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.variant = ContextMenuItemVariant.defaultVariant,
    this.inset = false,
    this.onSelected,
  });
}

class ContextMenuCheckboxItem extends ContextMenuItem {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const ContextMenuCheckboxItem({
    required this.label,
    required this.value,
    this.onChanged,
  });
}

class ContextMenuRadioItem<T> extends ContextMenuItem {
  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  const ContextMenuRadioItem({
    required this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });
}

class ContextMenuLabelItem extends ContextMenuItem {
  final String label;
  final bool inset;

  const ContextMenuLabelItem({
    required this.label,
    this.inset = false,
  });
}

class ContextMenuSeparatorItem extends ContextMenuItem {
  const ContextMenuSeparatorItem();
}

class ContextMenuSubmenuItem extends ContextMenuItem {
  final String label;
  final IconData? icon;
  final List<ContextMenuItem> items;
  final bool inset;

  const ContextMenuSubmenuItem({
    required this.label,
    this.icon,
    required this.items,
    this.inset = false,
  });
}

enum ContextMenuItemVariant {
  defaultVariant,
  destructive,
}

// Widget implementations
class _ContextMenuLabelWidget extends StatelessWidget {
  final String label;
  final bool inset;

  const _ContextMenuLabelWidget({
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

class _ContextMenuActionWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? shortcut;
  final ContextMenuItemVariant variant;
  final bool inset;
  final VoidCallback? onSelected;

  const _ContextMenuActionWidget({
    required this.label,
    this.icon,
    this.shortcut,
    this.variant = ContextMenuItemVariant.defaultVariant,
    this.inset = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDestructive = variant == ContextMenuItemVariant.destructive;
    
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

class _ContextMenuCheckboxWidget extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _ContextMenuCheckboxWidget({
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

class _ContextMenuRadioWidget<T> extends StatelessWidget {
  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  const _ContextMenuRadioWidget({
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

class _ContextMenuSeparator extends StatelessWidget {
  const _ContextMenuSeparator();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
    );
  }
}

class _ContextMenuSubmenuWidget extends StatefulWidget {
  final String label;
  final IconData? icon;
  final List<ContextMenuItem> items;
  final bool inset;
  final VoidCallback onCloseParent;

  const _ContextMenuSubmenuWidget({
    required this.label,
    this.icon,
    required this.items,
    required this.inset,
    required this.onCloseParent,
  });

  @override
  State<_ContextMenuSubmenuWidget> createState() => _ContextMenuSubmenuWidgetState();
}

class _ContextMenuSubmenuWidgetState extends State<_ContextMenuSubmenuWidget> {
  bool _isHovered = false;
  OverlayEntry? _submenuOverlay;

  void _showSubmenu(Offset position) {
    if (_isHovered) return;

    _isHovered = true;
    _submenuOverlay = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: _ContextMenuOverlay(
          position: position,
          items: widget.items,
          onClose: _hideSubmenu,
          alignment: Alignment.centerLeft,
          offset: Offset.zero,
        ),
      ),
    );

    Overlay.of(context).insert(_submenuOverlay!);
  }

  void _hideSubmenu() {
    if (!_isHovered) return;

    _isHovered = false;
    _submenuOverlay?.remove();
    _submenuOverlay = null;
  }

  @override
  void dispose() {
    _hideSubmenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final offset = renderBox.localToGlobal(Offset.zero);
          _showSubmenu(Offset(offset.dx + renderBox.size.width, offset.dy));
        }
      },
      onExit: (_) => _hideSubmenu(),
      child: _ContextMenuActionWidget(
        label: widget.label,
        icon: widget.icon,
        inset: widget.inset,
        onSelected: () {}, // Placeholder
      ),
    );
  }
}

class ContextMenuController {
  final List<_ContextMenuState> _states = [];

  void _addState(_ContextMenuState state) {
    _states.add(state);
  }

  void _removeState(_ContextMenuState state) {
    _states.remove(state);
  }

  void closeAll() {
    for (final state in _states) {
      state._hideMenu();
    }
  }
}