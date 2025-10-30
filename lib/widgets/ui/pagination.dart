import 'package:flutter/material.dart';

// Utility function similar to cn (className concatenation)
String cn(String baseClass, [String? additionalClasses]) {
  if (additionalClasses == null || additionalClasses.isEmpty) {
    return baseClass;
  }
  return '$baseClass $additionalClasses';
}

// Button styles equivalent (simplified version)
class ButtonStyles {
  static ButtonStyle variant({
    required ButtonVariant variant,
    ButtonSize size = ButtonSize.icon,
  }) {
    return ButtonStyle(
      // You would define your actual button styles here
      // This is a simplified version
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        switch (variant) {
          case ButtonVariant.outline:
            return Colors.transparent;
          case ButtonVariant.ghost:
            return Colors.transparent;
          default:
            return Colors.blue;
        }
      }),
      foregroundColor: WidgetStateProperty.all(Colors.black),
      side: WidgetStateProperty.all(
        variant == ButtonVariant.outline 
            ? const BorderSide(color: Colors.grey)
            : BorderSide.none,
      ),
      padding: WidgetStateProperty.all(
        size == ButtonSize.icon 
            ? const EdgeInsets.all(8)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

enum ButtonVariant { outline, ghost, primary }
enum ButtonSize { icon, sm, defaultSize, lg }

// Main Pagination widget
class Pagination extends StatelessWidget {
  final Widget child;
  final String? className;

  const Pagination({
    super.key,
    required this.child,
    this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'pagination',
      container: true,
      child: Container(
        width: double.infinity,
        child: Center(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!,
            child: child,
          ),
        ),
      ),
    );
  }
}

// PaginationContent equivalent
class PaginationContent extends StatelessWidget {
  final List<Widget> children;
  final String? className;

  const PaginationContent({
    super.key,
    required this.children,
    this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: children,
    );
  }
}

// PaginationItem equivalent
class PaginationItem extends StatelessWidget {
  final Widget child;

  const PaginationItem({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

// PaginationLink props
class PaginationLinkProps {
  final VoidCallback? onTap;
  final bool isActive;
  final ButtonSize size;
  final Widget child;
  final String? className;

  const PaginationLinkProps({
    this.onTap,
    this.isActive = false,
    this.size = ButtonSize.icon,
    required this.child,
    this.className,
  });
}

// PaginationLink equivalent
class PaginationLink extends StatelessWidget {
  final PaginationLinkProps props;

  const PaginationLink({
    super.key,
    required this.props,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: props.isActive ? 'Current page' : null,
      child: TextButton(
        onPressed: props.onTap,
        style: ButtonStyles.variant(
          variant: props.isActive ? ButtonVariant.outline : ButtonVariant.ghost,
          size: props.size,
        ),
        child: props.child,
      ),
    );
  }
}

// PaginationPrevious equivalent
class PaginationPrevious extends StatelessWidget {
  final VoidCallback? onTap;
  final String? className;

  const PaginationPrevious({
    super.key,
    this.onTap,
    this.className,
  });

  @override
  Widget build(BuildContext context) {
    return PaginationLink(
      props: PaginationLinkProps(
        onTap: onTap,
        size: ButtonSize.defaultSize,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_left, size: 16),
            const SizedBox(width: 4),
            // Responsive text - hidden on small screens
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 640) { // sm breakpoint
                  return const Text('Previous');
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// PaginationNext equivalent
class PaginationNext extends StatelessWidget {
  final VoidCallback? onTap;
  final String? className;

  const PaginationNext({
    super.key,
    this.onTap,
    this.className,
  });

  @override
  Widget build(BuildContext context) {
    return PaginationLink(
      props: PaginationLinkProps(
        onTap: onTap,
        size: ButtonSize.defaultSize,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Responsive text - hidden on small screens
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 640) { // sm breakpoint
                  return const Text('Next');
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 16),
          ],
        ),
      ),
    );
  }
}

// PaginationEllipsis equivalent
class PaginationEllipsis extends StatelessWidget {
  final String? className;

  const PaginationEllipsis({
    super.key,
    this.className,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'More pages',
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        child: const Icon(Icons.more_horiz, size: 16),
      ),
    );
  }
}

// Usage Example
class PaginationExample extends StatelessWidget {
  const PaginationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Pagination(
      child: PaginationContent(
        children: [
          PaginationItem(
            child: PaginationPrevious(onTap: () => print('Previous')),
          ),
          PaginationItem(
            child: PaginationLink(
              props: PaginationLinkProps(
                child: const Text('1'),
                isActive: true,
                onTap: () => print('Page 1'),
              ),
            ),
          ),
          PaginationItem(
            child: PaginationLink(
              props: PaginationLinkProps(
                child: const Text('2'),
                onTap: () => print('Page 2'),
              ),
            ),
          ),
          PaginationItem(
            child: PaginationEllipsis(),
          ),
          PaginationItem(
            child: PaginationLink(
              props: PaginationLinkProps(
                child: const Text('10'),
                onTap: () => print('Page 10'),
              ),
            ),
          ),
          PaginationItem(
            child: PaginationNext(onTap: () => print('Next')),
          ),
        ],
      ),
    );
  }
}

// Alternative more Flutter-idiomatic version using simpler widgets
class SimplePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int>? onPageChanged;
  final int visiblePages;

  const SimplePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPageChanged,
    this.visiblePages = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1 ? () => onPageChanged?.call(currentPage - 1) : null,
        ),

        // Page numbers
        ..._buildPageNumbers(),

        // Next button
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages ? () => onPageChanged?.call(currentPage + 1) : null,
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers() {
    final List<Widget> pages = [];
    final int start = _calculateStartPage();
    final int end = _calculateEndPage(start);

    // First page and ellipsis
    if (start > 1) {
      pages.add(_buildPageNumber(1));
      if (start > 2) {
        pages.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('...'),
        ));
      }
    }

    // Visible pages
    for (int i = start; i <= end; i++) {
      pages.add(_buildPageNumber(i));
    }

    // Last page and ellipsis
    if (end < totalPages) {
      if (end < totalPages - 1) {
        pages.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('...'),
        ));
      }
      pages.add(_buildPageNumber(totalPages));
    }

    return pages;
  }

  int _calculateStartPage() {
    int start = currentPage - visiblePages ~/ 2;
    return start.clamp(1, totalPages - visiblePages + 1);
  }

  int _calculateEndPage(int start) {
    int end = start + visiblePages - 1;
    return end.clamp(visiblePages, totalPages);
  }

  Widget _buildPageNumber(int page) {
    final isActive = page == currentPage;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.blue : null,
          foregroundColor: isActive ? Colors.white : Colors.black,
        ),
        onPressed: () => onPageChanged?.call(page),
        child: Text(page.toString()),
      ),
    );
  }
}