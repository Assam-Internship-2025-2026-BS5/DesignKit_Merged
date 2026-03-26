import 'package:flutter/material.dart' hide TextField, Text;
import 'package:flutter/material.dart' as m show TextField, TextEditingController;
import 'package:flutter/services.dart';
import 'text.dart' as dk;
import '../../core/tokens/typography.dart';
import '../../core/tokens/colors.dart';
import '../../core/tokens/radius.dart';
import '../../core/tokens/spacing.dart';

/// A customizable text input atom with support for passwords, validation, and offsets.
/// 
/// Features animated hover states, error handling, and integrated boundary 
/// management to ensure the input field remains within the safe UI area.
class TextField extends StatefulWidget {
  /// The placeholder text to display when the input is empty.
  final String hintText;

  /// Whether the input should obscure text (for passwords).
  final bool isPassword;

  /// Optional validation logic for the input text.
  final String? Function(String)? validator;

  /// Optional maximum character length limit.
  final int? maxLength;

  /// Optional list of input formatters.
  final List<TextInputFormatter>? inputFormatters;

  /// The desired width of the field.
  final double? width;

  /// The desired height of the field.
  final double? height;

  /// Callback when text changes.
  final ValueChanged<String>? onChanged;

  /// Whether to display validation error text.
  final bool showErrorText;

  /// The color of the input text.
  final Color textColor;

  /// The thickness of the input text.
  final FontWeight fontWeight;

  /// Whether the field is interactive.
  final bool enabled;

  /// The font size of the input text.
  final double fontSize;

  /// The positional offset of the component.
  final Offset offset;

  final TextInputType keyboardType;
  final bool enableInteractiveSelection;

  /// Custom internal padding for the text input.
  final EdgeInsetsGeometry? contentPadding;

  const TextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.width,
    this.height = 60.0,
    this.onChanged,
    this.showErrorText = true,
    this.textColor = AppColors.black,
    this.fontWeight = FontWeight.normal,
    this.fontSize = AppTypography.fontLarge,
    this.enabled = true,
    this.offset = Offset.zero,
    this.keyboardType = TextInputType.text,
    this.enableInteractiveSelection = true,
    this.contentPadding,
  });

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  final m.TextEditingController _controller = m.TextEditingController();
  bool _obscureText = true;
  String? _errorText;
  bool _isHovering = false;

  String? _validatePassword(String value) {

  if (value.trim().isEmpty) {
    return null;
  }

  if (value.length > 16) {
    return "Maximum 16 characters allowed";
  }

  if (value.length < 8) {
    return "Minimum 8 characters required";
  }

  final hasUppercase = value.contains(RegExp(r'[A-Z]'));
  final hasLowercase = value.contains(RegExp(r'[a-z]'));
  final hasDigits = value.contains(RegExp(r'[0-9]'));
  final hasSpecialCharacters =
      value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
    return "Use mix of A-Z, a-z, 0-9 & symbols";
  }

  return null;
}

  void _validate(String value) {
    if (value.trim().isEmpty) {
      setState(() => _errorText = null);
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
      return;
    }
    String? error;

    // Only validate password if it's not empty, to avoid showing error on focus
    if (widget.isPassword && value.isNotEmpty) {
      error = _validatePassword(value);
    }

    if (error == null && widget.validator != null) {
      error = widget.validator!(value);
    }

    setState(() {
      _errorText = error;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  bool get hasError => _errorText != null;

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

        final widthOr850 = widget.width != null && widget.width! > 850
            ? 850.0
            : (widget.width ?? double.infinity);

        // Make sure the requested width does not exceed the dynamic bounds
        final finalWidth = widthOr850 > dynMaxWidth ? dynMaxWidth : widthOr850;

        return Transform.translate(
          offset: Offset(clampedX, clampedY),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: dynMaxWidth,
              maxHeight: dynMaxHeight,
            ),
            child: SizedBox(
              width: finalWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   MouseRegion(
                    onEnter: (_) => setState(() => _isHovering = true),
                    onExit: (_) => setState(() => _isHovering = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      // For password fields keep a fixed height; for others allow
                      // the container to grow with content by only setting minHeight.
                      constraints: widget.isPassword
                          ? BoxConstraints.tightFor(height: widget.height)
                          : BoxConstraints(minHeight: widget.height ?? 60.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _isHovering
                            ? const Color(0x26FFFFFF).withValues(alpha: 0.1)
                            : const Color(0x26FFFFFF),
                        borderRadius: BorderRadius.circular(AppRadius.circular),
                        border: Border.all(
                          color: (hasError && widget.showErrorText)
                              ? Colors.red
                              : Colors.black.withValues(alpha: 0.2),
                          width: 2.0,
                        ),
                      ),
                      child: Opacity(
                        opacity: widget.enabled ? 1.0 : 0.5,
                        child: m.TextField(
                          enabled: widget.enabled,
                          controller: _controller,
                          obscureText: widget.isPassword ? _obscureText : false,
                          maxLines: widget.isPassword ? 1 : null,
                          minLines: 1,
                          expands: false,
                          keyboardType: widget.keyboardType,
                          enableInteractiveSelection: widget.enableInteractiveSelection,
                          maxLength: widget.maxLength,
                          inputFormatters: widget.inputFormatters,
                          onChanged: _validate,
                          style: TextStyle(
                            fontSize: widget.fontSize,
                            color: widget.textColor,
                            fontWeight: widget.fontWeight,
                            fontFamily: AppTypography.fontFamily,
                            height: 1.2,
                          ),
                          textAlignVertical: widget.isPassword
                              ? TextAlignVertical.center
                              : TextAlignVertical.top,
                          decoration: InputDecoration(
                            isDense: true,
                            counterText: "",
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              color: AppColors.black.withValues(alpha: 0.3),
                              fontSize: widget.fontSize,
                              fontFamily: AppTypography.fontFamily,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                            ),
                            contentPadding: widget.contentPadding ??
                                const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.large,
                                  vertical: 10.0,
                                ),
                            border: InputBorder.none,
                            suffixIcon: widget.isPassword
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: IconButton(
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.black87,
                                        size: 20,
                                      ),
                                      onPressed: widget.enabled
                                          ? () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            }
                                          : null,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (hasError && widget.showErrorText) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.large),
                      child: dk.Text(
                        text: _errorText!,
                        color: Colors.red,
                        fontSize: AppTypography.fontMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
