import 'package:flutter/material.dart' hide Text;
import '../atoms/button.dart' as dk;
import '../atoms/text.dart' as dk;
import '../../core/tokens/colors.dart';
import '../../core/tokens/typography.dart';
import '../../core/tokens/spacing.dart';

/// An informational organism typically shown on the left side of a login page.
/// 
/// Displays educational content about security and fraud prevention, 
/// featuring a full-width background image, multi-line text, and a primary 
/// call-to-action button.
class LeftInfoSection extends StatelessWidget {
  /// The optional width of the section.
  final double? width;

  /// The optional height of the section.
  final double? height;

  /// The asset path for the background image.
  final String leftImagePath;

  const LeftInfoSection({
    super.key,
    this.width,
    this.height,
    this.leftImagePath = 'assets/left_image.png',
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(leftImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 600;
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.none,
              horizontal: isSmall ? AppSpacing.large : AppSpacing.xxLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Writing Part
                Column(
                  children: [
                    const SizedBox(height: 60),
                    dk.Text(
                      text: "Digital Arrest is Fake!",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontH2 : AppTypography.fontExtraLarge,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 10),
                    dk.Text(
                      text: "Genuine officers will never detain you\nor ask for money",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontLarge : AppTypography.fontLargePlus,
                      color: AppColors.white.withAlpha(178), // 0.7 * 255
                    ),
                  ],
                ),
    
                // Bottom Writing Part & Know More Button
                Column(
                  children: [
                    dk.Text(
                      text: "When in doubt reach out to your bank.",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontLarge : AppTypography.fontLargePlus,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 8),
                    dk.Text(
                      text: "Click here to know more about Investment and APK Fraud",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontMedium : AppTypography.fontLarge,
                      color: AppColors.white.withAlpha(153), // 0.6 * 255
                    ),
                    const SizedBox(height: 30),
                    
                    // Know More Button
                    dk.Button(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.black,
                            content: dk.Text(
                              text: "Loading detailed fraud prevention guide...",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      text: "Know More",
                      width: isSmall ? 250 : 350,
                      height: 55,
                      color: const Color(0xFF004C8F),
                      opacity: 0.8,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ],
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