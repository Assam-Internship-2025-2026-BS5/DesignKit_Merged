import 'package:flutter/material.dart' hide Text;
import 'text.dart' as dk;
import '../../core/tokens/colors.dart';

/// A specialized login button with a specific design-system layout and style.
///
/// Features a large, rounded rectangle design with scale animation and
/// accessibility support via [FocusableActionDetector].
class LoginButton extends StatefulWidget {
  /// Callback triggered when the button is tapped.
  final VoidCallback onTap;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// The background color of the button.
  final Color color;

  /// The text displayed inside the button.
  final String text;

  /// Whether the button is disabled.
  final bool disabled;

  /// The font size of the button text.
  final double fontSize;

  /// The font weight of the button text.
  final FontWeight fontWeight;

  const LoginButton({
    super.key,
    required this.onTap,
    this.width = 483.0,
    this.height = 63.0,
    this.color = const Color(0xFF004C8F), // Updated to use HDFC brand color
    this.text = "Login",
    this.disabled = false,
    this.fontSize = 25.0,
    this.fontWeight = FontWeight.normal,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
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

  bool _isFocused = false;
  bool _isHovering = false;

  void _handleTapDown(TapDownDetails details) {
    if (!widget.disabled) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.disabled) {
      _animationController.reverse();
      widget.onTap();
    }
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  void _handleActivate() {
    if (!widget.disabled) {
      _animationController.forward().then((_) => _animationController.reverse());
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: FocusableActionDetector(
        enabled: !widget.disabled,
        mouseCursor: widget.disabled
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onShowFocusHighlight: (value) {
          setState(() => _isFocused = value);
        },
        onShowHoverHighlight: (value) {
          setState(() => _isHovering = value);
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _handleActivate(),
          ),
        },
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
                color: widget.color,
                borderRadius: BorderRadius.circular(30),
                border: _isFocused
                    ? Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20), // 0.08 * 255
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                  if (_isFocused || _isHovering)
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                ],
              ),
              alignment: Alignment.center,
              child: dk.Text(
                text: widget.text,
                color: AppColors.white,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
