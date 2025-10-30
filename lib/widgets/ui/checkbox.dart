import 'package:flutter/material.dart';

class Checkbox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final Color? activeColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final bool disabled;

  const Checkbox({
    super.key,
    this.value,
    this.onChanged,
    this.tristate = false,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 4,
    this.disabled = false,
  });

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveValue = widget.disabled ? null : widget.value;
    final effectiveOnChanged = widget.disabled ? null : widget.onChanged;

    // Determine colors based on state
    final Color effectiveBorderColor;
    final Color effectiveFillColor;

    if (widget.disabled) {
      effectiveBorderColor = colorScheme.onSurface.withOpacity(0.12);
      effectiveFillColor = colorScheme.onSurface.withOpacity(0.12);
    } else if (effectiveValue == true) {
      effectiveBorderColor = widget.activeColor ?? colorScheme.primary;
      effectiveFillColor = widget.activeColor ?? colorScheme.primary;
    } else {
      effectiveBorderColor = widget.borderColor ?? colorScheme.outline;
      effectiveFillColor = widget.fillColor ?? theme.cardColor;
    }

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: effectiveFillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: effectiveBorderColor,
          width: widget.borderWidth,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: effectiveOnChanged != null
              ? () {
                  if (widget.tristate) {
                    if (effectiveValue == null) {
                      effectiveOnChanged(true);
                    } else if (effectiveValue == true) {
                      effectiveOnChanged(false);
                    } else {
                      effectiveOnChanged(null);
                    }
                  } else {
                    effectiveOnChanged(!(effectiveValue ?? false));
                  }
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _buildCheckIcon(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckIcon(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    if (widget.value == true) {
      return Icon(
        Icons.check,
        size: 14,
        color: widget.disabled 
            ? colorScheme.onSurface.withOpacity(0.38)
            : widget.checkColor ?? colorScheme.onPrimary,
      );
    } else if (widget.tristate && widget.value == null) {
      return Container(
        width: 8,
        height: 2,
        color: widget.disabled
            ? colorScheme.onSurface.withOpacity(0.38)
            : colorScheme.onPrimary,
      );
    }
    
    return const SizedBox.shrink();
  }
}

// Alternative: Using Flutter's built-in Checkbox with custom styling
class CustomCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final bool tristate;
  final Color? activeColor;
  final Color? checkColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final bool disabled;

  const CustomCheckbox({
    super.key,
    this.value,
    this.onChanged,
    this.tristate = false,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Theme(
      data: theme.copyWith(
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: MaterialStateBorderSide.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return BorderSide(
                color: activeColor ?? colorScheme.primary,
                width: 1,
              );
            }
            return BorderSide(
              color: colorScheme.outline,
              width: 1,
            );
          }),
          fillColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return activeColor ?? colorScheme.primary;
            }
            return theme.cardColor;
          }),
          checkColor: MaterialStateProperty.all(
            checkColor ?? colorScheme.onPrimary,
          ),
        ),
      ),
      child: Checkbox(
        value: value,
        onChanged: disabled ? null : onChanged,
        tristate: tristate,
        materialTapTargetSize: materialTapTargetSize,
      ),
    );
  }
}