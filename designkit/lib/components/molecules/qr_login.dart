import 'dart:ui';
import 'package:flutter/material.dart' hide Text;
import '../atoms/text.dart' as dk;
import '../atoms/image_atom.dart';
import '../atoms/glass_card.dart' as dk;
import '../../core/tokens/typography.dart';
import '../../core/tokens/colors.dart';

/// A tappable glass card widget that displays a title, subtitle,
/// and an icon/image. On tap, it opens a blurred popup showing a QR code
/// or fallback icon for login purposes.
///
/// Example usage:
/// ```dart
/// QrLogin(
///   title: "Click to scan QR and login",
///   subtitle: "New HDFC Bank Early Access App Required",
///   imagePath: "assets/images/qr.png",
/// )
/// ```
class QrLogin extends StatefulWidget {
  /// Main heading text displayed on the card.
  final String title;

  /// Supporting text displayed below the title.
  final String subtitle;

  /// Title shown at the top of the QR popup dialog.
  final String popupTitle;

  /// QR data string (reserved for future use).
  final String qrData;

  /// Fallback icon shown when [imagePath] is null.
  final IconData icon;

  /// Asset path for the image shown in the card tile and popup.
  /// If null, [icon] is used instead.
  final String? imagePath;

  /// Color of the fallback icon.
  final Color accentColor;

  /// Width of the glass card.
  final double width;

  /// Height of the glass card. Controls visibility of subtitle and icon tile.
  final double height;

  /// Blur intensity of the glass background.
  final double blur;

  /// Opacity of the glass tint color.
  final double opacity;

  /// Positional offset applied to the entire widget.
  final Offset offset;

  /// Text color.
  final Color textColor;

  /// Text scale multiplier.
  final double textScale;

  /// Subtitle color.
  final Color subtitleColor;

  /// Subtitle scale multiplier.
  final double subtitleScale;

  const QrLogin({
    super.key,
    required this.title,
    required this.subtitle,
    this.popupTitle = "Scan QR Code",
    this.qrData = "",
    this.icon = Icons.qr_code_2,
    this.imagePath,
    this.accentColor = Colors.black54,
    this.width = 484,
    this.height = 120,
    this.blur = 15,
    this.opacity = 0.2,
    this.offset = Offset.zero,
    this.textColor = Colors.black,
    this.textScale = 1.0,
    this.subtitleColor = Colors.black,
    this.subtitleScale = 1.0,
  });

  @override
  State<QrLogin> createState() => _QrLoginState();
}

class _QrLoginState extends State<QrLogin> {
  /// Tracks whether the card is currently being pressed.
  /// Used to drive the [AnimatedScale] effect.
  bool _isPressed = false;

  // ─── QR Popup ────────────────────────────────────────────────────────────────

  /// Opens a blurred backdrop dialog showing the QR code image or fallback icon.
  /// Tapping "Dismiss" closes the dialog.
  void _showQrPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) => BackdropFilter(
        // Blurs the background behind the dialog
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Dialog(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Popup title
                dk.Text(
                  text: widget.popupTitle,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                const SizedBox(height: 24),

                // QR image box or fallback icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: widget.imagePath != null
                      ? dkImage(imagePath: widget.imagePath!, width: 180, height: 180)
                      : Icon(widget.icon, size: 180, color: Colors.black),
                ),
                const SizedBox(height: 16),

                // Dismiss button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: dk.Text(text: "Dismiss", fontSize: AppTypography.fontLarge),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          // Tracks press state for AnimatedScale
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () => _showQrPopup(context),
          child: AnimatedScale(
            // Subtle shrink on press: 0.99 = very slight, feels responsive
            scale: _isPressed ? 0.99 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Adjusts layout for narrower containers
                final bool isSmall = constraints.maxWidth < 450;

                return dk.GlassCard(
                  width: widget.width,
                  height: widget.height,
                  blur: widget.blur,
                  opacity: widget.opacity,
                  borderRadius: 20,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 12 : 20,
                    vertical: widget.height < 80 ? 4 : 8,
                  ),
                  showShadow: false,
                  tintColor: AppColors.grey,
                  // Passed to GlassCard's InkWell to enable hover highlight
                  onTap: () => _showQrPopup(context),
                  child: Row(
                    children: [
                      // Icon tile hidden when card is too short to fit it
                      if (widget.height > 40) _buildIconTile(isSmall),
                      if (widget.height > 40) SizedBox(width: isSmall ? 10 : 12),

                      // Title + subtitle
                      Expanded(child: _buildTextColumn(isSmall)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Builds the circular icon/image tile on the left side of the card.
  /// Size is clamped based on [isSmall] and available [widget.height].
  Widget _buildIconTile(bool isSmall) {
    final double size = (isSmall ? 55.0 : 70.0).clamp(20, (widget.height - 16).clamp(20, 200));
    final double iconSize = (size - 15).clamp(10, 45);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.5),
          width: 2.5,
        ),
      ),
      child: Center(
        // Shows image if path is provided, otherwise falls back to icon
        child: widget.imagePath != null
            ? dkImage(imagePath: widget.imagePath!, width: 40, height: 40, fit: BoxFit.contain)
            : Icon(widget.icon, size: iconSize, color: widget.accentColor),
      ),
    );
  }

  /// Builds the title and optional subtitle text column.
  /// Subtitle is hidden when [widget.height] is 60 or below.
  /// Subtitle shows 2 lines when [widget.height] is above 100.
  Widget _buildTextColumn(bool isSmall) {
    final double titleSize = widget.height < 50
        ? AppTypography.fontSmall
        : (isSmall ? AppTypography.fontLarge : AppTypography.fontLargePlus);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title — always visible
        dk.Text(
          text: widget.title,
          maxLines: 1,
          fontSize: titleSize * widget.textScale,
          fontWeight: FontWeight.bold,
          color: widget.textColor,
        ),

        // Subtitle — only visible when card is tall enough
        if (widget.height > 60) ...[
          const SizedBox(height: 4),
          dk.Text(
            text: widget.subtitle,
            maxLines: widget.height > 100 ? 2 : 1,
            fontSize: (isSmall ? AppTypography.fontSmall : AppTypography.fontMedium) * widget.subtitleScale,
            color: widget.subtitleColor,
          ),
        ],
      ],
    );
  }
}
