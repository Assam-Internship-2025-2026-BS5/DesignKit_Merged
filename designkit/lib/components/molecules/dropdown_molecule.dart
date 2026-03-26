import 'package:flutter/material.dart';
import '../../core/tokens/colors.dart';
import '../../core/tokens/radius.dart';
import '../../core/tokens/typography.dart';

/// A customizable dropdown molecule with a proper selection menu.
/// 
/// Features a field that opens a list below it, with hover effects,
/// proper positioning, and HDFC-themed styling.
class Dropdown extends StatefulWidget {
  /// The currently selected value.
  final String? value;

  /// The list of items to display in the dropdown.
  final List<String> items;

  /// Callback when the selected value changes.
  final ValueChanged<String?>? onChanged;

  /// Optional label text to display above the dropdown.
  final String? label;

  /// Placeholder text when no value is selected.
  final String hint;

  /// The width of the dropdown container.
  final double width;

  /// The color of the arrow icon and active states.
  final Color activeColor;

  /// Whether the dropdown is interactive.
  final bool enabled;

  /// The relative scale of the component.
  final double size;

  /// The positional offset of the component.
  final Offset offset;

  const Dropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint = "Select option",
    this.width = 240,
    this.activeColor = AppColors.hdfcBlue,
    this.enabled = true,
    this.size = 1.0,
    this.offset = Offset.zero,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? _selectedValue;
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(Dropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue = widget.value;
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled) return;
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    if (_isOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      setState(() => _isOpen = false);
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _closeDropdown,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            width: widget.width * widget.size,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, 55 * widget.size + 4), 
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 200),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * -10),
                      child: child,
                    ),
                  );
                },
                child: Material(
                  elevation: 12,
                  shadowColor: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  color: Colors.white,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 250,
                      maxWidth: widget.width * widget.size,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.1)),
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: RawScrollbar(
                        thumbColor: widget.activeColor.withOpacity(0.3),
                        radius: const Radius.circular(10),
                        thickness: 4,
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shrinkWrap: true,
                          children: widget.items.map((item) {
                            return _DropdownItem(
                              text: item,
                              isSelected: _selectedValue == item,
                              activeColor: widget.activeColor,
                              onTap: () {
                                setState(() => _selectedValue = item);
                                if (widget.onChanged != null) {
                                  widget.onChanged!(item);
                                }
                                _closeDropdown();
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.offset,
      child: Transform.scale(
        scale: widget.size,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.label != null) ...[
              Text(
                widget.label!,
                style: TextStyle(
                  color: widget.enabled ? Colors.black87 : Colors.black45,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.fontFamily,
                ),
              ),
              const SizedBox(height: 8),
            ],
            CompositedTransformTarget(
              link: _layerLink,
              child: MouseRegion(
                cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
                child: GestureDetector(
                  onTap: widget.enabled ? _toggleDropdown : null,
                  child: Opacity(
                    opacity: widget.enabled ? 1.0 : 0.6,
                    child: Container(
                      width: widget.width,
                      height: 55,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: widget.enabled ? Colors.white : Colors.grey[50],
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        border: Border.all(
                          color: _isOpen 
                              ? widget.activeColor 
                              : widget.enabled 
                                  ? Colors.black.withOpacity(0.15)
                                  : Colors.black.withOpacity(0.1),
                          width: _isOpen ? 2.0 : 1.5,
                        ),
                        boxShadow: [
                          if (widget.enabled)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedValue ?? widget.hint,
                              style: TextStyle(
                                color: _selectedValue == null ? Colors.black38 : Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppTypography.fontFamily,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          AnimatedRotation(
                            turns: _isOpen ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: widget.enabled ? widget.activeColor : Colors.black26,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
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

class _DropdownItem extends StatefulWidget {
  final String text;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _DropdownItem({
    required this.text,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  State<_DropdownItem> createState() => _DropdownItemState();
}

class _DropdownItemState extends State<_DropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: _isHovered 
              ? widget.activeColor.withOpacity(0.05) 
              : widget.isSelected 
                  ? widget.activeColor.withOpacity(0.1) 
                  : Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.isSelected ? widget.activeColor : Colors.black87,
                    fontSize: 14,
                    fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontFamily: AppTypography.fontFamily,
                  ),
                ),
              ),
              if (widget.isSelected)
                Icon(Icons.check, color: widget.activeColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
