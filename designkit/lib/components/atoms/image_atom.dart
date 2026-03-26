import 'dart:ui';
import 'package:flutter/material.dart';

/// A centered image atom widget with optional shadow and offset support.
/// 
/// This widget provides a consistent way to display assets throughout 
/// the design kit, including fallback behavior for broken images.
class dkImage extends StatelessWidget {
  /// The path to the image asset.
  final String imagePath;

  /// The desired width of the image.
  final double? width;

  /// The desired height of the image.
  final double? height;

  /// Horizontal positional offset.
  final double offsetX;

  /// Vertical positional offset.
  final double offsetY;

  /// Whether to display a soft shadow beneath the image.
  final bool showShadow;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  const dkImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.showShadow = false,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );

    return Transform.translate(
      offset: Offset(offsetX, offsetY),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (showShadow)
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(0, 6),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2),
                      BlendMode.srcIn,
                    ),
                    child: imageWidget,
                  ),
                ),
              ),
            ),
          imageWidget,
        ],
      ),
    );
  }
}
