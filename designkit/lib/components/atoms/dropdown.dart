import 'package:flutter/material.dart' hide Text;
import 'text.dart' as dk;
import '../../core/tokens/colors.dart';

class Dropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? label;
  final String hint;
  final double width;
  final Color activeColor;
  final double size;
  final Offset offset;
  final bool enabled;

  const Dropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint = "Select option",
    this.width = 200,
    this.activeColor = AppColors.darkBlue,
    this.size = 1.0,
    this.offset = Offset.zero,
    this.enabled = true,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? _selectedValue;
  final MenuController _menuController = MenuController();

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
              dk.Text(
                text: widget.label!,
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
            ],
            MenuAnchor(
              controller: _menuController,
              alignmentOffset: const Offset(0, 4),
              style: MenuStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                surfaceTintColor: WidgetStateProperty.all(Colors.white),
                elevation: WidgetStateProperty.all(8),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
                fixedSize: WidgetStateProperty.all(Size.fromWidth(widget.width)),
              ),
              menuChildren: widget.items.map((item) {
                return MenuItemButton(
                  onPressed: () {
                    setState(() {
                      _selectedValue = item;
                    });
                    widget.onChanged?.call(item);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: dk.Text(
                      text: item,
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                );
              }).toList(),
      builder: (context, controller, child) {
                return GestureDetector(
                  onTap: widget.enabled
                      ? () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        }
                      : null,
                  child: Opacity(
                    opacity: widget.enabled ? 1.0 : 0.5,
                    child: Container(
                    width: widget.width,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.isOpen ? widget.activeColor : Colors.black12,
                        width: controller.isOpen ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: dk.Text(
                            text: _selectedValue ?? widget.hint,
                            color: _selectedValue == null ? Colors.black38 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          controller.isOpen 
                              ? Icons.keyboard_arrow_up 
                              : Icons.keyboard_arrow_down, 
                          color: widget.activeColor
                        ),
                      ],
                    ),
                  ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
