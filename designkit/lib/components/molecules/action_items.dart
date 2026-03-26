import 'package:flutter/material.dart';
import '../atoms/glass_container.dart';
import '../atoms/icon.dart' as ic;

class ActionItems extends StatefulWidget {
  final List<ActionItemData> items;
  final Function(ActionItemData)? onItemTap;
  final double itemWidth;
  final double itemHeight;
  final double opacity;
  final double blur;
  final Color? borderColor;

  const ActionItems({
    super.key,
    this.items = const [],
    this.onItemTap,
    this.itemWidth = 100,
    this.itemHeight = 100,
    this.opacity = 0.1,
    this.blur = 20,
    this.borderColor,
  });

  @override
  State<ActionItems> createState() => _ActionItemsState();
}

class _ActionItemsState extends State<ActionItems> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return GlassContainer(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      borderRadius: BorderRadius.circular(32),
      opacity: widget.opacity,
      blur: widget.blur,
      borderColor: widget.borderColor ?? Colors.grey.withOpacity(0.3),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.items.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildActionTile(widget.items[index], index),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildActionTile(ActionItemData item, int index) {
    final isPressed = _pressedIndex == index;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedIndex = index),
      onTapUp: (_) => setState(() => _pressedIndex = null),
      onTapCancel: () => setState(() => _pressedIndex = null),
      onTap: () => widget.onItemTap?.call(item),
      child: AnimatedScale(
        scale: isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.itemWidth,
              height: widget.itemHeight,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isPressed ? 0.02 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: ic.Icon(
                  item.icon,
                  imagePath: item.imagePath,
                  size: widget.itemHeight,
                  color: item.iconColor,
                ),
              ),
            ),
            if (item.showBadge && !item.isFullImage)
              Positioned(
                top: -10,
                right: -5,
                child: Transform.rotate(
                  angle: 0.2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.badgeColor ?? const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      item.badgeText ?? "OFFER",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ActionItemData {
  final String title;
  final IconData? icon;
  final String? imagePath;
  final Color? iconColor;
  final bool showBadge;
  final bool isFullImage;
  final String? badgeText;
  final Color? badgeColor;

  ActionItemData({
    required this.title,
    this.icon,
    this.imagePath,
    this.iconColor,
    this.showBadge = false,
    this.isFullImage = false,
    this.badgeText,
    this.badgeColor,
  });
}
