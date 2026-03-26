import 'package:flutter/material.dart';

class LoginTemplate extends StatelessWidget {
  final Widget leftSection;
  final Widget rightSection;
  final double width;
  final double height;
  final bool isFullScreen;

  const LoginTemplate({
    super.key,
    required this.leftSection,
    required this.rightSection,
    this.width = 1440,
    this.height = 900,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isFullScreen ? double.infinity : width,
          maxHeight: isFullScreen ? double.infinity : height,
        ),
        child: Row(
          children: [
            // Left Panel Slot
            Expanded(
              flex: 1,
              child: leftSection,
            ),
            // Right Panel Slot
            Expanded(
              flex: 1,
              child: rightSection,
            ),
          ],
        ),
      ),
    );
  }
}
