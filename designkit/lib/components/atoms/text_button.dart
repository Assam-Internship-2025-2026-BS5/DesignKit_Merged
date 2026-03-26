import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/material.dart' as m show Text;

/// A simple text-based button with hover effects and underline decoration.
/// 
/// This widget is ideal for links or secondary actions that don't require 
/// a full button background.
class TextButton extends StatefulWidget {
  /// The text to display.
  final String text;

  /// Callback triggered when the button is pressed.
  final VoidCallback onPressed;

  /// The text color. Defaults to HDFC brand blue if null.
  final Color? color;

  /// The font size of the text.
  final double fontSize;

  /// Whether the button is interactive.
  final bool isClickable;

  /// Whether to show hover effects (underline and opacity shift).
  final bool enableHover;

  /// The typeface thickness.
  final FontWeight fontWeight;

  /// The positional offset of the text button.
  final Offset offset;

  const TextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize = 40,
    this.fontWeight = FontWeight.normal,
    this.isClickable = true,
    this.enableHover = true,
    this.offset = Offset.zero,
  });

  @override
  State<TextButton> createState() => _TextButtonState();
}

class _TextButtonState extends State<TextButton> {
  bool _isHovering = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    const defaultColor = Color(0xFF004C8F); // HDFC Blue
    final Color baseColor = widget.color ?? defaultColor;
    final bool effectiveClickable = widget.isClickable;

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
            child: FocusableActionDetector(
              enabled: effectiveClickable,
              mouseCursor: effectiveClickable
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              onShowHoverHighlight: (value) {
                if (widget.enableHover) {
                  setState(() => _isHovering = value);
                }
              },
              onShowFocusHighlight: (value) {
                setState(() => _isFocused = value);
              },
              actions: {
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) => widget.onPressed(),
                ),
              },
              child: GestureDetector(
                onTap: effectiveClickable ? widget.onPressed : null,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: TextStyle(
                    fontWeight: widget.fontWeight,
                    fontSize: widget.fontSize,
                    height: 1.0,
                    letterSpacing: 0,
                    color: (_isHovering || _isFocused)
                        ? baseColor.withValues(alpha: 0.8)
                        : baseColor,
                    decoration: (_isHovering || _isFocused) && widget.enableHover
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationThickness: 2,
                    decorationColor: baseColor.withValues(alpha: 0.5),
                  ),
                  child: m.Text(widget.text), // Text bounded naturally
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
