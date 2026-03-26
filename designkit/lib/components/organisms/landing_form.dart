import 'package:flutter/material.dart' hide Text;
import '../atoms/glass_card.dart' as dk;
import '../atoms/text_button.dart' as dk;
import '../atoms/login_button.dart' as dk;
import '../atoms/text.dart' as dk;
import '../atoms/checkbox.dart' as dk;
import '../atoms/image_atom.dart';
import '../molecules/qr_login.dart';
import '../molecules/digicart_security.dart';
import '../molecules/labeled_input_field.dart';
import '../molecules/password_field.dart';
import '../../core/tokens/typography.dart';
import '../../core/tokens/spacing.dart';
import '../../core/tokens/radius.dart';

/// A complex organism representing the main login form on the landing page.
/// 
/// Features a large glass card containing:
/// - Branded headers and logos
/// - QR login integration
/// - Customer ID and Password fields
/// - Security banners
/// - "Keep me logged in" preference
/// - Primary login button
/// - Registration footer
class LandingFormOrganism extends StatefulWidget {
  /// The total width of the form container.
  final double width;

  /// The total height of the form container.
  final double height;

  /// The base tint color of the glass card.
  final Color tintColor;

  /// Callback for "Set/Reset Password" action.
  final VoidCallback? onSetResetPassword;

  /// Callback for "Register Now" action.
  final VoidCallback? onRegisterNow;

  /// The main heading text.
  final String title;

  /// The supporting brand text.
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

