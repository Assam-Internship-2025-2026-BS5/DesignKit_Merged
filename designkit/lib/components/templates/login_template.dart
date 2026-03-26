import 'package:flutter/material.dart';

/// A responsive template for login pages that splits the screen into two panels.
/// 
/// On desktop/tablet, it displays [leftSection] and [rightSection] side-by-side.
/// On mobile (width < 800), it stacks them vertically inside a scroll view.
class LoginTemplate extends StatelessWidget {
  /// The widget content for the left (or top) panel.
  final Widget leftSection;

  /// The widget content for the right (or bottom) panel.
  final Widget rightSection;

  /// The base width of the template.
  final double width;

  /// The base height of the template.
  final double height;

  /// Whether the template should fill the entire screen dimensions.
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            if (isMobile) {
              // On mobile, we use the full viewport height if the constraints allow it,
              // or fall back to the viewport height to ensure each "page" fills the screen.
              final viewportHeight = MediaQuery.of(context).size.height;
              final sectionHeight = constraints.maxHeight.isFinite && constraints.maxHeight > viewportHeight
                  ? constraints.maxHeight
                  : viewportHeight;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: sectionHeight,
                        maxWidth: constraints.maxWidth,
                      ),
                      child: leftSection,
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: sectionHeight,
                        maxWidth: constraints.maxWidth,
                      ),
                      child: rightSection,
                    ),
                  ],
                ),
              );
            }

            return Row(
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
            );
          },
        ),
      ),
    );
  }
}
