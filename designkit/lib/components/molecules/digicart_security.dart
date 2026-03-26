import 'package:flutter/material.dart' hide Text;
import '../atoms/text.dart' as dk;
import '../atoms/glass_card.dart' as dk;
import '../atoms/image_atom.dart';
import '../../core/tokens/typography.dart';
import '../../core/tokens/colors.dart';

/// A tappable glass card widget that displays a title, subtitle,
/// and a branded image tile on the right side.
/// Used to represent Digicart security information or actions.
///
/// Example usage:
/// ```dart
/// DigicartSecurity(
///   title: "Secured by Digicart",
///   subtitle: "256-bit encryption",
///   imagePath: "assets/images/shield.png",
///   onTap: () => print("tapped"),
/// )
/// ```
class DigicartSecurity extends StatefulWidget {
  /// Main heading text displayed on the left side of the card.
  final String title;

  /// Bold supporting text displayed below the title.
  final String subtitle;

  /// Asset path for the image shown in the right side tile.
  final String imagePath;

  /// Width of the glass card.
  final double width;

  /// Height of the glass card.
  final double height;

  /// Blur intensity of the glass background.
  final double blur;

  /// Opacity of the glass tint color.
  final double opacity;

  /// Callback triggered when the card is tapped.
  /// If null, the card is still hoverable but produces no action.
  final VoidCallback? onTap;

  /// Positional offset applied to the entire widget.
  final Offset offset;

  const DigicartSecurity({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.width = 484,
    this.height = 120,
    this.blur = 15,
    this.opacity = 0.2,
    this.onTap,
    this.offset = Offset.zero,
  });

  @override
  State<DigicartSecurity> createState() => _DigicartSecurityState();
}

class _DigicartSecurityState extends State<DigicartSecurity> {
  /// Tracks whether the card is currently being pressed.
  /// Used to drive the [AnimatedScale] press effect.
  bool _isPressed = false;

  // ─── Main Card ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      // Allows custom positioning offset without affecting layout
      offset: widget.offset,
      child: MouseRegion(
        // Shows pointer cursor when hovering on desktop/web
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          // Tracks press state to drive AnimatedScale
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            // Shrinks card slightly on press for a tactile feel
            scale: _isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: dk.GlassCard(
              width: widget.width,
              height: widget.height,
              blur: widget.blur,
              opacity: widget.opacity,
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              showShadow: false,
              tintColor: AppColors.grey,
              // Passed to GlassCard's InkWell to enable hover highlight
              onTap: widget.onTap ?? () {},
              child: Row(
                children: [
                  // Left side — title and subtitle text
                  Expanded(child: _buildTextColumn()),

                  // Right side — branded image tile
                  _buildImageTile(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Builds the title and subtitle text column on the left.
  /// Uses [FittedBox] to scale down text if the card is too narrow.
  Widget _buildTextColumn() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title — regular weight, brand blue color
          dk.Text(
            text: widget.title,
            color: const Color(0xFF004C8F),
            fontSize: 19,
          ),
          const SizedBox(height: 6),

          // Subtitle — bold, same brand blue color
          dk.Text(
            text: widget.subtitle,
            color: const Color(0xFF004C8F),
            fontWeight: FontWeight.bold,
            fontSize: AppTypography.fontLargePlus,
          ),
        ],
      ),
    );
  }

  /// Builds the rounded image tile on the right side of the card.
  /// Has a semi-transparent white background to subtly lift the image.
  Widget _buildImageTile() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        // Subtle white tint behind the image
        color: AppColors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: dkImage(imagePath: widget.imagePath),
      ),
    );
  }
}