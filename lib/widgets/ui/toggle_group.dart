import 'package:flutter/material.dart';

// Toggle variant styles
enum ToggleVariant {
  defaultVariant,
  outline,
}

// Toggle size styles
enum ToggleSize {
  small,
  defaultSize,
  large,
}

// Context to pass variant and size down the widget tree
class ToggleGroupContext {
  final ToggleVariant variant;
  final ToggleSize size;

  const ToggleGroupContext({
    this.variant = ToggleVariant.defaultVariant,
    this.size = ToggleSize.defaultSize,
  });
}

// ToggleGroup widget
class ToggleGroup extends StatelessWidget {
  final List<Widget> children;
  final ToggleVariant variant;
  final ToggleSize size;
  final Axis direction;
  final bool allowMultipleSelection;
  final List<int>? selectedIndices;
  final ValueChanged<List<int>>? onSelectionChanged;
  final EdgeInsets? padding;
  final Decoration? decoration;

  const ToggleGroup({
    Key? key,
    required this.children,
    this.variant = ToggleVariant.defaultVariant,
    this.size = ToggleSize.defaultSize,
    this.direction = Axis.horizontal,
    this.allowMultipleSelection = false,
    this.selectedIndices,
    this.onSelectionChanged,
    this.padding,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InheritedToggleGroup(
      variant: variant,
      size: size,
      child: Container(
        padding: padding,
        decoration: decoration ?? _getGroupDecoration(context),
        child: _ToggleGroupStateful(
          direction: direction,
          allowMultipleSelection: allowMultipleSelection,
          selectedIndices: selectedIndices ?? [],
          onSelectionChanged: onSelectionChanged,
          children: children,
        ),
      ),
    );
  }

  BoxDecoration _getGroupDecoration(BuildContext context) {
    final theme = Theme.of(context);
    
    if (variant == ToggleVariant.outline) {
      return BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      );
    }
    
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    );
  }
}

// Inherited widget to pass context down
class InheritedToggleGroup extends InheritedWidget {
  final ToggleVariant variant;
  final ToggleSize size;

  const InheritedToggleGroup({
    Key? key,
    required this.variant,
    required this.size,
    required Widget child,
  }) : super(key: key, child: child);

  static InheritedToggleGroup? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedToggleGroup>();
  }

  @override
  bool updateShouldNotify(InheritedToggleGroup oldWidget) {
    return variant != oldWidget.variant || size != oldWidget.size;
  }
}

// Stateful widget to manage selection state
class _ToggleGroupStateful extends StatefulWidget {
  final Axis direction;
  final bool allowMultipleSelection;
  final List<int> selectedIndices;
  final ValueChanged<List<int>>? onSelectionChanged;
  final List<Widget> children;

  const _ToggleGroupStateful({
    Key? key,
    required this.direction,
    required this.allowMultipleSelection,
    required this.selectedIndices,
    required this.onSelectionChanged,
    required this.children,
  }) : super(key: key);

  @override
  __ToggleGroupStatefulState createState() => __ToggleGroupStatefulState();
}

class __ToggleGroupStatefulState extends State<_ToggleGroupStateful> {
  late List<int> _selectedIndices;

  @override
  void initState() {
    super.initState();
    _selectedIndices = List.from(widget.selectedIndices);
  }

  @override
  void didUpdateWidget(_ToggleGroupStateful oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndices != oldWidget.selectedIndices) {
      _selectedIndices = List.from(widget.selectedIndices);
    }
  }

  void _handleItemTap(int index) {
    setState(() {
      if (widget.allowMultipleSelection) {
        if (_selectedIndices.contains(index)) {
          _selectedIndices.remove(index);
        } else {
          _selectedIndices.add(index);
        }
      } else {
        _selectedIndices = _selectedIndices.contains(index) ? [] : [index];
      }
      widget.onSelectionChanged?.call(List.from(_selectedIndices));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: widget.direction,
      children: List.generate(widget.children.length, (index) {
        return Expanded(
          child: ToggleGroupItem(
            key: Key('toggle_item_$index'),
            isSelected: _selectedIndices.contains(index),
            onTap: () => _handleItemTap(index),
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}

// ToggleGroupItem widget
class ToggleGroupItem extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onTap;
  final ToggleVariant? variant;
  final ToggleSize? size;
  final EdgeInsets? padding;

  const ToggleGroupItem({
    Key? key,
    required this.child,
    required this.isSelected,
    required this.onTap,
    this.variant,
    this.size,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inherited = InheritedToggleGroup.of(context);
    final effectiveVariant = variant ?? inherited?.variant ?? ToggleVariant.defaultVariant;
    final effectiveSize = size ?? inherited?.size ?? ToggleSize.defaultSize;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _getItemDecoration(context, effectiveVariant, isSelected),
        padding: padding ?? _getItemPadding(effectiveSize),
        child: Center(
          child: DefaultTextStyle.merge(
            style: _getTextStyle(context, effectiveSize, isSelected),
            child: child,
          ),
        ),
      ),
    );
  }

  BoxDecoration _getItemDecoration(BuildContext context, ToggleVariant variant, bool isSelected) {
    final theme = Theme.of(context);
    
    switch (variant) {
      case ToggleVariant.outline:
        return BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 1.5 : 1.0,
          ),
        );
      
      case ToggleVariant.defaultVariant:
        return BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.zero,
        );
    }
  }

  EdgeInsets _getItemPadding(ToggleSize size) {
    switch (size) {
      case ToggleSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ToggleSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case ToggleSize.defaultSize:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  TextStyle _getTextStyle(BuildContext context, ToggleSize size, bool isSelected) {
    final theme = Theme.of(context);
    final inherited = InheritedToggleGroup.of(context);
    final effectiveVariant = variant ?? inherited?.variant ?? ToggleVariant.defaultVariant;

    TextStyle baseStyle;
    switch (size) {
      case ToggleSize.small:
        baseStyle = theme.textTheme.labelSmall ?? const TextStyle(fontSize: 12);
        break;
      case ToggleSize.large:
        baseStyle = theme.textTheme.labelLarge ?? const TextStyle(fontSize: 16);
        break;
      case ToggleSize.defaultSize:
        baseStyle = theme.textTheme.labelMedium ?? const TextStyle(fontSize: 14);
    }

    Color textColor;
    if (effectiveVariant == ToggleVariant.outline) {
      textColor = isSelected 
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface;
    } else {
      textColor = isSelected 
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurfaceVariant;
    }

    return baseStyle.copyWith(color: textColor, fontWeight: FontWeight.w500);
  }
}

// Example usage
class ToggleGroupExample extends StatefulWidget {
  const ToggleGroupExample({Key? key}) : super(key: key);

  @override
  _ToggleGroupExampleState createState() => _ToggleGroupExampleState();
}

class _ToggleGroupExampleState extends State<ToggleGroupExample> {
  List<int> selectedIndices = [0];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleGroup(
          variant: ToggleVariant.outline,
          size: ToggleSize.defaultSize,
          selectedIndices: selectedIndices,
          onSelectionChanged: (indices) {
            setState(() {
              selectedIndices = indices;
            });
          },
          children: const [
            Text('Option 1'),
            Text('Option 2'),
            Text('Option 3'),
          ],
        ),
        const SizedBox(height: 20),
        ToggleGroup(
          variant: ToggleVariant.defaultVariant,
          size: ToggleSize.small,
          allowMultipleSelection: true,
          children: const [
            Text('Multi 1'),
            Text('Multi 2'),
            Text('Multi 3'),
          ],
        ),
      ],
    );
  }
}