import 'package:flutter/material.dart';

class Slider extends StatefulWidget {
  final List<double>? defaultValue;
  final List<double>? value;
  final double min;
  final double max;
  final ValueChanged<List<double>>? onChanged;
  final ValueChanged<List<double>>? onChangeEnd;
  final bool disabled;
  final Axis orientation;
  final Color? trackColor;
  final Color? activeTrackColor;
  final Color? thumbColor;
  final EdgeInsets? padding;
  final String? semanticLabel;

  const Slider({
    super.key,
    this.defaultValue,
    this.value,
    this.min = 0,
    this.max = 100,
    this.onChanged,
    this.onChangeEnd,
    this.disabled = false,
    this.orientation = Axis.horizontal,
    this.trackColor,
    this.activeTrackColor,
    this.thumbColor,
    this.padding,
    this.semanticLabel,
  });

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  late List<double> _values;
  late List<Color> _thumbColors;

  @override
  void initState() {
    super.initState();
    _initializeValues();
    _initializeThumbColors();
  }

  @override
  void didUpdateWidget(Slider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.defaultValue != widget.defaultValue ||
        oldWidget.min != widget.min ||
        oldWidget.max != widget.max) {
      _initializeValues();
    }
  }

  void _initializeValues() {
    if (widget.value != null) {
      _values = List<double>.from(widget.value!);
    } else if (widget.defaultValue != null) {
      _values = List<double>.from(widget.defaultValue!);
    } else {
      _values = [widget.min, widget.max];
    }
    
    // Ensure values are within min/max bounds
    for (int i = 0; i < _values.length; i++) {
      _values[i] = _values[i].clamp(widget.min, widget.max);
    }
  }

  void _initializeThumbColors() {
    _thumbColors = List<Color>.generate(
      _values.length,
      (index) => widget.thumbColor ?? Theme.of(context).colorScheme.primary,
    );
  }

  void _updateValue(int index, double newValue) {
    if (widget.disabled) return;

    setState(() {
      _values[index] = newValue.clamp(widget.min, widget.max);
    });

    widget.onChanged?.call(List<double>.from(_values));
  }

  void _onDragEnd() {
    widget.onChangeEnd?.call(List<double>.from(_values));
  }

  double _getNormalizedValue(double value) {
    return (value - widget.min) / (widget.max - widget.min);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final trackColor = widget.trackColor ?? colorScheme.surfaceVariant;
    final activeTrackColor = widget.activeTrackColor ?? colorScheme.primary;
    final thumbColor = widget.thumbColor ?? colorScheme.primary;

    return IgnorePointer(
      ignoring: widget.disabled,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: Semantics(
          label: widget.semanticLabel,
          child: Container(
            padding: widget.padding,
            constraints: widget.orientation == Axis.vertical
                ? const BoxConstraints(minHeight: 176) // min-h-44 equivalent
                : null,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = widget.orientation == Axis.horizontal
                    ? constraints.maxWidth
                    : constraints.maxHeight;
                
                return Stack(
                  children: [
                    // Track
                    _buildTrack(theme, trackColor, size),
                    // Active Range
                    _buildActiveRange(theme, activeTrackColor, size),
                    // Thumbs
                    ..._buildThumbs(theme, thumbColor, size),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrack(ThemeData theme, Color trackColor, double size) {
    return Container(
      width: widget.orientation == Axis.horizontal ? double.infinity : 6,
      height: widget.orientation == Axis.horizontal ? 4 : double.infinity,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(9999), // Fully rounded
      ),
    );
  }

  Widget _buildActiveRange(ThemeData theme, Color activeColor, double size) {
    if (_values.length < 2) return const SizedBox.shrink();

    final minValue = _values.reduce((a, b) => a < b ? a : b);
    final maxValue = _values.reduce((a, b) => a > b ? a : b);

    final start = _getNormalizedValue(minValue);
    final end = _getNormalizedValue(maxValue);

    return Positioned(
      left: widget.orientation == Axis.horizontal ? start * size : null,
      top: widget.orientation == Axis.vertical ? start * size : null,
      child: Container(
        width: widget.orientation == Axis.horizontal ? (end - start) * size : 6,
        height: widget.orientation == Axis.horizontal ? 4 : (end - start) * size,
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(9999),
        ),
      ),
    );
  }

  List<Widget> _buildThumbs(ThemeData theme, Color thumbColor, double size) {
    return _values.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final normalizedValue = _getNormalizedValue(value);

      return Positioned(
        left: widget.orientation == Axis.horizontal ? normalizedValue * size - 8 : null,
        top: widget.orientation == Axis.vertical ? normalizedValue * size - 8 : null,
        child: _buildThumb(theme, thumbColor, index),
      );
    }).toList();
  }

  Widget _buildThumb(ThemeData theme, Color thumbColor, int index) {
    return GestureDetector(
      onPanStart: (details) {
        _thumbColors[index] = thumbColor.withOpacity(0.5);
        setState(() {});
      },
      onPanUpdate: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        
        double newValue;
        if (widget.orientation == Axis.horizontal) {
          final fraction = (localPosition.dx / renderBox.size.width).clamp(0.0, 1.0);
          newValue = widget.min + fraction * (widget.max - widget.min);
        } else {
          final fraction = (localPosition.dy / renderBox.size.height).clamp(0.0, 1.0);
          newValue = widget.min + fraction * (widget.max - widget.min);
        }
        
        _updateValue(index, newValue);
      },
      onPanEnd: (details) {
        _thumbColors[index] = thumbColor;
        setState(() {});
        _onDragEnd();
      },
      onPanCancel: () {
        _thumbColors[index] = thumbColor;
        setState(() {});
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border.all(color: thumbColor, width: 1),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () {}, // Handle tap if needed
            ),
          ),
        ),
      ),
    );
  }
}

