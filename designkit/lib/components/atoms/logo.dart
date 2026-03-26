import 'package:flutter/material.dart';
import 'image_atom.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;
  final double offsetX;
  final double offsetY;
  final bool showShadow;

  const Logo({
    super.key,
    this.width = 240.0,
    this.height = 31.0,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Transform.translate(
        offset: Offset(offsetX, offsetY),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                dkImage(
                  imagePath: 'assets/hdfc_logo.png',
                ),
                const SizedBox(width: 20),
                dkImage(
                  imagePath: 'assets/now_logo.png',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
