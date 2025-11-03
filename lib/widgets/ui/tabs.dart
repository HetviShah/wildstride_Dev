import 'package:flutter/material.dart';

class Tabs extends StatelessWidget {
  final List<Widget> children;
  final int initialIndex;
  final ValueChanged<int>? onChanged;
  final Axis direction;
  final EdgeInsets? padding;
  final Decoration? decoration;

  const Tabs({
    Key? key,
    required this.children,
    this.initialIndex = 0,
    this.onChanged,
    this.direction = Axis.vertical,
    this.padding,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      initialIndex: initialIndex,
      child: Container(
        padding: padding,
        decoration: decoration,
        child: direction == Axis.vertical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
      ),
    );
  }
}

class TabsList extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final Decoration? decoration;

  const TabsList({
    Key? key,
    required this.children,
    this.padding,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(3.0),
      decoration: decoration ??
          BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
      child: TabBar(
        tabs: children,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.background,
        ),
        labelColor: Theme.of(context).colorScheme.onBackground,
        unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
    );
  }
}

class TabsTrigger extends StatelessWidget {
  final Widget? icon;
  final Widget label;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool enabled;

  const TabsTrigger({
    Key? key,
    this.icon,
    required this.label,
    this.onTap,
    this.padding,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 6),
          ],
          Flexible(child: label),
        ],
      ),
    );
  }
}

class TabsContent extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;

  const TabsContent({
    Key? key,
    required this.children,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: padding,
        child: TabBarView(
          children: children,
        ),
      ),
    );
  }
}

// Example usage:
class TabsExample extends StatelessWidget {
  const TabsExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tabs(
      direction: Axis.vertical,
      children: [
        TabsList(
          children: const [
            TabsTrigger(
              label: Text('Tab 1'),
            ),
            TabsTrigger(
              label: Text('Tab 2'),
            ),
            TabsTrigger(
              label: Text('Tab 3'),
            ),
          ],
        ),
        TabsContent(
          children: [
            Container(
              child: const Center(child: Text('Content 1')),
            ),
            Container(
              child: const Center(child: Text('Content 2')),
            ),
            Container(
              child: const Center(child: Text('Content 3')),
            ),
          ],
        ),
      ],
    );
  }
}