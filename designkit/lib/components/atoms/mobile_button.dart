import 'package:flutter/material.dart';

class MobileButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double width;
  final double height;
  final String text;
  final bool disabled;
  final Color buttonColor;
  final bool isSingleColor;
  final double opacity;

  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final bool showFingerprint;
  final bool showForwardArrow;
  final bool showBackwardArrow;

  const MobileButton({
    super.key,
    this.onTap,
    this.width = 321,
    this.height = 61,
    required this.text,
    this.disabled = false,
    this.buttonColor = const Color(0xFF5371F9),
    this.isSingleColor = false,
    this.opacity = 0.8,
    this.textColor = Colors.white,
    this.fontSize = 22,
    this.fontWeight = FontWeight.w600,
    this.borderRadius = 20,
    this.showFingerprint = false,
    this.showForwardArrow = false,
    this.showBackwardArrow = false,
  });

  @override
  State<MobileButton> createState() => _ButtonState();
}

class _ButtonState extends State<MobileButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.disabled) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.disabled) {
      _animationController.reverse();
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.isSingleColor
                  ? widget.buttonColor.withOpacity(widget.opacity)
                  : null,
              gradient: widget.isSingleColor
                  ? null
                  : LinearGradient(
                      colors: [
                        widget.buttonColor.withOpacity(widget.opacity),
                        widget.buttonColor.withOpacity(widget.opacity * 0.5),
                      ],
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                    ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.showBackwardArrow) ...[
                  Icon(
                    Icons.chevron_left_rounded,
                    color: widget.textColor,
                    size: widget.fontSize * 1.4,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: widget.fontWeight,
                    letterSpacing: 0.5,
                  ),
                ),
                if (widget.showFingerprint) ...[
                  const SizedBox(width: 12),
                  Icon(
                    Icons.fingerprint,
                    color: widget.textColor,
                    size: widget.fontSize * 1.4,
                  ),
                ],
                if (widget.showForwardArrow) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: widget.textColor,
                    size: widget.fontSize * 1.4,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

