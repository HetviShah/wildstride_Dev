import 'package:flutter/material.dart';

// Utility function similar to cn
String cn(String baseClass, [String? additionalClasses]) {
  if (additionalClasses == null || additionalClasses.isEmpty) {
    return baseClass;
  }
  return '$baseClass $additionalClasses';
}

// RadioGroup equivalent to RadioGroupPrimitive.Root
class RadioGroup extends StatelessWidget {
  final String? value;
  final ValueChanged<String?>? onChanged;
  final List<Widget> children;
  final Axis direction;
  final double gap;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const RadioGroup({
    super.key,
    this.value,
    this.onChanged,
    required this.children,
    this.direction = Axis.vertical,
    this.gap = 12.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return _RadioGroupInheritedWidget(
      groupValue: value,
      onChanged: onChanged,
      child: direction == Axis.vertical
          ? Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: _buildChildrenWithGap(),
            )
          : Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: _buildChildrenWithGap(),
            ),
    );
  }

  List<Widget> _buildChildrenWithGap() {
    if (children.length == 1) return children;
    
    final List<Widget> childrenWithGap = [];
    for (int i = 0; i < children.length; i++) {
      childrenWithGap.add(children[i]);
      if (i < children.length - 1) {
        childrenWithGap.add(SizedBox(
          width: direction == Axis.horizontal ? gap : 0,
          height: direction == Axis.vertical ? gap : 0,
        ));
      }
    }
    return childrenWithGap;
  }
}

// InheritedWidget to pass group state down to RadioGroupItems
class _RadioGroupInheritedWidget extends InheritedWidget {
  final String? groupValue;
  final ValueChanged<String?>? onChanged;

  const _RadioGroupInheritedWidget({
    required super.child,
    required this.groupValue,
    required this.onChanged,
  });

  static _RadioGroupInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_RadioGroupInheritedWidget>();
  }

  @override
  bool updateShouldNotify(_RadioGroupInheritedWidget oldWidget) {
    return groupValue != oldWidget.groupValue || onChanged != oldWidget.onChanged;
  }
}

// RadioGroupItem equivalent to RadioGroupPrimitive.Item
class RadioGroupItem extends StatelessWidget {
  final String value;
  final bool disabled;
  final Widget? label;
  final String? semanticLabel;
  final EdgeInsetsGeometry padding;

  const RadioGroupItem({
    super.key,
    required this.value,
    this.disabled = false,
    this.label,
    this.semanticLabel,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final group = _RadioGroupInheritedWidget.of(context);
    final isSelected = group?.groupValue == value;
    final isDisabled = disabled || group?.onChanged == null;

    return Semantics(
      label: semanticLabel,
      enabled: !isDisabled,
      selected: isSelected,
      child: InkWell(
        onTap: isDisabled ? null : () => group?.onChanged?.call(value),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Radio indicator
              _RadioIndicator(
                isSelected: isSelected,
                isDisabled: isDisabled,
              ),
              
              // Label
              if (label != null) ...[
                const SizedBox(width: 8),
                Flexible(child: label!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Custom radio indicator with animations
class _RadioIndicator extends StatelessWidget {
  final bool isSelected;
  final bool isDisabled;

  const _RadioIndicator({
    required this.isSelected,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDisabled 
              ? theme.disabledColor 
              : isSelected 
                  ? colorScheme.primary 
                  : theme.unselectedWidgetColor,
          width: 2,
        ),
        color: isDisabled 
            ? theme.disabledColor.withOpacity(0.1)
            : Colors.transparent,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected 
              ? (isDisabled ? theme.disabledColor : colorScheme.primary)
              : Colors.transparent,
        ),
        child: isSelected
            ? Icon(
                Icons.circle,
                size: 8,
                color: isDisabled 
                    ? theme.colorScheme.onSurface.withOpacity(0.3)
                    : colorScheme.onPrimary,
              )
            : null,
      ),
    );
  }
}

// Alternative using Flutter's built-in Radio with custom styling
class StyledRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool toggleable;
  final Widget? title;
  final String? semanticLabel;

  const StyledRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.title,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      toggleable: toggleable,
      title: title,
      dense: true,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      tileColor: theme.cardColor,
      activeColor: theme.colorScheme.primary,
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return theme.disabledColor;
        }
        if (states.contains(MaterialState.selected)) {
          return theme.colorScheme.primary;
        }
        return theme.unselectedWidgetColor;
      }),
    );
  }
}

// Simplified Radio Group using Flutter's built-in components
class SimpleRadioGroup extends StatefulWidget {
  final String? initialValue;
  final List<String> options;
  final ValueChanged<String?>? onChanged;
  final Axis direction;
  final double spacing;

  const SimpleRadioGroup({
    super.key,
    this.initialValue,
    required this.options,
    this.onChanged,
    this.direction = Axis.vertical,
    this.spacing = 8.0,
  });

  @override
  State<SimpleRadioGroup> createState() => _SimpleRadioGroupState();
}

class _SimpleRadioGroupState extends State<SimpleRadioGroup> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: widget.direction,
      spacing: widget.direction == Axis.horizontal ? widget.spacing : 0,
      runSpacing: widget.direction == Axis.vertical ? widget.spacing : 0,
      children: widget.options.map((option) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: option,
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
                widget.onChanged?.call(value);
              },
            ),
            const SizedBox(width: 4),
            Text(option),
          ],
        );
      }).toList(),
    );
  }
}

// Usage Examples
class RadioGroupExample extends StatefulWidget {
  const RadioGroupExample({super.key});

  @override
  State<RadioGroupExample> createState() => _RadioGroupExampleState();
}

class _RadioGroupExampleState extends State<RadioGroupExample> {
  String? _selectedOption = 'option1';
  String? _simpleSelectedOption = 'apple';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio Group Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom RadioGroup
            const Text('Custom RadioGroup:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            RadioGroup(
              value: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              children: const [
                RadioGroupItem(
                  value: 'option1',
                  label: Text('Option 1'),
                ),
                RadioGroupItem(
                  value: 'option2',
                  label: Text('Option 2'),
                ),
                RadioGroupItem(
                  value: 'option3',
                  label: Text('Option 3'),
                  disabled: true,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Horizontal RadioGroup
            const Text('Horizontal RadioGroup:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            RadioGroup(
              value: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              direction: Axis.horizontal,
              gap: 24.0,
              children: const [
                RadioGroupItem(
                  value: 'option1',
                  label: Text('Option 1'),
                ),
                RadioGroupItem(
                  value: 'option2',
                  label: Text('Option 2'),
                ),
                RadioGroupItem(
                  value: 'option3',
                  label: Text('Option 3'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Simple RadioGroup
            const Text('Simple RadioGroup:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            SimpleRadioGroup(
              initialValue: _simpleSelectedOption,
              options: const ['apple', 'banana', 'orange'],
              onChanged: (value) {
                setState(() {
                  _simpleSelectedOption = value;
                });
              },
            ),

            const SizedBox(height: 32),

            // Display selected values
            Text('Selected custom option: $_selectedOption',
                style: const TextStyle(fontSize: 14)),
            Text('Selected simple option: $_simpleSelectedOption',
                style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}