import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final IconData? icon;
  final double width;
  final double height;
  final double? borderRadius;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;
  final Color textColor;
  final double fontSize;

  const PrimaryButton({
    super.key,
    required this.title,
    this.subtitle = "",
    this.imagePath = "",
    this.icon,
    this.width = 380,
    this.height = 48,
    this.gradientColors,
    this.borderRadius = 24.0,
    this.onTap,
    this.textColor = Colors.white,
    this.fontSize = 16,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradientColors ?? [const Color(0xFF1E3A8A), const Color(0xFF1E40AF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (widget.imagePath.isNotEmpty || widget.icon != null) ...[
                const SizedBox(width: 12),
                widget.imagePath.isNotEmpty
                    ? Image.asset(
                        widget.imagePath,
                        width: 28,
                        height: 28,
                        color: widget.textColor,
                        errorBuilder: (context, error, stackTrace) => widget.icon != null
                            ? Icon(
                                widget.icon,
                                color: widget.textColor,
                                size: 28,
                              )
                            : const SizedBox.shrink(),
                      )
                    : Icon(
                        widget.icon,
                        color: widget.textColor,
                        size: 28,
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
