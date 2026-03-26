import 'package:flutter/material.dart';
import '../../components/organisms/left_info_section.dart';
import '../../components/organisms/right_login_container.dart';
import '../templates/login_template.dart';

class NetBankingLoginPage extends StatelessWidget {
  final double width;
  final double height;
  final bool isFullScreen;

  const NetBankingLoginPage({
    super.key,
    this.width = 1440,
    this.height = 900,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return LoginTemplate(
      width: width,
      height: height,
      isFullScreen: isFullScreen,
      leftSection: const LeftInfoSection(),
      rightSection: const RightLoginContainer(),
    );
  }
}