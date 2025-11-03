import 'package:flutter/material.dart';

class Textarea extends StatefulWidget {
  final String? value;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final EdgeInsets? padding;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final StrutStyle? strutStyle;
  final TextSelectionControls? selectionControls;
  final bool expands;
  final bool showCursor;
  final double? cursorHeight;
  final FocusNode? focusNode;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final TextAlignVertical? textAlignVertical;
  final Widget? Function(BuildContext, {required int currentLength, required bool isFocused, required int? maxLength})? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;

  const Textarea({
    Key? key,
    this.value,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.padding,
    this.decoration,
    this.style,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.strutStyle,
    this.selectionControls,
    this.expands = false,
    this.showCursor = true, // Added default value
    this.cursorHeight,
    this.focusNode,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.textAlignVertical,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
  }) : super(key: key);

  @override
  _TextareaState createState() => _TextareaState();
}

class _TextareaState extends State<Textarea> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value ?? '');
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(Textarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default styling based on your React component
    final defaultDecoration = InputDecoration(
      hintText: widget.hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.12),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.12),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 2.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.04),
        ),
      ),
      filled: true,
      fillColor: isDark 
          ? theme.colorScheme.onSurface.withOpacity(0.06)
          : theme.colorScheme.surface,
      contentPadding: widget.padding ?? const EdgeInsets.all(12.0),
      counter: widget.buildCounter?.call(
        context,
        currentLength: _controller.text.length,
        isFocused: _focusNode.hasFocus,
        maxLength: widget.maxLength,
      ),
    );

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines ?? (widget.maxLines == 1 ? 1 : 5),
      maxLength: widget.maxLength,
      keyboardType: widget.keyboardType ?? TextInputType.multiline,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      decoration: widget.decoration ?? defaultDecoration,
      style: widget.style ?? theme.textTheme.bodyMedium,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      cursorWidth: widget.cursorWidth ?? 2.0,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor ?? theme.colorScheme.primary,
      keyboardAppearance: widget.keyboardAppearance,
      strutStyle: widget.strutStyle,
      selectionControls: widget.selectionControls,
      expands: widget.expands,
      showCursor: widget.showCursor,
      cursorHeight: widget.cursorHeight,
      scrollPadding: widget.scrollPadding,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      textAlignVertical: widget.textAlignVertical,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      restorationId: widget.restorationId,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
    );
  }
}

// Even simpler version for basic usage:
class SimpleTextarea extends StatelessWidget {
  final String? value;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLines;
  final int? minLines;

  const SimpleTextarea({
    Key? key,
    this.value,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.maxLines,
    this.minLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: TextEditingController(text: value ?? ''),
      onChanged: onChanged,
      enabled: enabled,
      maxLines: maxLines ?? 5,
      minLines: minLines ?? 3,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: isDark 
            ? theme.colorScheme.onSurface.withOpacity(0.06)
            : theme.colorScheme.surface,
        contentPadding: const EdgeInsets.all(12.0),
      ),
      style: theme.textTheme.bodyMedium,
    );
  }
}