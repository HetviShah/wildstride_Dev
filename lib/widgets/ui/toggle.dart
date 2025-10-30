import 'package:flutter/material.dart';

enum ToggleVariant {
  defaultVariant,
  outline,
}

enum ToggleSize {
  sm,
  defaultSize,
  lg,
}

class Toggle extends StatefulWidget {
  final bool isOn;
  final ValueChanged<bool>? onChanged;
  final ToggleVariant variant;
  final ToggleSize size;
  final Widget? child;
  final bool disabled;
  final String? semanticLabel;

  const Toggle({
    Key? key,
    required this.isOn,
    this.onChanged,
    this.variant = ToggleVariant.defaultVariant,
    this.size = ToggleSize.defaultSize,
    this.child,
    this.disabled = false,
    this.semanticLabel,
  }) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> {
  bool _isOn = false;

  @override
  void initState() {
    super.initState();
    _isOn = widget.isOn;
  }

  @override
  void didUpdateWidget(Toggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOn != widget.isOn) {
      setState(() {
        _isOn = widget.isOn;
      });
    }
  }

  void _handleTap() {
    if (widget.disabled || widget.onChanged == null) return;
    
    setState(() {
      _isOn = !_isOn;
    });
    
    widget.onChanged!(_isOn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final styles = _ToggleStyles(
      variant: widget.variant,
      size: widget.size,
      isOn: _isOn,
      disabled: widget.disabled,
      theme: theme,
    );

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: !widget.disabled,
      toggled: _isOn,
      child: GestureDetector(
        onTap: _handleTap,
        child: MouseRegion(
          cursor: widget.disabled 
              ? SystemMouseCursors.basic 
              : SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: styles.decoration,
            padding: styles.padding,
            constraints: styles.constraints,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.child != null) 
                  DefaultTextStyle(
                    style: TextStyle(
                      color: styles.foregroundColor,
                      fontSize: styles.textSize,
                      fontWeight: FontWeight.w500,
                    ),
                    child: widget.child!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleStyles {
  final ToggleVariant variant;
  final ToggleSize size;
  final bool isOn;
  final bool disabled;
  final ThemeData theme;

  _ToggleStyles({
    required this.variant,
    required this.size,
    required this.isOn,
    required this.disabled,
    required this.theme,
  });

  Color get foregroundColor {
    if (disabled) {
      return theme.colorScheme.onSurface.withOpacity(0.38);
    } else if (isOn) {
      return theme.colorScheme.onSecondaryContainer;
    } else {
      return theme.colorScheme.onSurfaceVariant;
    }
  }

  double get textSize {
    switch (size) {
      case ToggleSize.sm:
        return 12.0;
      case ToggleSize.defaultSize:
        return 14.0;
      case ToggleSize.lg:
        return 16.0;
    }
  }

  BoxDecoration get decoration {
    final border = variant == ToggleVariant.outline
        ? Border.all(
            color: disabled 
                ? theme.colorScheme.onSurface.withOpacity(0.12)
                : theme.colorScheme.outline,
          )
        : null;

    Color backgroundColor;
    
    if (disabled) {
      backgroundColor = Colors.transparent;
    } else if (isOn) {
      backgroundColor = theme.colorScheme.secondaryContainer;
    } else {
      backgroundColor = Colors.transparent;
    }

    return BoxDecoration(
      color: backgroundColor,
      border: border,
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  EdgeInsets get padding {
    switch (size) {
      case ToggleSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
      case ToggleSize.defaultSize:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
      case ToggleSize.lg:
        return const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0);
    }
  }

  BoxConstraints get constraints {
    switch (size) {
      case ToggleSize.sm:
        return const BoxConstraints(
          minWidth: 32.0,
          minHeight: 32.0,
        );
      case ToggleSize.defaultSize:
        return const BoxConstraints(
          minWidth: 36.0,
          minHeight: 36.0,
        );
      case ToggleSize.lg:
        return const BoxConstraints(
          minWidth: 40.0,
          minHeight: 40.0,
        );
    }
  }
}

// Example usage:
class ToggleExample extends StatefulWidget {
  const ToggleExample({Key? key}) : super(key: key);

  @override
  State<ToggleExample> createState() => _ToggleExampleState();
}

class _ToggleExampleState extends State<ToggleExample> {
  bool _toggle1 = true;
  bool _toggle2 = false;
  bool _toggle3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toggle Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Toggle(
              isOn: _toggle1,
              onChanged: (value) => setState(() => _toggle1 = value),
              child: const Text('Default Toggle'),
            ),
            const SizedBox(height: 16),
            Toggle(
              isOn: _toggle2,
              onChanged: (value) => setState(() => _toggle2 = value),
              variant: ToggleVariant.outline,
              child: const Text('Outline Toggle'),
            ),
            const SizedBox(height: 16),
            Toggle(
              isOn: _toggle3,
              onChanged: null, // disabled
              size: ToggleSize.sm,
              child: const Text('Small Disabled Toggle'),
            ),
          ],
        ),
      ),
    );
  }
}