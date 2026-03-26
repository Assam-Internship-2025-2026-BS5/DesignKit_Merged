import 'package:flutter/material.dart' as m;

class Icon extends m.StatelessWidget {
  final m.IconData? icon;
  final String? imagePath;
  final double? size;
  final m.Color? color;
  final String? semanticLabel;

  const Icon(
    this.icon, {
    super.key,
    this.imagePath,
    this.size,
    this.color,
    this.semanticLabel,
  });

  @override
  m.Widget build(m.BuildContext context) {
    if (imagePath != null) {
      return m.Image.asset(
        imagePath!,
        width: size,
        height: size,
        semanticLabel: semanticLabel,
        fit: m.BoxFit.contain,
      );
    }
    return m.Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}

