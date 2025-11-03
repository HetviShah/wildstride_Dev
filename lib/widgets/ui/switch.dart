import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double width;
  final double height;
  final double thumbSize;
  final Duration duration;
  final EdgeInsetsGeometry? padding;

  const CustomSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.width = 32.0,
    this.height = 18.0,
    this.thumbSize = 16.0,
    this.duration = const Duration(milliseconds: 200),
    this.padding,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _thumbAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _thumbAnimation = Tween<double>(
      begin: 0,
      end: widget.width - widget.thumbSize - 2, // 2px margin
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Set initial position based on value
    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.disabled || widget.onChanged == null) return;
    widget.onChanged!(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final activeColor = widget.activeColor ?? colorScheme.primary;
    final inactiveColor = widget.inactiveColor ?? theme.colorScheme.surfaceVariant;
    final thumbColor = widget.thumbColor ?? theme.colorScheme.background;

    return IgnorePointer(
      ignoring: widget.disabled,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: widget.padding,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    // Track
                    Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        color: widget.value ? activeColor : inactiveColor,
                        borderRadius: BorderRadius.circular(widget.height / 2),
                      ),
                    ),
                    
                    // Thumb
                    Positioned(
                      left: _thumbAnimation.value,
                      top: (widget.height - widget.thumbSize) / 2,
                      child: Container(
                        width: widget.thumbSize,
                        height: widget.thumbSize,
                        decoration: BoxDecoration(
                          color: thumbColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Correct implementation using Flutter's built-in Switch with proper parameters
class MaterialDesignSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;
  final Color? activeColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;

  const MaterialDesignSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.activeColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // For Flutter's built-in Switch, we need to handle colors differently
    // based on whether the switch is on or off
    final activeTrackColor = activeColor ?? theme.colorScheme.primary;
    final activeThumbColor = theme.colorScheme.onPrimary; // This variable is now used
    
    final trackColor = inactiveTrackColor ?? theme.colorScheme.surfaceVariant;
    final thumbColor = inactiveThumbColor ?? theme.colorScheme.background;

    return Switch(
      value: value,
      onChanged: disabled ? null : onChanged,
      // These are the actual correct parameter names for Flutter's Switch
      activeTrackColor: activeTrackColor,
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return activeThumbColor; // Now used here
        }
        return thumbColor;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return activeTrackColor;
        }
        return trackColor;
      }),
    );
  }
}

// Switch with label
class LabeledSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool disabled;
  final TextStyle? labelStyle;
  final MainAxisAlignment alignment;
  final double spacing;
  final bool useMaterialSwitch;

  const LabeledSwitch({
    super.key,
    required this.label,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.labelStyle,
    this.alignment = MainAxisAlignment.spaceBetween,
    this.spacing = 8.0,
    this.useMaterialSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : () => onChanged?.call(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            Text(
              label,
              style: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(width: spacing),
            useMaterialSwitch
                ? MaterialDesignSwitch(
                    value: value,
                    onChanged: disabled ? null : onChanged,
                  )
                : CustomSwitch(
                    value: value,
                    onChanged: disabled ? null : onChanged,
                  ),
          ],
        ),
      ),
    );
  }
}

// Example usage
class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool _switch1 = false;
  bool _switch2 = true;
  bool _switch3 = false;
  bool _switch4 = true;
  bool _switch5 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Switch Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom switch implementation
            Text('Custom Switch Implementation', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Basic Switch'),
                CustomSwitch(
                  value: _switch1,
                  onChanged: (value) => setState(() => _switch1 = value),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Active Switch'),
                CustomSwitch(
                  value: _switch2,
                  onChanged: (value) => setState(() => _switch2 = value),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Disabled Switch'),
                CustomSwitch(
                  value: _switch3,
                  onChanged: null, // This disables the switch
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Custom Colors'),
                CustomSwitch(
                  value: _switch4,
                  onChanged: (value) => setState(() => _switch4 = value),
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey[300],
                  thumbColor: Colors.white,
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Labeled switches
            Text('Labeled Switches', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            
            LabeledSwitch(
              label: 'Wi-Fi',
              value: _switch1,
              onChanged: (value) => setState(() => _switch1 = value),
            ),
            
            LabeledSwitch(
              label: 'Bluetooth',
              value: _switch2,
              onChanged: (value) => setState(() => _switch2 = value),
            ),
            
            LabeledSwitch(
              label: 'Airplane Mode',
              value: _switch3,
              onChanged: (value) => setState(() => _switch3 = value),
              disabled: true,
            ),
            
            const SizedBox(height: 32),
            
            // Flutter's built-in switch with correct parameter names
            Text('Flutter Built-in Switch', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Material Switch'),
                MaterialDesignSwitch(
                  value: _switch5,
                  onChanged: (value) => setState(() => _switch5 = value),
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Default Material Switch'),
                Switch(
                  value: _switch5,
                  onChanged: (value) => setState(() => _switch5 = value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}