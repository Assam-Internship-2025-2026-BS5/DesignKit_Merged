import 'package:flutter/material.dart' as m;

class MobileImageWidget extends m.StatelessWidget {
  final double offsetX;
  final double offsetY;
  final bool showShadow;

  final String firstImagePath;
  final String secondImagePath;

  const MobileImageWidget({
    super.key,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.showShadow = false,
    this.firstImagePath = 'assets/hdfc_logo.png',
    this.secondImagePath = 'assets/now_logo.png',
  });

  @override
  m.Widget build(m.BuildContext context) {
    return m.MouseRegion(
      cursor: m.SystemMouseCursors.click,
      child: m.Transform.translate(
        offset: m.Offset(offsetX, offsetY),
        child: m.Container(
          alignment: m.Alignment.center,
          decoration: m.BoxDecoration(
            boxShadow: showShadow
                ? [
                    m.BoxShadow(
                      color: m.Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const m.Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: m.FittedBox(
            fit: m.BoxFit.fill,
            alignment: m.Alignment.center,
            child: m.Row(
              mainAxisSize: m.MainAxisSize.min,
              mainAxisAlignment: m.MainAxisAlignment.center,
              crossAxisAlignment: m.CrossAxisAlignment.center,
              children: [
                m.Image.asset(
                  firstImagePath,
                  height: 31.0,
                  fit: m.BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const m.Icon(m.Icons.broken_image, color: m.Colors.white24, size: 24),
                ),
                const m.SizedBox(width: 20),
                m.Image.asset(
                  secondImagePath,
                  height: 26.0,
                  fit: m.BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const m.Icon(m.Icons.broken_image, color: m.Colors.white24, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