// Single value slider variant
class SingleSlider extends StatefulWidget {
  final double? defaultValue;
  final double? value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeEnd;
  final bool disabled;
  final Axis orientation;
  final Color? trackColor;
  final Color? activeTrackColor;
  final Color? thumbColor;
  final int? divisions;
  final String? label;

  const SingleSlider({
    super.key,
    this.defaultValue,
    this.value,
    this.min = 0,
    this.max = 100,
    this.onChanged,
    this.onChangeEnd,
    this.disabled = false,
    this.orientation = Axis.horizontal,
    this.trackColor,
    this.activeTrackColor,
    this.thumbColor,
    this.divisions,
    this.label,
  });

  @override
  State<SingleSlider> createState() => _SingleSliderState();
}

class _SingleSliderState extends State<SingleSlider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? widget.defaultValue ?? widget.min;
  }

  @override
  void didUpdateWidget(SingleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != _value) {
      _value = widget.value!;
    }
  }

  void _updateValue(double newValue) {
    if (widget.disabled) return;

    setState(() {
      _value = newValue.clamp(widget.min, widget.max);
    });

    widget.onChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: [_value],
      min: widget.min,
      max: widget.max,
      onChanged: (values) => _updateValue(values.first),
      onChangeEnd: widget.onChangeEnd != null 
          ? (values) => widget.onChangeEnd!(values.first)
          : null,
      disabled: widget.disabled,
      orientation: widget.orientation,
      trackColor: widget.trackColor,
      activeTrackColor: widget.activeTrackColor,
      thumbColor: widget.thumbColor,
    );
  }
}

// Example usage
class SliderExample extends StatefulWidget {
  const SliderExample({super.key});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  List<double> _rangeValues = [20, 80];
  double _singleValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slider Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Range Slider: ${_rangeValues[0].round()} - ${_rangeValues[1].round()}'),
            const SizedBox(height: 8),
            Slider(
              value: _rangeValues,
              min: 0,
              max: 100,
              onChanged: (values) {
                setState(() {
                  _rangeValues = values;
                });
              },
            ),
            const SizedBox(height: 32),
            Text('Single Slider: ${_singleValue.round()}'),
            const SizedBox(height: 8),
            SingleSlider(
              value: _singleValue,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _singleValue = value;
                });
              },
            ),
            const SizedBox(height: 32),
            Text('Disabled Slider'),
            const SizedBox(height: 8),
            Slider(
              value: [30, 70],
              min: 0,
              max: 100,
              disabled: true,
            ),
            const SizedBox(height: 32),
            Text('Vertical Slider'),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  SingleSlider(
                    value: _singleValue,
                    min: 0,
                    max: 100,
                    orientation: Axis.vertical,
                    onChanged: (value) {
                      setState(() {
                        _singleValue = value;
                      });
                    },
                  ),
                  const SizedBox(width: 32),
                  SizedBox(
                    height: 200,
                    child: Slider(
                      value: _rangeValues,
                      min: 0,
                      max: 100,
                      orientation: Axis.vertical,
                      onChanged: (values) {
                        setState(() {
                          _rangeValues = values;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}