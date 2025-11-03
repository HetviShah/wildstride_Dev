import 'package:flutter/material.dart';

// Form controller for managing form state
class FormController {
  final Map<String, FormFieldState<dynamic>> _fields = {};
  final VoidCallback? onSubmit;
  final VoidCallback? onReset;

  FormController({this.onSubmit, this.onReset});

  void registerField(String name, FormFieldState<dynamic> field) {
    _fields[name] = field;
  }

  void unregisterField(String name) {
    _fields.remove(name);
  }

  bool validate() {
    bool isValid = true;
    for (final field in _fields.values) {
      if (!field.validate()) {
        isValid = false;
      }
    }
    return isValid;
  }

  Map<String, dynamic> get values {
    final values = <String, dynamic>{};
    for (final entry in _fields.entries) {
      values[entry.key] = entry.value.value;
    }
    return values;
  }

  void submit() {
    if (validate()) {
      onSubmit?.call();
    }
  }

  void reset() {
    for (final field in _fields.values) {
      field.reset();
    }
    onReset?.call();
  }

  bool get isValid => _fields.values.every((field) => field.isValid);
}

// Base form field state
abstract class FormFieldState<T> {
  bool get isValid;
  String? get errorText;
  T? get value;
  bool validate();
  void reset();
}

// Text form field state
class TextFormFieldState extends FormFieldState<String> {
  String? _value;
  String? _errorText;
  final List<FormFieldValidator<String>> validators;

  TextFormFieldState({this.validators = const []});

  @override
  bool get isValid => _errorText == null;

  @override
  String? get errorText => _errorText;

  @override
  String? get value => _value;

  set value(String? newValue) {
    _value = newValue;
    validate();
  }

  @override
  bool validate() {
    for (final validator in validators) {
      final error = validator(_value);
      if (error != null) {
        _errorText = error;
        return false;
      }
    }
    _errorText = null;
    return true;
  }

  @override
  void reset() {
    _value = null;
    _errorText = null;
  }
}

// Form field validator type
typedef FormFieldValidator<T> = String? Function(T? value);

// Common validators
class FormValidators {
  static FormFieldValidator<String> required({String? message}) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  static FormFieldValidator<String> email({String? message}) {
    return (value) {
      if (value != null && value.isNotEmpty) {
        final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (!emailRegex.hasMatch(value)) {
          return message ?? 'Please enter a valid email address';
        }
      }
      return null;
    };
  }

  static FormFieldValidator<String> minLength(int length, {String? message}) {
    return (value) {
      if (value != null && value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> maxLength(int length, {String? message}) {
    return (value) {
      if (value != null && value.length > length) {
        return message ?? 'Must be less than $length characters';
      }
      return null;
    };
  }

  static FormFieldValidator<String> pattern(RegExp pattern, {String? message}) {
    return (value) {
      if (value != null && value.isNotEmpty && !pattern.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }
}

// Form widget
class Form extends StatefulWidget {
  final Widget child;
  final FormController? controller;
  final VoidCallback? onSubmit;
  final VoidCallback? onReset;

  const Form({
    super.key,
    required this.child,
    this.controller,
    this.onSubmit,
    this.onReset,
  });

  @override
  State<Form> createState() => _FormState();

  static FormController of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_FormInherited>();
    if (inherited == null) {
      throw FlutterError('Form must be used within a Form widget');
    }
    return inherited.controller;
  }
}

class _FormState extends State<Form> {
  late FormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? FormController(
      onSubmit: widget.onSubmit,
      onReset: widget.onReset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _FormInherited(
      controller: _controller,
      child: widget.child,
    );
  }
}

// Form field widget
class FormField<T> extends StatefulWidget {
  final String name;
  final Widget Function(FormFieldState<T> state) builder;
  final List<FormFieldValidator<String>> validators;
  final T? initialValue;

  const FormField({
    super.key,
    required this.name,
    required this.builder,
    this.validators = const [],
    this.initialValue,
  });

  @override
  State<FormField<T>> createState() => _FormFieldState<T>();
}

class _FormFieldState<T> extends State<FormField<T>> implements FormFieldState<T> {
  late TextFormFieldState _state;

  @override
  void initState() {
    super.initState();
    _state = TextFormFieldState(validators: widget.validators);
    if (widget.initialValue != null) {
      _state.value = widget.initialValue.toString();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register with parent form
    final form = Form.of(context);
    form.registerField(widget.name, this);
  }

  @override
  void dispose() {
    final form = Form.of(context);
    form.unregisterField(widget.name);
    super.dispose();
  }

  @override
  bool get isValid => _state.isValid;

  @override
  String? get errorText => _state.errorText;

  @override
  T? get value => _state.value as T?;

  @override
  bool validate() {
    setState(() {
      _state.validate();
    });
    return isValid;
  }

  @override
  void reset() {
    setState(() {
      _state.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}

// Form item widget
class FormItem extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double gap;

  const FormItem({
    super.key,
    required this.child,
    this.padding,
    this.gap = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          SizedBox(height: gap),
        ],
      ),
    );
  }
}

// Form label widget
class FormLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool required;

  const FormLabel({
    super.key,
    required this.text,
    this.style,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      required ? '$text *' : text,
      style: (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

// Form control widget (wraps input fields)
class FormControl extends StatelessWidget {
  final Widget child;
  final String? errorText;

  const FormControl({
    super.key,
    required this.child,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

// Form description widget
class FormDescription extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const FormDescription({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }
}

// Form message widget (for errors)
class FormMessage extends StatelessWidget {
  final String? message;

  const FormMessage({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();

    return Text(
      message!,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

// Inherited widget for form state
class _FormInherited extends InheritedWidget {
  final FormController controller;

  const _FormInherited({
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(_FormInherited oldWidget) {
    return controller != oldWidget.controller;
  }
}