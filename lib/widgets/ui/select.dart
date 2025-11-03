import 'package:flutter/material.dart';

// Select Root Component
class Select extends StatefulWidget {
  final Widget? trigger;
  final List<Widget> children;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final bool disabled;

  const Select({
    super.key,
    this.trigger,
    required this.children,
    this.value,
    this.onChanged,
    this.disabled = false,
  });

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: widget.value,
        onChanged: widget.disabled ? null : widget.onChanged,
        items: widget.children
            .whereType<DropdownMenuItem<String>>()
            .toList(),
        isExpanded: true,
        hint: widget.trigger,
      ),
    );
  }
}

// Select Group Component
class SelectGroup extends StatelessWidget {
  final String? label;
  final List<Widget> children;

  const SelectGroup({
    super.key,
    this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
        ...children,
      ],
    );
  }
}

// Select Trigger Component
class SelectTrigger extends StatelessWidget {
  final String? placeholder;
  final Widget? child;
  final SelectSize size;
  final bool disabled;

  const SelectTrigger({
    super.key,
    this.placeholder,
    this.child,
    this.size = SelectSize.defaultSize,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: disabled 
              ? theme.disabledColor 
              : theme.dividerColor,
        ),
        borderRadius: BorderRadius.circular(8),
        color: disabled 
            ? theme.disabledColor.withOpacity(0.1)
            : theme.cardColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: size == SelectSize.sm ? 32 : 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: child ?? Text(
              placeholder ?? 'Select...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: placeholder != null 
                    ? theme.hintColor 
                    : theme.textTheme.bodyMedium?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.arrow_drop_down,
            size: 16,
            color: theme.hintColor,
          ),
        ],
      ),
    );
  }
}

// Select Item Component
class SelectItem extends StatelessWidget {
  final String value;
  final String label;
  final Widget? leading;
  final bool selected;
  final bool disabled;

  const SelectItem({
    super.key,
    required this.value,
    required this.label,
    this.leading,
    this.selected = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownMenuItem<String>(
      value: value,
      enabled: !disabled,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: disabled ? theme.disabledColor : null,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check,
                size: 16,
                color: theme.colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// Select Label Component
class SelectLabel extends StatelessWidget {
  final String text;

  const SelectLabel({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor,
            ),
      ),
    );
  }
}

// Select Separator Component
class SelectSeparator extends StatelessWidget {
  const SelectSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}

// Select Content Component (Custom Dropdown)
class SelectContent extends StatelessWidget {
  final List<Widget> children;
  final double? width;

  const SelectContent({
    super.key,
    required this.children,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

// Size enum
enum SelectSize { sm, defaultSize }

// Utility class for styling
class SelectUtils {
  static BoxDecoration getTriggerDecoration(BuildContext context, {bool disabled = false, SelectSize size = SelectSize.defaultSize}) {
    final theme = Theme.of(context);
    return BoxDecoration(
      border: Border.all(
        color: disabled ? theme.disabledColor : theme.dividerColor,
      ),
      borderRadius: BorderRadius.circular(8),
      color: disabled ? theme.disabledColor.withOpacity(0.1) : theme.cardColor,
    );
  }

  static EdgeInsetsGeometry getTriggerPadding(SelectSize size) {
    return const EdgeInsets.symmetric(horizontal: 12);
  }

  static double getTriggerHeight(SelectSize size) {
    return size == SelectSize.sm ? 32 : 36;
  }
}

// Example usage
class SelectExample extends StatefulWidget {
  const SelectExample({super.key});

  @override
  State<SelectExample> createState() => _SelectExampleState();
}

class _SelectExampleState extends State<SelectExample> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Select(
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
      trigger: SelectTrigger(
        placeholder: 'Select an option',
        child: selectedValue != null 
            ? Text(selectedValue!)
            : null,
      ),
      children: [
        SelectGroup(
          label: 'Fruits',
          children: [
            SelectItem(
              value: 'apple',
              label: 'Apple',
              selected: selectedValue == 'apple',
            ),
            SelectItem(
              value: 'banana',
              label: 'Banana',
              selected: selectedValue == 'banana',
            ),
          ],
        ),
        const SelectSeparator(),
        SelectGroup(
          label: 'Vegetables',
          children: [
            SelectItem(
              value: 'carrot',
              label: 'Carrot',
              selected: selectedValue == 'carrot',
            ),
            SelectItem(
              value: 'broccoli',
              label: 'Broccoli',
              selected: selectedValue == 'broccoli',
            ),
          ],
        ),
      ],
    );
  }
}