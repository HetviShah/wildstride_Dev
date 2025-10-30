import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String? text;
  final Widget? child;
  final TextStyle? style;
  final bool enabled;
  final bool isRequired;
  final EdgeInsetsGeometry padding;
  final double gap;
  final List<Widget> trailingWidgets;
  final VoidCallback? onPressed;

  // Main constructor - now it's unnamed and non-redirecting
  const Label({
    Key? key,  // Use Key? key instead of super.key
    this.text,
    this.child,
    this.style,
    this.enabled = true,
    this.isRequired = false,
    this.padding = EdgeInsets.zero,
    this.gap = 8.0,
    this.trailingWidgets = const [],
    this.onPressed,
  }) : assert(text != null || child != null, 'Must provide either text or child'),
       super(key: key);  // Pass key to super

  // Named constructor for text-only labels
  const Label.text({
    Key? key,
    required String text,
    TextStyle? style,
    bool enabled = true,
    bool isRequired = false,
    VoidCallback? onPressed,
  }) : this(
          key: key,
          text: text,
          style: style,
          enabled: enabled,
          isRequired: isRequired,
          onPressed: onPressed,
        );

  // Named constructor for labels with custom child
  const Label.child({
    Key? key,
    required Widget child,
    TextStyle? style,
    bool enabled = true,
    VoidCallback? onPressed,
  }) : this(
          key: key,
          child: child,
          style: style,
          enabled: enabled,
          onPressed: onPressed,
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: enabled 
          ? theme.colorScheme.onSurface 
          : theme.colorScheme.onSurface.withOpacity(0.5),
    );

    Widget buildContent() {
      if (child != null) {
        return child!;
      }

      return Text(
        isRequired ? '$text *' : text!,
        style: defaultStyle.merge(style),
      );
    }

    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: padding,
              child: trailingWidgets.isEmpty 
                  ? buildContent()
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildContent(),
                        SizedBox(width: gap),
                        ...trailingWidgets,
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// Usage examples
class LabelExamples extends StatelessWidget {
  const LabelExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Using the unnamed constructor
        const Label(text: 'Email Address'),
        
        const SizedBox(height: 16),
        
        // Using named constructor for text
        const Label.text(text: 'Username'),
        
        const SizedBox(height: 16),
        
        // Required label using unnamed constructor
        const Label(
          text: 'Password', 
          isRequired: true,
        ),
        
        const SizedBox(height: 16),
        
        // Using named constructor for child
        Label.child(
          child: const Row(
            children: [
              Icon(Icons.settings, size: 16),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
          onPressed: () {
            // Handle tap
          },
        ),
        
        const SizedBox(height: 16),
        
        // Disabled label
        const Label(
          text: 'Disabled Field',
          enabled: false,
        ),

        const SizedBox(height: 16),
        
        // Full customization with unnamed constructor
        Label(
          text: 'Custom Label',
          style: const TextStyle(color: Colors.red),
          padding: const EdgeInsets.all(8.0),
          trailingWidgets: const [
            Icon(Icons.info, size: 16),
          ],
          gap: 4.0,
          onPressed: () {
            // Handle tap
          },
        ),
      ],
    );
  }
}