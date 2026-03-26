import 'package:flutter/material.dart';
import '../../components/organisms/left_info_section.dart';
import '../../components/organisms/right_login_container.dart';
import '../templates/login_template.dart';

/// A full-page component representing the NetBanking login experience.
/// 
/// Combines the [LeftInfoSection] and [RightLoginContainer] using a standard 
/// login template, providing a cohesive and responsive login screen.
class NetBankingLoginPage extends StatelessWidget {
  /// The total width of the login page.
  final double width;

  /// The total height of the login page.
  final double height;

  /// Whether the page should occupy the full screen dimensions.
  final bool isFullScreen;

  /// The main heading text displayed in the login form.
  final String title;

  /// The supplementary brand text.
  final String subtitle;

  /// The label for the customer ID input.
  final String customerIdLabel;

  /// The placeholder for the customer ID input.
  final String customerIdHint;

  /// The label for the password input.
  final String passwordLabel;

  /// The text for the primary login button.
  final String buttonText;

  /// The text for the QR login card.
  final String qrText;

  /// The subtitle for the QR login card.
  final String qrSubtitle;

  /// The asset path for the left-side informational image.
  final String leftImagePath;
  
  /// The size category for the title text.
  final String titleSize;

  /// The color for the title text.
  final Color titleColor;

  /// The size category for the subtitle text.
  final String subtitleSize;

  /// The color for the subtitle text.
  final Color subtitleColor;

  /// The size category for the customer ID text.
  final String customerIdSize;

  /// The color for the customer ID text.
  final Color customerIdColor;

  /// The size category for the password text.
  final String passwordSize;

  /// The color for the password text.
  final Color passwordColor;

  /// The size category for the button text.
  final String buttonSize;

  /// The primary color for buttons and highlights.
  final Color buttonColor;

  /// The size category for the QR text.
  final String qrTextSize;

  /// The color for the QR text.
  final Color qrTextColor;

  /// The size category for the QR subtitle text.
  final String qrSubtitleSize;

  /// The color for the QR subtitle text.
  final Color qrSubtitleColor;

  /// The size category for the checkbox text.
  final String checkboxSize;

  /// The color for the checkbox text.
  final Color checkboxColor;

  const NetBankingLoginPage({
    super.key,
    this.width = 1440,
    this.height = 900,
    this.isFullScreen = false,
    this.title = "Welcome to NetBanking",
    this.subtitle = "MADE DIGITAL BY",
    this.customerIdLabel = "Customer ID/User ID",
    this.customerIdHint = "Customer ID/ User ID",
    this.passwordLabel = "Password",
    this.buttonText = "Login",
    this.qrText = "Click to scan QR and login",
    this.qrSubtitle = "New HDFC Bank Early Access App Required",
    this.leftImagePath = 'assets/left_image.png',
    this.titleSize = 'Medium',
    this.titleColor = const Color(0xFF1E1E4C),
    this.subtitleSize = 'Medium',
    this.subtitleColor = const Color(0xFF1E1E4C),
    this.customerIdSize = 'Medium',
    this.customerIdColor = const Color(0xFF1E1E4C),
    this.passwordSize = 'Medium',
    this.passwordColor = const Color(0xFF1E1E4C),
    this.buttonSize = 'Medium',
    this.buttonColor = const Color(0xFF004C8F),
    this.qrTextSize = 'Medium',
    this.qrTextColor = const Color(0xFF1E1E4C),
    this.qrSubtitleSize = 'Medium',
    this.qrSubtitleColor = const Color(0xFF1E1E4C),
    this.checkboxSize = 'Medium',
    this.checkboxColor = const Color(0xFF1E1E4C),
  });

  @override
  Widget build(BuildContext context) {
    return LoginTemplate(
      width: width,
      height: height,
      isFullScreen: isFullScreen,
      leftSection: LeftInfoSection(
        leftImagePath: leftImagePath,
      ),
      rightSection: RightLoginContainer(
        title: title,
        subtitle: subtitle,
        customerIdLabel: customerIdLabel,
        customerIdHint: customerIdHint,
        passwordLabel: passwordLabel,
        buttonText: buttonText,
        qrText: qrText,
        qrSubtitle: qrSubtitle,
        titleSize: titleSize,
        titleColor: titleColor,
        subtitleSize: subtitleSize,
        subtitleColor: subtitleColor,
        customerIdSize: customerIdSize,
        customerIdColor: customerIdColor,
        passwordSize: passwordSize,
        passwordColor: passwordColor,
        buttonSize: buttonSize,
        buttonColor: buttonColor,
        qrTextSize: qrTextSize,
        qrTextColor: qrTextColor,
        qrSubtitleSize: qrSubtitleSize,
        qrSubtitleColor: qrSubtitleColor,
        checkboxSize: checkboxSize,
        checkboxColor: checkboxColor,
      ),
    );
  }
}