import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Accordion extends StatefulWidget {
  final List<AccordionItem> children;
  final bool allowMultipleExpansion;
  final EdgeInsets? padding;
  final Color? borderColor;

  const Accordion({
    super.key,
    required this.children,
    this.allowMultipleExpansion = false,
    this.padding,
    this.borderColor,
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  final List<bool> _isExpandedList = [];

  @override
  void initState() {
    super.initState();
    // Initialize all items as collapsed
    _isExpandedList.addAll(List.filled(widget.children.length, false));
  }

  void _handleItemTap(int index) {
    setState(() {
      if (widget.allowMultipleExpansion) {
        // Toggle the clicked item
        _isExpandedList[index] = !_isExpandedList[index];
      } else {
        // Close all other items and toggle the clicked one
        for (int i = 0; i < _isExpandedList.length; i++) {
          _isExpandedList[i] = i == index ? !_isExpandedList[i] : false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.borderColor ?? Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          for (int i = 0; i < widget.children.length; i++)
            _buildAccordionItem(i, widget.children[i]),
        ],
      ),
    );
  }

  Widget _buildAccordionItem(int index, AccordionItem item) {
    final isLast = index == widget.children.length - 1;
    final isExpanded = _isExpandedList[index];

    return Container(
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(
            color: widget.borderColor ?? Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Trigger
          _AccordionTrigger(
            isExpanded: isExpanded,
            onTap: () => _handleItemTap(index),
            child: item.trigger,
          ),
          // Content
          if (isExpanded) _AccordionContent(child: item.content),
        ],
      ),
    );
  }
}

class _AccordionTrigger extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;
  final Widget child;

  const _AccordionTrigger({
    required this.isExpanded,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                child: child,
              ),
            ),
            const SizedBox(width: 16),
            RotationTransition(
              turns: AlwaysStoppedAnimation(isExpanded ? 0.5 : 0),
              child: Icon(
                LucideIcons.chevronDown,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccordionContent extends StatelessWidget {
  final Widget child;

  const _AccordionContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        child: child,
      ),
    );
  }
}

class AccordionItem {
  final Widget trigger;
  final Widget content;

  const AccordionItem({
    required this.trigger,
    required this.content,
  });
}

// Alternative simplified version using ExpansionPanelList (Flutter built-in)
class FlutterAccordion extends StatelessWidget {
  final List<ExpansionPanel> panels;
  final bool allowMultipleExpansion;

  const FlutterAccordion({
    super.key,
    required this.panels,
    this.allowMultipleExpansion = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        // This would need to be handled by parent widget with state management
      },
      children: panels,
    );
  }
}

// Pre-built accordion items for common use cases
class AccordionItems {
  static AccordionItem createTextItem({
    required String title,
    required String content,
    TextStyle? titleStyle,
    TextStyle? contentStyle,
  }) {
    return AccordionItem(
      trigger: Text(title),
      content: Text(content),
    );
  }

  static AccordionItem createRichItem({
    required Widget title,
    required Widget content,
  }) {
    return AccordionItem(
      trigger: title,
      content: content,
    );
  }
}