import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputOTP extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final bool autoFocus;
  final bool enabled;
  final OTPInputStyle? style;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;

  const InputOTP({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.autoFocus = false,
    this.enabled = true,
    this.style,
    this.keyboardType = TextInputType.number,
    this.obscureText = false,
    this.obscuringCharacter = '•',
  });

  @override
  State<InputOTP> createState() => _InputOTPState();
}

class _InputOTPState extends State<InputOTP> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late List<String> _values;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  @override
  void didUpdateWidget(InputOTP oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.length != widget.length) {
      _disposeFields();
      _initializeFields();
    }
  }

  void _initializeFields() {
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers = List.generate(widget.length, (index) => TextEditingController());
    _values = List.filled(widget.length, '');

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        _onTextChanged(i, _controllers[i].text);
      });
    }

    if (widget.autoFocus && widget.length > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      });
    }
  }

  void _disposeFields() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    _focusNodes.clear();
    _controllers.clear();
    _values.clear();
  }

  void _onTextChanged(int index, String text) {
    if (text.isNotEmpty) {
      if (text.length > 1) {
        _handlePaste(text, index);
        return;
      }

      _values[index] = text;
      
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _notifyChanges();
      }
    } else {
      _values[index] = '';
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    _notifyChanges();
  }

  void _handlePaste(String text, int startIndex) {
    final remainingFields = widget.length - startIndex;
    final pasteLength = text.length > remainingFields ? remainingFields : text.length;
    
    for (int i = 0; i < pasteLength; i++) {
      final index = startIndex + i;
      if (index < widget.length) {
        _values[index] = text[i];
        _controllers[index].text = text[i];
      }
    }
    
    final nextIndex = startIndex + pasteLength;
    if (nextIndex < widget.length) {
      _focusNodes[nextIndex].requestFocus();
    } else if (widget.length > 0) {
      _focusNodes[widget.length - 1].unfocus();
    }
    
    _notifyChanges();
  }

  void _notifyChanges() {
    final otpValue = _values.join();
    widget.onChanged?.call(otpValue);
    
    if (otpValue.length == widget.length) {
      widget.onCompleted?.call(otpValue);
    }
  }

  void _onFieldTapped(int index) {
    for (int i = 0; i < widget.length; i++) {
      if (_values[i].isEmpty) {
        _focusNodes[i].requestFocus();
        return;
      }
    }
    _focusNodes[widget.length - 1].requestFocus();
  }

  void _handleKeyEvent(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_values[index].isEmpty && index > 0) {
        _focusNodes[index - 1].requestFocus();
        _values[index - 1] = '';
        _controllers[index - 1].text = '';
        _notifyChanges();
      } else if (_values[index].isNotEmpty) {
        _values[index] = '';
        _controllers[index].text = '';
        _notifyChanges();
      }
    }
  }

  @override
  void dispose() {
    _disposeFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? OTPInputStyle.defaultStyle(context);

    return OTPInputGroup(
      style: style,
      children: List.generate(widget.length, (index) {
        final shouldAddSeparator = index > 0 && index % 3 == 0;
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (shouldAddSeparator) 
              OTPInputSeparator(style: style),
            OTPInputSlot(
              focusNode: _focusNodes[index],
              controller: _controllers[index],
              value: _values[index],
              index: index,
              enabled: widget.enabled,
              style: style,
              obscureText: widget.obscureText,
              obscuringCharacter: widget.obscuringCharacter,
              onTap: () => _onFieldTapped(index),
              onKeyEvent: (event) => _handleKeyEvent(event, index),
            ),
          ],
        );
      }),
    );
  }
}

class OTPInputGroup extends StatelessWidget {
  final List<Widget> children;
  final OTPInputStyle style;

