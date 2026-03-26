import 'package:flutter/material.dart' hide Checkbox;

/// A professional, animated checkbox widget with a customizable label.
/// 
/// Provides smooth transitions, professional aesthetics, and various states 
/// including hover, focus, and disabled.
class Checkbox extends StatefulWidget {
  /// The current state of the checkbox.
  final bool value;

  /// An optional text label to display next to the checkbox.
  final String? label;

  /// Callback function when the checkbox value changes.
  final ValueChanged<bool?>? onChanged;

  /// Optional callback for when the checkbox is pressed.
  final VoidCallback? onPressed;

  /// Whether the checkbox is in a disabled state.
  final bool disabled;

  /// The color used when the checkbox is active (checked).
  final Color activeColor;

  /// The text color of the label.
  final Color labelColor;

  /// The relative size scale factor for the whole component.
  final double size;

  /// The font weight of the label text.
  final FontWeight fontWeight;

  /// The overall opacity of the component.
  final double opacity;

  /// The positional offset of the checkbox.
  final Offset offset;

  const Checkbox({
    super.key,
    required this.value,
    this.label,
    this.onChanged,
    this.onPressed,
    this.disabled = false,
    this.activeColor = const Color(0xFF1E1E4C),
    this.labelColor = const Color(0xFF1E1E4C),
    this.size = 1.0,
    this.fontWeight = FontWeight.normal,
    this.opacity = 1.0,
    this.offset = Offset.zero,
  });

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _isSelected;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250), // Slightly longer for smoother feel
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // Professional pop effect
      ),
    );
    if (_isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _isSelected = widget.value;
        if (_isSelected) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  void _handleTap() {
    if (widget.disabled) return;
    setState(() {
      _isSelected = !_isSelected;
      if (_isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onChanged?.call(_isSelected);
    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.disabled 
        ? widget.activeColor.withAlpha(77) 
        : widget.activeColor;
        
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
          child: Opacity(
            opacity: widget.opacity,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: dynMaxWidth,
                maxHeight: dynMaxHeight,
              ),
            child: FocusableActionDetector(
              enabled: !widget.disabled,
              mouseCursor: widget.disabled
                  ? SystemMouseCursors.forbidden
                  : SystemMouseCursors.click,
              onShowFocusHighlight: (value) {
                setState(() => _isFocused = value);
              },
              actions: {
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) => _handleTap(),
                ),
              },
              child: GestureDetector(
                onTap: _handleTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isFocused
                        ? activeColor.withAlpha(26)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: _isFocused
                        ? Border.all(color: activeColor.withAlpha(128), width: 1)
                        : null,
                  ),
                  child: Transform.scale(
                    scale: widget.size,
                    alignment: Alignment.centerLeft, // Alignment centerLeft for natural expansion
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer Border
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _isSelected ? activeColor : Colors.grey.shade400,
                                  width: 2,
                                ),
                                color: _isSelected ? activeColor : Colors.white,
                                boxShadow: (_isSelected || _isFocused) && !widget.disabled
                                    ? [
                                        BoxShadow(
                                          color: activeColor.withAlpha(77),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : [],
                              ),
                            ),
                            // Checkmark
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: const Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (widget.label != null) ...[
                          const SizedBox(width: 14),
                          Flexible(
                            child: Text( // Ensuring text doesn't overflow implicitly
                              widget.label!,
                              style: TextStyle(
                                color: widget.disabled ? Colors.grey : widget.labelColor,
                                fontSize: 30, // Slightly larger for professional look
                                fontWeight: widget.fontWeight,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
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
