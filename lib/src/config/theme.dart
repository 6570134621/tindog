import 'package:flutter/cupertino.dart';

class Theme {
  const Theme();

  static const Color gradientStart = const Color(0xFFF0A6CA);
  static const Color gradientEnd = const Color(0xFF9C89B8);

  static const gradient = const LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 1.0],
  );
}