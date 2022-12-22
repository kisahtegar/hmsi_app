import 'package:flutter/material.dart';

class CustomClipPathCred extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      0,
      size.height * 0.5000000,
      0,
      size.height * 0.6666667,
    );
    path.quadraticBezierTo(
      size.width * 0.5107143,
      size.height * 1.1791667,
      size.width,
      size.height * 0.6666667,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
