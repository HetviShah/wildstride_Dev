import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final Axis orientation;
  final bool decorative;
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const Separator({
    super.key,
    this.orientation = Axis.horizontal,
    this.decorative = true,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final separatorColor = color ?? theme.dividerColor;
    final separatorThickness = thickness ?? 1.0;

    if (orientation == Axis.horizontal) {
      return Divider(
        height: separatorThickness,
        thickness: separatorThickness,
        color: separatorColor,
        indent: indent,
        endIndent: endIndent,
      );
    } else {
      return VerticalDivider(
        width: separatorThickness,
        thickness: separatorThickness,
        color: separatorColor,
        indent: indent,
        endIndent: endIndent,
      );
    }
  }
}

// Alternative implementation using Container for more customization
class CustomSeparator extends StatelessWidget {
  final Axis orientation;
  final bool decorative;
  final double thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;

  const CustomSeparator({
    super.key,
    this.orientation = Axis.horizontal,
    this.decorative = true,
    this.thickness = 1.0,
    this.color,
    this.indent,
    this.endIndent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final separatorColor = color ?? theme.dividerColor;

    return Container(
      margin: EdgeInsets.only(
        left: orientation == Axis.vertical ? 0 : (indent ?? 0),
        right: orientation == Axis.vertical ? 0 : (endIndent ?? 0),
        top: orientation == Axis.horizontal ? 0 : (indent ?? 0),
        bottom: orientation == Axis.horizontal ? 0 : (endIndent ?? 0),
      ),
      width: orientation == Axis.horizontal ? double.infinity : thickness,
      height: orientation == Axis.vertical ? double.infinity : thickness,
      color: separatorColor,
    );
  }
}

// Example usage
class SeparatorExample extends StatelessWidget {
  const SeparatorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Above horizontal separator'),
        Separator(), // Default horizontal separator
        Text('Below horizontal separator'),
        SizedBox(height: 20),
        
        Row(
          children: [
            Text('Left'),
            Separator(orientation: Axis.vertical), // Vertical separator
            Text('Right'),
          ],
        ),
        
        SizedBox(height: 20),
        
        // Customized examples
        Separator(
          thickness: 2.0,
          color: Colors.red,
          indent: 20,
          endIndent: 20,
        ),
        
        SizedBox(height: 10),
        
        Separator(
          orientation: Axis.vertical,
          thickness: 3.0,
          color: Colors.blue,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}