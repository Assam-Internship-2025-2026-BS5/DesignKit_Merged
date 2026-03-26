import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withAlpha(20),
      offset: const Offset(0, 4),
      blurRadius: 4,
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withAlpha(30),
      offset: const Offset(0, 6),
      blurRadius: 10,
    ),
  ];

  static List<BoxShadow> card = [
    BoxShadow(
      color: Colors.black.withAlpha(20),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
}
