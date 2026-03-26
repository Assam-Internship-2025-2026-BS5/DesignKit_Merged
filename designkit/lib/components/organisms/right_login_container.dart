import 'package:flutter/material.dart';
import '../../core/tokens/spacing.dart';
import 'landing_form.dart';

/// A container organism typically shown on the right side of a login page.
/// 
/// Features a background image and centers the [LandingFormOrganism] 
/// within it, managing responsiveness and overall layout.
class RightLoginContainer extends StatelessWidget {
  /// The optional width of the container.
  final double? width;

  /// The optional height of the container.
  final double? height;

  /// The main heading text for the form.
  final String title;

  /// The supporting brand text for the form.
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

  const RightLoginContainer({
    super.key,
    this.width,
    this.height,
    this.title = "Welcome to NetBanking",
    this.subtitle = "MADE DIGITAL BY",
    this.customerIdLabel = "Customer ID/User ID",
    this.customerIdHint = "Customer ID/ User ID",
    this.passwordLabel = "Password",
    this.buttonText = "Login",
    this.qrText = "Click to scan QR and login",
    this.qrSubtitle = "New HDFC Bank Early Access App Required",
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
    Widget content = Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/right_back.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
                child: LandingFormOrganism(
                  width: constraints.maxWidth * 0.85, // Slightly wider form
                  height: constraints.maxHeight * 0.95, // Slightly taller form
                  tintColor: const Color(0x33FFFFFF),
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
            ),
          );
        },
      ),
    );

    // In standalone preview mode (explicit dimensions), center the component
    if (width != null && height != null) {
      return Center(child: content);
    }
    // Inside Expanded (NetBankingLoginPage), fill the parent
    return content;
  }
}