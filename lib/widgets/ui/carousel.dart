import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;

enum CarouselOrientation {
  horizontal,
  vertical,
}

class Carousel extends StatefulWidget {
  final List<Widget> children;
  final CarouselOrientation orientation;
  final bool enableInfiniteScroll;
  final bool autoPlay;
  final Duration? autoPlayInterval;
  final double? height;
  final double? width;
  final double aspectRatio;
  final Function(int, carousel_slider.CarouselPageChangedReason)? onPageChanged;
  final int initialPage;
  final bool enlargeCenterPage;
  final double viewportFraction;
  final bool enableNavigationButtons;
  final ScrollPhysics? scrollPhysics;

  const Carousel({
    super.key,
    required this.children,
    this.orientation = CarouselOrientation.horizontal,
    this.enableInfiniteScroll = true,
    this.autoPlay = false,
    this.autoPlayInterval,
    this.height,
    this.width,
    this.aspectRatio = 16 / 9,
    this.onPageChanged,
    this.initialPage = 0,
    this.enlargeCenterPage = false,
    this.viewportFraction = 0.8,
    this.enableNavigationButtons = true,
    this.scrollPhysics,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final carousel_slider.CarouselController _carouselController = 
      carousel_slider.CarouselController();
  int _currentPage = 0;

  void _scrollPrevious() {
    _carouselController.previousPage();
  }

  void _scrollNext() {
    _carouselController.nextPage();
  }

  bool get _canScrollPrevious => widget.enableInfiniteScroll || _currentPage > 0;
  bool get _canScrollNext => widget.enableInfiniteScroll || _currentPage < widget.children.length - 1;

  void _handlePageChanged(int index, carousel_slider.CarouselPageChangedReason reason) {
    setState(() {
      _currentPage = index;
    });
    widget.onPageChanged?.call(index, reason);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        carousel_slider.CarouselSlider(
          carouselController: _carouselController,
          items: widget.children,
          options: carousel_slider.CarouselOptions(
            height: widget.height,
            aspectRatio: widget.aspectRatio,
            viewportFraction: widget.viewportFraction,
            initialPage: widget.initialPage,
            enableInfiniteScroll: widget.enableInfiniteScroll,
            reverse: false,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval ?? const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: widget.enlargeCenterPage,
            scrollDirection: widget.orientation == CarouselOrientation.horizontal
                ? Axis.horizontal
                : Axis.vertical,
            onPageChanged: _handlePageChanged,
            scrollPhysics: widget.scrollPhysics,
          ),
        ),
        if (widget.enableNavigationButtons) ...[
          // Previous Button
          Positioned.fill(
            child: Align(
              alignment: widget.orientation == CarouselOrientation.horizontal
                  ? Alignment.centerLeft
                  : Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CarouselPrevious(
                  orientation: widget.orientation,
                  onPressed: _canScrollPrevious ? _scrollPrevious : null,
                ),
              ),
            ),
          ),
          // Next Button
          Positioned.fill(
            child: Align(
              alignment: widget.orientation == CarouselOrientation.horizontal
                  ? Alignment.centerRight
                  : Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CarouselNext(
                  orientation: widget.orientation,
                  onPressed: _canScrollNext ? _scrollNext : null,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class CarouselContent extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const CarouselContent({
    super.key,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class CarouselItem extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const CarouselItem({
    super.key,
    required this.child,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}

class CarouselPrevious extends StatelessWidget {
  final CarouselOrientation orientation;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const CarouselPrevious({
    super.key,
    required this.orientation,
    this.onPressed,
    this.variant = ButtonVariant.outline,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.background,
        shape: BoxShape.circle,
        border: variant == ButtonVariant.outline
            ? Border.all(color: colorScheme.outline)
            : null,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          orientation == CarouselOrientation.horizontal
              ? Icons.arrow_left
              : Icons.arrow_drop_up,
          color: iconColor ?? colorScheme.onBackground,
          size: size * 0.6,
        ),
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class CarouselNext extends StatelessWidget {
  final CarouselOrientation orientation;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  const CarouselNext({
    super.key,
    required this.orientation,
    this.onPressed,
    this.variant = ButtonVariant.outline,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.background,
        shape: BoxShape.circle,
        border: variant == ButtonVariant.outline
            ? Border.all(color: colorScheme.outline)
            : null,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          orientation == CarouselOrientation.horizontal
              ? Icons.arrow_right
              : Icons.arrow_drop_down,
          color: iconColor ?? colorScheme.onBackground,
          size: size * 0.6,
        ),
        style: IconButton.styleFrom(
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

// Reuse the ButtonVariant enum from your Button component
enum ButtonVariant {
  primary,
  destructive,
  outline,
  secondary,
  ghost,
  link,
}