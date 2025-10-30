import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String size; // xs, sm, md, lg, xl, full
  final bool showText;
  final String assetPath;

  const Logo({
    Key? key,
    this.size = "md",
    this.showText = true,
    this.assetPath = "assets/images/wildstride_logo.png",
  }) : super(key: key);

  // Map sizes to height values
  double _getSize(String size) {
    switch (size) {
      case "xs":
        return 24; // h-6
      case "sm":
        return 32; // h-8
      case "md":
        return 48; // h-12
      case "lg":
        return 80; // h-20
      case "xl":
        return 128; // h-32
      case "full":
        return double.infinity;
      default:
        return 48; // md default
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = _getSize(size);

    return Center(
      child: ClipPath(
        clipper: showText ? null : _TriangleClipper(),
        child: Image.asset(
          assetPath,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

/// Just the triangular logo mark
class LogoMark extends StatelessWidget {
  final String size;
  final String assetPath;

  const LogoMark({
    Key? key,
    this.size = "md",
    this.assetPath = "assets/images/wildstride_logo.png",
  }) : super(key: key);

  double _getSize(String size) {
    switch (size) {
      case "xs":
        return 24;
      case "sm":
        return 32;
      case "md":
        return 40;
      case "lg":
        return 64;
      case "xl":
        return 96;
      case "full":
        return double.infinity;
      default:
        return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = _getSize(size);

    return Center(
      child: ClipPath(
        clipper: _TriangleClipper(),
        child: Image.asset(
          assetPath,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

/// Custom triangle clipper for cropping logo
class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.85); // bottom left
    path.lineTo(size.width * 0.5, 0); // top
    path.lineTo(size.width, size.height * 0.85); // bottom right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TriangleClipper oldClipper) => false;
}