import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String userName;
  final String customerId;
  final String logoPath;
  final double? width;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final Color backgroundColor;
  final Color textColor;
  final List<Color> notificationGradient;

  const AppHeader({
    super.key,
    required this.userName,
    required this.customerId,
    required this.logoPath,
    this.width,
    this.onNotificationTap,
    this.onProfileTap,
    this.backgroundColor = const Color(0xFFC7E2FE),
    this.textColor = Colors.black,
    this.notificationGradient = const [Color(0xFFF97316), Color(0xFFFB923C), Color(0xFFFACC15)],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Image.asset(
            logoPath,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Row(
              children: [
                Icon(Icons.account_balance, color: textColor.withOpacity(0.8), size: 22),
                const SizedBox(width: 8),
                Text(
                  "BRAND LOGO",
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // User Info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Row(
                      children: [
                        Text(
                          "ID $customerId",
                          style: TextStyle(
                            fontSize: 13,
                            color: textColor.withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 16,
                          color: textColor.withOpacity(0.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Notification Icon
              GestureDetector(
                onTap: onNotificationTap,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: notificationGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.notifications_none_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