  const OTPInputGroup({
    super.key,
    required this.children,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class OTPInputSlot extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;
  final String value;
  final int index;
  final bool enabled;
  final OTPInputStyle style;
  final bool obscureText;
  final String obscuringCharacter;
  final VoidCallback onTap;
  final ValueChanged<RawKeyEvent> onKeyEvent;

  const OTPInputSlot({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.value,
    required this.index,
    required this.enabled,
    required this.style,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.onTap,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = focusNode.hasFocus;
    final displayValue = obscureText && value.isNotEmpty 
        ? obscuringCharacter 
        : value;

    return Container(
      width: style.slotWidth,
      height: style.slotHeight,
      margin: style.slotMargin,
      decoration: BoxDecoration(
        color: enabled ? style.backgroundColor : style.disabledBackgroundColor,
        border: Border.all(
          color: isActive ? style.activeBorderColor : style.borderColor,
          width: isActive ? style.activeBorderWidth : style.borderWidth,
        ),
        borderRadius: style.borderRadius,
      ),
      child: RawKeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKey: onKeyEvent,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: Stack(
            children: [
              // Hidden text field
              Opacity(
                opacity: 0,
                child: TextField(
                  focusNode: focusNode,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  enabled: enabled,
                  style: const TextStyle(fontSize: 1),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              
              // Visual display
              Center(
                child: Text(
                  displayValue,
                  style: (style.textStyle ?? TextStyle()).copyWith(
                    color: enabled ? style.textColor : style.disabledColor,
                  ),
                ),
              ),
              
              // Caret indicator
              if (isActive && value.isEmpty && enabled)
                Positioned(
                  bottom: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _AnimatedCaret(color: style.caretColor),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCaret extends StatefulWidget {
  final Color color;

  const _AnimatedCaret({required this.color});

  @override
  State<_AnimatedCaret> createState() => _AnimatedCaretState();
}

class _AnimatedCaretState extends State<_AnimatedCaret> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: child,
        );
      },
      child: Container(
        width: 2,
        height: 20,
        color: widget.color,
      ),
    );
  }
}

class OTPInputSeparator extends StatelessWidget {
  final OTPInputStyle style;

  const OTPInputSeparator({
    super.key,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style.separatorPadding,
      child: Icon(
        Icons.remove,
        size: style.separatorSize,
        color: style.separatorColor,
      ),
    );
  }
}

class OTPInputStyle {
  final double slotWidth;
  final double slotHeight;
  final EdgeInsets slotMargin;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color borderColor;
  final Color activeBorderColor;
  final double borderWidth;
  final double activeBorderWidth;
  final BorderRadius borderRadius;
  final TextStyle? textStyle;
  final Color textColor;
  final Color disabledColor;
  final Color caretColor;
  final EdgeInsets separatorPadding;
  final double separatorSize;
  final Color separatorColor;

  const OTPInputStyle({
    this.slotWidth = 48,
    this.slotHeight = 48,
    this.slotMargin = const EdgeInsets.symmetric(horizontal: 4),
    this.backgroundColor = Colors.white,
    this.disabledBackgroundColor = const Color(0xFFE0E0E0), // Use const Color
    this.borderColor = const Color(0xFF9E9E9E),
    this.activeBorderColor = const Color(0xFF2196F3),
    this.borderWidth = 1,
    this.activeBorderWidth = 2,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.textStyle,
    this.textColor = Colors.black,
    this.disabledColor = const Color(0xFF9E9E9E),
    this.caretColor = Colors.black,
    this.separatorPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.separatorSize = 16,
    this.separatorColor = const Color(0xFF9E9E9E),
  });

  factory OTPInputStyle.defaultStyle(BuildContext context) {
    final theme = Theme.of(context);
    return OTPInputStyle(
      backgroundColor: theme.colorScheme.surface,
      disabledBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
      borderColor: theme.colorScheme.outline,
      activeBorderColor: theme.colorScheme.primary,
      textColor: theme.colorScheme.onSurface,
      disabledColor: theme.colorScheme.onSurface.withOpacity(0.38),
      caretColor: theme.colorScheme.primary,
      separatorColor: theme.colorScheme.outline,
    );
  }
}