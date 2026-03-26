import 'package:flutter/material.dart' hide Icon, Text;
import '../atoms/icon.dart' as atom;
import '../atoms/text.dart' as atom;

class BottomNav extends StatelessWidget {
  final Function(String)? onNavTap;
  final List<BottomNavItemData> items;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final Color activeColor;
  final Color textColor;
  final EdgeInsets padding;

  const BottomNav({
    super.key,
    this.onNavTap,
    this.items = const [],
    this.textStyle,
    this.backgroundColor = Colors.white,
    this.activeColor = const Color(0xFF003366),
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.only(top: 10, bottom: 5),
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) => _BottomNavItem(
          item: item,
          onNavTap: onNavTap,
          activeColor: activeColor,
          textColor: textColor,
          fontSize: textStyle?.fontSize ?? 14,
          fontWeight: textStyle?.fontWeight ?? FontWeight.w600,
        )).toList(),
      ),
    );
  }
}

class _BottomNavItem extends StatefulWidget {
  final BottomNavItemData item;
  final Function(String)? onNavTap;
  final Color activeColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const _BottomNavItem({
    required this.item,
    this.onNavTap,
    required this.activeColor,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  State<_BottomNavItem> createState() => _BottomNavItemState();
}

class _BottomNavItemState extends State<_BottomNavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () => widget.onNavTap?.call(widget.item.label),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _isPressed ? widget.activeColor.withOpacity(0.05) : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              atom.Icon(widget.item.icon, size: 24, color: widget.activeColor),
              const SizedBox(width: 6),
              atom.Text(
                text: widget.item.label,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
                color: widget.textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavItemData {
  final IconData icon;
  final String label;

  BottomNavItemData({required this.icon, required this.label});
}
