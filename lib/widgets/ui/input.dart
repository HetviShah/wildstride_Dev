import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool enabled;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? errorText;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final Color? fillColor;
  final TextStyle? style;
  final TextStyle? hintStyle;

  const Input({
    super.key,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.readOnly = false,
    this.onTap,
    this.errorText,
    this.contentPadding,
    this.border,
    this.fillColor,
    this.style,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      readOnly: readOnly,
      onTap: onTap,
      style: style ?? TextStyle(
        fontSize: 16, // text-base
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        filled: true,
        fillColor: fillColor ?? (theme.brightness == Brightness.dark 
            ? theme.colorScheme.surface.withOpacity(0.3)
            : theme.colorScheme.surface),
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        isDense: true,
        border: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: border ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: theme.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
        ),
        errorText: errorText,
      ),
    );
  }
}