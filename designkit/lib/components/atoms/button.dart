import 'package:flutter/material.dart' hide Text;
import 'text.dart' as dk;
import '../../core/tokens/colors.dart';

/// A customizable button widget with built-in scale animation and hover effects.
/// 
/// This widget follows the design kit's aesthetic and provides a premium look
/// and feel with its rounded corners and subtle shadows.
class Button extends StatefulWidget {
  /// The text to display on the button.
  final String text;

  /// Callback function when the button is tapped.
  final VoidCallback? onTap;

  /// The width of the button.
  final double width;

  /// The height of the button.
  final double height;

  /// The background color of the button.
  final Color color;

  /// Whether the button is disabled.
  final bool disabled;

  /// The opacity of the button.
  final double opacity;

  /// The font weight of the button text.
  final FontWeight fontWeight;

  /// The positional offset of the button.
  final Offset offset;

  const Button({
    super.key,
    required this.text,
    this.onTap,
    this.width = 150.0,
    this.height = 50.0,
    this.color = const Color(0xFF004C8F),
    this.disabled = false,
    this.opacity = 1.0,
    this.fontWeight = FontWeight.normal,
    this.offset = Offset.zero,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
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
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  void _handleActivate() {
    if (!widget.disabled) {
      _animationController.forward().then((_) => _animationController.reverse());
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double canvasWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : 1440.0;
        final double canvasHeight =
            constraints.maxHeight.isFinite ? constraints.maxHeight : 1024.0;

        final double dynMaxWidth =
            (canvasWidth - widget.offset.dx.abs()).clamp(0.0, double.infinity);
        final double dynMaxHeight =
            (canvasHeight - widget.offset.dy.abs()).clamp(0.0, double.infinity);

        final double maxSafeDx = (canvasWidth - dynMaxWidth) / 2.0;
        final double maxSafeDy = (canvasHeight - dynMaxHeight) / 2.0;

        final double clampedX = widget.offset.dx.clamp(-maxSafeDx, maxSafeDx);
        final double clampedY = widget.offset.dy.clamp(-maxSafeDy, maxSafeDy);

        return Transform.translate(
          offset: Offset(clampedX, clampedY),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: dynMaxWidth,
              maxHeight: dynMaxHeight,
            ),
            child: Opacity(
              opacity: widget.disabled ? 0.5 : widget.opacity,
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
                      width: widget.width > dynMaxWidth ? dynMaxWidth : widget.width,
                      height: widget.height > dynMaxHeight ? dynMaxHeight : widget.height,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(widget.height / 2),
                        border: _isFocused
                            ? Border.all(color: Colors.white.withAlpha(204), width: 2)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                          if (_isFocused || _isHovering)
                            BoxShadow(
                              color: widget.color.withAlpha(102),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: dk.Text(
                        text: widget.text,
                        color: AppColors.white,
                        fontSize: widget.height * 0.4, // Responsive font size based on height
                        fontWeight: widget.fontWeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
