import 'package:flutter/material.dart';
import 'dart:ui';
import '../organisms/header.dart';
import '../organisms/bottom_nav.dart';
import '../molecules/action_items.dart';
import '../molecules/primary_button.dart';
import '../molecules/scan.dart';
import '../molecules/inline_action_row.dart';

class HomePage extends StatefulWidget {
  final String backgroundImage;
  final String userName;
  final String customerId;
  final String logoPath;
  final String featureText;
  final List<ActionItemData> actionItems;
  final String primaryButtonTitle;
  final String? primaryButtonImagePath;
  final IconData? primaryButtonIcon;
  final String leftActionLabel;
  final String rightActionLabel;
  final String scanTitle;
  final String scanPopupTitle;
  final String scanImagePath;
  final List<BottomNavItemData> navItems;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onPrimaryButtonTap;
  final VoidCallback? onLeftActionTap;
  final VoidCallback? onRightActionTap;
  final VoidCallback? onScanTap;
  final Function(String)? onNavTap;
  final ValueChanged<String>? onIdChanged;

  const HomePage({
    super.key,
    this.backgroundImage = 'assets/right_back.png',
    this.userName = "USER NAME",
    this.customerId = "00000000",
    this.logoPath = "assets/hdfc_logo.png",
    this.featureText = "Frequently used features & special offers at your fingertips",
    this.actionItems = const [],
    this.primaryButtonTitle = "Primary Action",
    this.primaryButtonImagePath,
    this.primaryButtonIcon,
    this.leftActionLabel = "Left Action",
    this.rightActionLabel = "Right Action",
    this.scanTitle = "Scan",
    this.scanPopupTitle = "Scan Code",
    this.scanImagePath = "assets/Qr_scan.png",
    this.navItems = const [],
    this.onNotificationTap,
    this.onProfileTap,
    this.onPrimaryButtonTap,
    this.onLeftActionTap,
    this.onRightActionTap,
    this.onScanTap,
    this.onNavTap,
    this.onIdChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Header(
                      userName: widget.userName,
                      customerId: widget.customerId,
                      customerIds: const [
                        "******1010",
                        "******2020",
                        "******3030",
                        "******4040",
                      ],
                      logoPath: widget.logoPath,
                      onNotificationTap: widget.onNotificationTap,
                      onProfileTap: widget.onProfileTap,
                      onIdChanged: widget.onIdChanged,
                    ),
                    const Spacer(),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: ClipPath(
                            clipper: ScallopedClipper(),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE4EBFC).withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ),
                        CustomPaint(
                          painter: ScallopedBorderPainter(),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                const SizedBox(height: 90),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 40),
                                  child: Text(
                                    widget.featureText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF374151),
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ActionItems(
                                  items: widget.actionItems,
                                  itemWidth: 112,
                                  itemHeight: 112,
                                  onItemTap: (item) => debugPrint("Action Tapped: ${item.title}"),
                                ),
                                const SizedBox(height: 60),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: PrimaryButton(
                                    title: widget.primaryButtonTitle,
                                    imagePath: widget.primaryButtonImagePath ?? "",
                                    icon: widget.primaryButtonIcon,
                                    onTap: widget.onPrimaryButtonTap,
                                  ),
                                ),
                                InlineActionRow(
                                  leftLabel: widget.leftActionLabel,
                                  rightLabel: widget.rightActionLabel,
                                  onLeftTap: widget.onLeftActionTap,
                                  onRightTap: widget.onRightActionTap,
                                ),
                                const SizedBox(height: 45),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: -65,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: widget.onScanTap,
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 30,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                  border: Border.all(color: Colors.white, width: 3),
                                ),
                                child: Scan(
                                  title: widget.scanTitle,
                                  popupTitle: widget.scanPopupTitle,
                                  imagePath: widget.scanImagePath,
                                  width: 130,
                                  height: 130,
                                  textColor: const Color(0xFF1E3A8A),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Removed gap for seamless connection
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        items: widget.navItems,
        backgroundColor: Colors.white.withOpacity(0.8),
        onNavTap: widget.onNavTap,
      ),
    );
  }
}

class ScallopedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 80; 
    double centerX = size.width / 2;
    double cornerRadius = 40.0;
    
    Path path = Path();
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    
    // Line to the start of the notch
    path.lineTo(centerX - radius - 30, 0);
    
    // Smooth S-curve into the semi-circle
    path.cubicTo(
      centerX - radius - 15, 0,
      centerX - radius - 5, 20,
      centerX - radius, 25
    );
    
    // Concave arc (the scallop)
    path.arcToPoint(
      Offset(centerX + radius, 25),
      radius: Radius.circular(radius + 10),
      clockwise: false,
    );
    
    // Smooth S-curve out
    path.cubicTo(
      centerX + radius + 5, 20,
      centerX + radius + 15, 0,
      centerX + radius + 30, 0
    );
    
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ScallopedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = 80; 
    double centerX = size.width / 2;
    double cornerRadius = 40.0;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path();
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    
    path.lineTo(centerX - radius - 30, 0);
    
    path.cubicTo(
      centerX - radius - 15, 0,
      centerX - radius - 5, 20,
      centerX - radius, 25
    );
    
    path.arcToPoint(
      Offset(centerX + radius, 25),
      radius: Radius.circular(radius + 10),
      clockwise: false,
    );
    
    path.cubicTo(
      centerX + radius + 5, 20,
      centerX + radius + 15, 0,
      centerX + radius + 30, 0
    );
    
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
