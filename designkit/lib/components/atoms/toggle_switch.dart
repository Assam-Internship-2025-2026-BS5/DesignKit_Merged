// import 'package:flutter/material.dart';

// /// A customizable toggle switch atom with an optional label.
// /// 
// /// Supports animated transitions, focused states, and scaling as part of 
// /// the design system.
// class ToggleSwitch extends StatefulWidget {
//   /// The current state of the switch.
//   final bool value;

//   /// Callback when the switch state changes.
//   final ValueChanged<bool>? onChanged;

//   /// Optional label text to display next to the switch.
//   final String? label;

//   /// The background color when the switch is ON.
//   final Color activeColor;

//   /// The text color of the label.
//   final Color labelColor;

//   /// The relative scale of the whole component.
//   final double size;

//   /// The font size of the label text.
//   final double fontSize;

//   /// The typeface thickness of the label text.
//   final FontWeight fontWeight;

//   /// Whether the switch is interactive.
//   final bool disabled;

//   /// The positional offset of the component.
//   final Offset offset;

//   const ToggleSwitch({
//     super.key,
//     required this.value,
//     this.onChanged,
//     this.label,
//     this.activeColor = const Color(0xFF1E1E4C),
//     this.labelColor = Colors.black87,
//     this.size = 1.0,
//     this.fontSize = 20.0,
//     this.fontWeight = FontWeight.normal,
//     this.disabled = false,
//     this.offset = Offset.zero,
//   });

//   @override
//   State<ToggleSwitch> createState() => _ToggleSwitchState();
// }

// class _ToggleSwitchState extends State<ToggleSwitch> with SingleTickerProviderStateMixin {
//   late bool _internalValue;

//   @override
//   void initState() {
//     super.initState();
//     _internalValue = widget.value;
//   }

//   @override
//   void didUpdateWidget(ToggleSwitch oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.value != widget.value) {
//       _internalValue = widget.value;
//     }
//   }

//   bool _isFocused = false;

//   void _handleTap() {
//     if (widget.onChanged != null) {
//       setState(() {
//         _internalValue = !_internalValue;
//       });
//       widget.onChanged!(_internalValue);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Scaling and Offset
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final double canvasWidth =
//             constraints.maxWidth.isFinite ? constraints.maxWidth : 1440.0;
//         final double canvasHeight =
//             constraints.maxHeight.isFinite ? constraints.maxHeight : 1024.0;

//         final double dynMaxWidth =
//             (canvasWidth - widget.offset.dx.abs()).clamp(0.0, double.infinity);
//         final double dynMaxHeight =
//             (canvasHeight - widget.offset.dy.abs()).clamp(0.0, double.infinity);

//         final double maxSafeDx = (canvasWidth - dynMaxWidth) / 2.0;
//         final double maxSafeDy = (canvasHeight - dynMaxHeight) / 2.0;

//         final double clampedX = widget.offset.dx.clamp(-maxSafeDx, maxSafeDx);
//         final double clampedY = widget.offset.dy.clamp(-maxSafeDy, maxSafeDy);

//         return Transform.translate(
//           offset: Offset(clampedX, clampedY),
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: dynMaxWidth,
//               maxHeight: dynMaxHeight,
//             ),
//             child: Transform.scale(
//               scale: widget.size,
//               alignment: Alignment.centerLeft,
//               child: FocusableActionDetector(
//                 enabled: !widget.disabled,
//                 mouseCursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
//                 onShowFocusHighlight: (value) {
//                   setState(() => _isFocused = value);
//                 },
//                 actions: {
//                   ActivateIntent: CallbackAction<ActivateIntent>(
//                     onInvoke: (_) => widget.disabled ? null : _handleTap(),
//                   ),
//                 },
//                 child: GestureDetector(
//                   onTap: widget.disabled ? null : _handleTap,
//                   child: Opacity(
//                     opacity: widget.disabled ? 0.5 : 1.0,
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: _isFocused
//                             ? widget.activeColor.withValues(alpha: 0.1)
//                             : Colors.transparent,
//                         borderRadius: BorderRadius.circular(20),
//                         border: _isFocused
//                             ? Border.all(color: widget.activeColor.withValues(alpha: 0.5), width: 1)
//                             : null,
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                             width: 50,
//                             height: 28,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(20),
//                               color: _internalValue 
//                                 ? (widget.disabled ? widget.activeColor.withValues(alpha: 0.5) : widget.activeColor) 
//                                 : Colors.grey.shade300,
//                               boxShadow: [
//                                 if ((_internalValue || _isFocused) && !widget.disabled)
//                                   BoxShadow(
//                                     color: widget.activeColor.withValues(alpha: 0.3),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                               ],
//                             ),
//                             child: Stack(
//                               children: [
//                                 AnimatedPositioned(
//                                   duration: const Duration(milliseconds: 300),
//                                   curve: Curves.easeInOut,
//                                   left: _internalValue ? 24 : 4,
//                                   top: 4,
//                                   child: Container(
//                                     width: 20,
//                                     height: 20,
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: 2,
//                                           offset: Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (widget.label != null) ...[
//                             const SizedBox(width: 12),
//                             Flexible(
//                               child: Text(
//                                 widget.label!,
//                                 style: TextStyle(
//                                   color: widget.labelColor,
//                                   fontSize: widget.fontSize,
//                                   fontWeight: widget.fontWeight,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