  const LandingFormOrganism({
    super.key,
    this.width = 550,
    this.height = 720,
    this.tintColor = const Color(0x33FFFFFF),
    this.onSetResetPassword,
    this.onRegisterNow,
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
  State<LandingFormOrganism> createState() => _LandingFormOrganismState();
}

class _LandingFormOrganismState extends State<LandingFormOrganism> {
  bool _keepMeLoggedIn = false;
  String _customerId = "";
  String _password = "";

  bool _isPasswordValid(String value) {
    if (value.length < 8 || value.length > 16) return false;
    if (!value.contains(RegExp(r'[A-Z]'))) return false;
    if (!value.contains(RegExp(r'[a-z]'))) return false;
    if (!value.contains(RegExp(r'[0-9]'))) return false;
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 500;
        final isVeryShort = constraints.maxHeight < 700;
        // Dynamically compute gap sizes based on available height
        final double gap = isVeryShort ? AppSpacing.xSmall : AppSpacing.medium;
        final double smallGap = isVeryShort ? AppSpacing.xxSmall : AppSpacing.xSmall;
        // Helper method to convert 'Small' / 'Large' sizes into a scale modifier
        double scale(String sz) {
          if (sz == 'Small') return 0.8;
          if (sz == 'Large') return 1.2;
          return 1.0;
        }

        final tScale = scale(widget.titleSize);
        final sScale = scale(widget.subtitleSize);
        final cidScale = scale(widget.customerIdSize);
        final pScale = scale(widget.passwordSize);
        final bScale = scale(widget.buttonSize);
        final qrScale = scale(widget.qrTextSize);
        final qrSubScale = scale(widget.qrSubtitleSize);
        final checkboxScale = scale(widget.checkboxSize);

        return Center(
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Column(
              children: [
                // GlassCard takes all available space minus footer
                Expanded(
                  child: dk.GlassCard(
                    width: widget.width,
                    tintColor: widget.tintColor,
                    borderRadius: AppRadius.circular,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmall ? AppSpacing.medium : AppSpacing.large,
                      vertical: isVeryShort ? AppSpacing.medium : AppSpacing.large,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// WELCOME HEADER
                        dk.Text(
                          text: widget.title,
                          fontSize: (isSmall ? AppTypography.fontLargePlus : AppTypography.fontH2) * tScale,
                          fontWeight: FontWeight.bold,
                          color: widget.titleColor,
                        ),

                        /// LOGO SECTION
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dk.Text(
                              text: widget.subtitle,
                              fontSize: (isSmall ? AppTypography.fontSmall : AppTypography.fontMedium) * sScale,
                              fontWeight: FontWeight.bold,
                              color: widget.subtitleColor,
                              letterSpacing: 0.5,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                dkImage(imagePath: 'assets/hdfc_logo.png', height: isSmall ? 15 : 18),
                                const SizedBox(width: 12),
                                dkImage(imagePath: 'assets/now_logo.png', height: isSmall ? 11 : 14),
                              ],
                            ),
                          ],
                        ),

                        /// QR SCANNER BOX
                        QrLogin(
                          title: widget.qrText,
                          subtitle: widget.qrSubtitle,
                          width: double.infinity,
                          height: isVeryShort ? 70 : 85,
                          imagePath: 'assets/qr_login.png',
                          opacity: 0.3,
                          textColor: widget.qrTextColor,
                          textScale: qrScale,
                          subtitleColor: widget.qrSubtitleColor,
                          subtitleScale: qrSubScale,
                        ),

                        /// INPUT SECTION
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LabeledInputField(
                              label: '${widget.customerIdLabel} *',
                              hintText: widget.customerIdHint,
                              labelColor: widget.customerIdColor,
                              labelFontSize: AppTypography.fontMedium * cidScale,
                              onChanged: (val) {
                                setState(() {
                                  _customerId = val;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            dk.TextButton(
                              text: "Get Customer ID",
                              onPressed: () {
                                debugPrint("Get Customer ID Pressed");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: dk.Text(
                                      text: "Redirecting to the secure Customer ID retrieval portal.",
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              color: widget.customerIdColor,
                              fontSize: (isSmall ? AppTypography.fontMedium : AppTypography.fontLarge) * cidScale,
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PasswordField(
                              label: '${widget.passwordLabel} *',
                              hintText: "Password",
                              labelColor: widget.passwordColor,
                              labelFontSize: AppTypography.fontMedium * pScale,
                              onChanged: (val) {
                                setState(() {
                                  _password = val;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            dk.TextButton(
                              text: "Set/Reset Password",
                              onPressed: () {
                                if (widget.onSetResetPassword != null) {
                                  widget.onSetResetPassword!();
                                } else {
                                  debugPrint("Set/Reset Password Pressed");
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: dk.Text(
                                      text: "A secure password reset link has been dispatched to your registered email address.",
                                      fontSize: 14.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              color: widget.passwordColor,
                              fontSize: (isSmall ? AppTypography.fontMedium : AppTypography.fontLarge) * pScale,
                            ),
                          ],
                        ),

                        /// SECURITY BANNER
                        DigicartSecurity(
                          title: "Goodbye, Secure Text & Image",
                          subtitle: "Hello, Digicert Security",
                          imagePath: 'assets/lock.png',
                          width: double.infinity,
                          height: isVeryShort ? 70 : 85,
                          opacity: 0.3,
                          onTap: () => debugPrint("Digicart Security Tapped"),
                        ),

                        /// KEEP ME LOGGED IN
                        dk.Checkbox(
                          value: _keepMeLoggedIn,
                          label: "Keep me logged in",
                          size: (isSmall ? 0.45 : 0.6) * checkboxScale,
                          labelColor: widget.checkboxColor,
                          activeColor: widget.checkboxColor,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _keepMeLoggedIn = val;
                              });
                            }
                          },
                        ),

                        /// LOGIN BUTTON
                        dk.LoginButton(
                          text: widget.buttonText,
                          disabled: _customerId.trim().isEmpty || !_isPasswordValid(_password),
                          onTap: () {
                            debugPrint("Login Pressed");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: dk.Text(
                                  text: "Login Successful ✅",
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                          width: double.infinity,
                          height: (isVeryShort ? 46.0 : 55.0) * bScale,
                          color: widget.buttonColor,
                          fontSize: 25.0 * bScale,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),

                /// FOOTER (Outside GlassCard)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     dk.Text(
                       text: "Not registered for NetBanking? ",
                       fontSize: (isSmall ? AppTypography.fontSmall : AppTypography.fontMedium) * bScale,
                       color: Colors.black87,
                     ),
                    dk.TextButton(
                      text: "Register Now",
                      onPressed: () {
                        if (widget.onRegisterNow != null) {
                          widget.onRegisterNow!();
                        } else {
                          debugPrint("Register Now Pressed");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: dk.Text(
                              text: "Redirecting to the official NetBanking registration portal.",
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      color: widget.buttonColor,
                      fontSize: (isSmall ? AppTypography.fontSmall : AppTypography.fontMedium) * bScale,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
