import 'package:flutter/material.dart';
import '../atoms/glass_container.dart';
import '../molecules/primary_button.dart';
import '../molecules/inline_action_row.dart';

class AuthSection extends StatelessWidget {
  final String primaryActionTitle;
  final String leftActionLabel;
  final String rightActionLabel;
  final VoidCallback? onPrimaryActionTap;
  final VoidCallback? onLeftActionTap;
  final VoidCallback? onRightActionTap;
  final double width;
  final double opacity;
  final double blur;
  final double borderRadius;
  final Color actionTextColor;
  final bool showFingerprint;

  const AuthSection({
    super.key,
    required this.primaryActionTitle,
    required this.leftActionLabel,
    required this.rightActionLabel,
    this.onPrimaryActionTap,
    this.onLeftActionTap,
    this.onRightActionTap,
    this.width = 450,
    this.opacity = 0.10,
    this.blur = 25,
    this.borderRadius = 60,
    this.actionTextColor = const Color(0xFF1E3A8A),
    this.showFingerprint = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      borderRadius: BorderRadius.circular(borderRadius),
      opacity: opacity,
      blur: blur,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              title: primaryActionTitle,
              onTap: onPrimaryActionTap,
              width: width - 48,
              height: 48,
              borderRadius: 24,
              icon: showFingerprint ? Icons.fingerprint : null,
            ),
            const SizedBox(height: 8),
            InlineActionRow(
              leftLabel: leftActionLabel,
              rightLabel: rightActionLabel,
              onLeftTap: onLeftActionTap,
              onRightTap: onRightActionTap,
              textColor: actionTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
