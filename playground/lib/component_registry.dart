import 'component_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import the merged designkit, hiding Flutter's own names where they clash.
import 'package:designkit/designkit.dart'
    hide
        Text,
        TextField,
        TextButton,
        Checkbox,
        RadioButton,
        ToggleSwitch;
import 'package:designkit/designkit.dart' as dk
    show
        Text,
        TextField,
        TextButton,
        Checkbox,
        RadioButton,
        ToggleSwitch,
        Dropdown,
        MobileButton,
        Icon,
        Header,
        MobileImageWidget,
        GlassContainer;

// ─────────────────────────────────────────────────────────────────────────────
// FULL COMPONENT REGISTRY
// ─────────────────────────────────────────────────────────────────────────────
final List<ComponentMetadata> componentRegistry = [

  // =========================================================================
  // PAGES
  // =========================================================================

  ComponentMetadata(
    name: 'NetBanking Login Page',
    category: 'Pages',
    platform: ComponentPlatform.web,
    defaultProps: {
      '_width': 1440.0,
      '_height': 900.0,
      'title': 'Welcome to NetBanking',
      'subtitle': 'MADE DIGITAL BY',
      'customerIdLabel': 'Customer ID/User ID',
      'customerIdHint': 'Customer ID/ User ID',
      'passwordLabel': 'Password',
      'buttonText': 'Login',
      'qrText': 'Click to scan QR and login',
      'qrSubtitle': 'New HDFC Bank Early Access App Required',
      'leftImagePath': 'assets/left_image.png',
      'titleSize': 'Medium',
      'titleColor': const Color(0xFF1E1E4C),
      'subtitleSize': 'Medium',
      'subtitleColor': const Color(0xFF1E1E4C),
      'customerIdSize': 'Medium',
      'customerIdColor': const Color(0xFF1E1E4C),
      'passwordSize': 'Medium',
      'passwordColor': const Color(0xFF1E1E4C),
      'buttonSize': 'Medium',
      'buttonColor': const Color(0xFF004C8F),
      'qrTextSize': 'Medium',
      'qrTextColor': const Color(0xFF1E1E4C),
      'qrSubtitleSize': 'Medium',
      'qrSubtitleColor': const Color(0xFF1E1E4C),
      'checkboxSize': 'Medium',
      'checkboxColor': const Color(0xFF1E1E4C),
    },
    options: {
      'titleSize': ['Small', 'Medium', 'Large'],
      'subtitleSize': ['Small', 'Medium', 'Large'],
      'customerIdSize': ['Small', 'Medium', 'Large'],
      'passwordSize': ['Small', 'Medium', 'Large'],
      'buttonSize': ['Small', 'Medium', 'Large'],
      'qrTextSize': ['Small', 'Medium', 'Large'],
      'qrSubtitleSize': ['Small', 'Medium', 'Large'],
      'checkboxSize': ['Small', 'Medium', 'Large'],
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return NetBankingLoginPage(
        isFullScreen: isFullScreen,
        title: props['title'] ?? 'Welcome to NetBanking',
        subtitle: props['subtitle'] ?? 'MADE DIGITAL BY',
        customerIdLabel: props['customerIdLabel'] ?? 'Customer ID/User ID',
        customerIdHint: props['customerIdHint'] ?? 'Customer ID/ User ID',
        passwordLabel: props['passwordLabel'] ?? 'Password',
        buttonText: props['buttonText'] ?? 'Login',
        qrText: props['qrText'] ?? 'Click to scan QR and login',
        qrSubtitle: props['qrSubtitle'] ?? 'New HDFC Bank Early Access App Required',
        leftImagePath: props['leftImagePath'] ?? 'assets/left_image.png',
        titleSize: props['titleSize'] ?? 'Medium',
        titleColor: props['titleColor'] ?? const Color(0xFF1E1E4C),
        subtitleSize: props['subtitleSize'] ?? 'Medium',
        subtitleColor: props['subtitleColor'] ?? const Color(0xFF1E1E4C),
        customerIdSize: props['customerIdSize'] ?? 'Medium',
        customerIdColor: props['customerIdColor'] ?? const Color(0xFF1E1E4C),
        passwordSize: props['passwordSize'] ?? 'Medium',
        passwordColor: props['passwordColor'] ?? const Color(0xFF1E1E4C),
        buttonSize: props['buttonSize'] ?? 'Medium',
        buttonColor: props['buttonColor'] ?? const Color(0xFF004C8F),
        qrTextSize: props['qrTextSize'] ?? 'Medium',
        qrTextColor: props['qrTextColor'] ?? const Color(0xFF1E1E4C),
        qrSubtitleSize: props['qrSubtitleSize'] ?? 'Medium',
        qrSubtitleColor: props['qrSubtitleColor'] ?? const Color(0xFF1E1E4C),
        checkboxSize: props['checkboxSize'] ?? 'Medium',
        checkboxColor: props['checkboxColor'] ?? const Color(0xFF1E1E4C),
      );
    },
  ),

  ComponentMetadata(
    name: 'Home Page',
    category: 'Pages',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'userName': 'MHONBENI NGULLIE',
      'customerId': '******1010',
      'primaryButtonTitle': 'Login with Fingerprint',
      'leftActionLabel': 'Or, login with mPIN',
      'rightActionLabel': 'Forgot mPIN?',
      'scanTitle': 'QR Scan',
      'scanPopupTitle': 'Scan Code',
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return SizedBox(
        width: 375,
        height: 812,
        child: HomePage(
          userName: props['userName'] ?? 'MHONBENI NGULLIE',
          customerId: props['customerId'] ?? '******1010',
          logoPath: 'assets/hdfc_logo.png',
          actionItems: [
            ActionItemData(title: 'Send Money', imagePath: 'assets/Send_money.png', isFullImage: true),
            ActionItemData(title: 'Pay Bills', imagePath: 'assets/Pay_bills.png', isFullImage: true),
            ActionItemData(title: 'Products', imagePath: 'assets/Product_services.png', isFullImage: true),
          ],
          navItems: [
            BottomNavItemData(icon: Icons.build_circle_outlined, label: 'Maintenance'),
            BottomNavItemData(icon: Icons.chat_bubble_outline, label: 'Reach Us'),
            BottomNavItemData(icon: Icons.more_horiz_rounded, label: 'More'),
          ],
          primaryButtonTitle: props['primaryButtonTitle'] ?? 'Login with Fingerprint',
          primaryButtonIcon: Icons.fingerprint,
          leftActionLabel: props['leftActionLabel'] ?? 'Or, login with mPIN',
          rightActionLabel: props['rightActionLabel'] ?? 'Forgot mPIN?',
          scanTitle: props['scanTitle'] ?? 'QR Scan',
          scanPopupTitle: props['scanPopupTitle'] ?? 'Scan Code',
          onPrimaryButtonTap: () => debugPrint('Primary Tapped'),
          onLeftActionTap: () => debugPrint('Left Action Tapped'),
          onRightActionTap: () => debugPrint('Right Action Tapped'),
          onScanTap: () => debugPrint('Scan Tapped'),
          onIdChanged: (id) {
            onUpdate?.call();
          },
        ),
      );
    },
  ),

  // =========================================================================
  // ORGANISMS
  // =========================================================================

  ComponentMetadata(
    name: 'Landing Form',
    category: 'Organisms',
    platform: ComponentPlatform.web,
    defaultProps: {
      'width': 500.0,
      'height': 720.0,
      'tintColor': const Color(0x33FFFFFF),
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return LandingFormOrganism(
        width: (props['width'] as num?)?.toDouble() ?? 500.0,
        height: (props['height'] as num?)?.toDouble() ?? 720.0,
        tintColor: props['tintColor'] ?? const Color(0x33FFFFFF),
        onSetResetPassword: () => debugPrint('Set/Reset Password'),
        onRegisterNow: () => debugPrint('Register Now'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Left Info Section',
    category: 'Organisms',
    platform: ComponentPlatform.web,
    defaultProps: {'width': 550.0, 'height': 780.0},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return LeftInfoSection(
        width: (props['width'] as num?)?.toDouble() ?? 550.0,
        height: (props['height'] as num?)?.toDouble() ?? 780.0,
      );
    },
  ),

  ComponentMetadata(
    name: 'Right Login Container',
    category: 'Organisms',
    platform: ComponentPlatform.web,
    defaultProps: {'width': 500.0, 'height': 780.0},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return RightLoginContainer(
        width: (props['width'] as num?)?.toDouble() ?? 500.0,
        height: (props['height'] as num?)?.toDouble() ?? 780.0,
      );
    },
  ),

  ComponentMetadata(
    name: 'App Header',
    category: 'Organisms',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'userName': 'MHONBENI NGULLIE',
      'customerId': '******1010',
      'width': 375.0,
      'backgroundColor': const Color(0xFFC7E2FE),
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return AppHeader(
        userName: props['userName'] ?? 'MHONBENI NGULLIE',
        customerId: props['customerId'] ?? '******1010',
        logoPath: 'assets/hdfc_logo.png',
        backgroundColor: props['backgroundColor'] ?? const Color(0xFFC7E2FE),
        width: (props['width'] as num?)?.toDouble() ?? 375.0,
        onNotificationTap: () => debugPrint('Notification Tapped'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Auth Section',
    category: 'Organisms',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'primaryActionTitle': 'Login with Fingerprint',
      'leftActionLabel': 'Or, login with mPIN',
      'rightActionLabel': 'Forgot mPIN?',
      'width': 375.0,
      'showFingerprint': false,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return AuthSection(
        primaryActionTitle: props['primaryActionTitle'] ?? 'Login with Fingerprint',
        leftActionLabel: props['leftActionLabel'] ?? 'Or, login with mPIN',
        rightActionLabel: props['rightActionLabel'] ?? 'Forgot mPIN?',
        width: (props['width'] as num?)?.toDouble() ?? 375.0,
        showFingerprint: props['showFingerprint'] ?? false,
        onPrimaryActionTap: () => debugPrint('Primary Tapped'),
        onLeftActionTap: () => debugPrint('Left Tapped'),
        onRightActionTap: () => debugPrint('Right Tapped'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Bottom Nav',
    category: 'Organisms',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'backgroundColor': Colors.white,
      'activeColor': const Color(0xFF004C8F),
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return BottomNav(
        backgroundColor: props['backgroundColor'] ?? Colors.white,
        activeColor: props['activeColor'] ?? const Color(0xFF004C8F),
        items: [
          BottomNavItemData(icon: Icons.build_circle_outlined, label: 'Maintenance'),
          BottomNavItemData(icon: Icons.chat_bubble_outline, label: 'Reach Us'),
          BottomNavItemData(icon: Icons.more_horiz_rounded, label: 'More'),
        ],
        onNavTap: (label) => debugPrint('Nav: $label'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Mobile Header',
    category: 'Organisms',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'userName': 'MHONBENI NGULLIE',
      'customerId': '******1010',
      'textColor': Colors.black,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return Header(
        userName: props['userName'] ?? 'MHONBENI NGULLIE',
        customerId: props['customerId'] ?? '******1010',
        logoPath: 'assets/hdfc_logo.png',
        textColor: props['textColor'] ?? Colors.black,
        onNotificationTap: () => debugPrint('Notification'),
        onProfileTap: () => debugPrint('Profile'),
      );
    },
  ),

  // =========================================================================
  // MOLECULES
  // =========================================================================

  ComponentMetadata(
    name: 'QR Login',
    category: 'Molecules',
    platform: ComponentPlatform.web,
    defaultProps: {
      'title': 'Click to scan QR and login',
      'subtitle': 'New HDFC Bank Early Access App Required',
      'width': 484.0,
      'height': 120.0,
      'opacity': 0.2,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return QrLogin(
        title: props['title'] ?? 'Click to scan QR and login',
        subtitle: props['subtitle'] ?? 'New HDFC Bank Early Access App Required',
        imagePath: 'assets/qr_login.png',
        width: (props['width'] as num?)?.toDouble() ?? 484.0,
        height: (props['height'] as num?)?.toDouble() ?? 120.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
      );
    },
  ),

  ComponentMetadata(
    name: 'Digicart Security',
    category: 'Molecules',
    platform: ComponentPlatform.web,
    defaultProps: {
      'title': 'Goodbye, Secure Text & Image',
      'subtitle': 'Hello, Digicert Security',
      'width': 484.0,
      'height': 120.0,
      'opacity': 0.2,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return DigicartSecurity(
        title: props['title'] ?? 'Goodbye, Secure Text & Image',
        subtitle: props['subtitle'] ?? 'Hello, Digicert Security',
        imagePath: 'assets/lock.png',
        width: (props['width'] as num?)?.toDouble() ?? 484.0,
        height: (props['height'] as num?)?.toDouble() ?? 120.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
        onTap: () => debugPrint('Security Card Tapped'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Labeled Input Field',
    category: 'Molecules',
    platform: ComponentPlatform.web,
    defaultProps: {
      'label': 'Customer ID/ User ID',
      'labelColor': const Color(0xFF1E1E4C),
      'labelSize': 'Medium',
      'labelWeight': FontWeight.normal,
      'inputHint': 'Enter your ID',
      'inputColor': Colors.black87,
      'inputSize': 'Medium',
      'inputWeight': FontWeight.normal,
      'width': 700.0,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {
      'labelSize': ['Small', 'Medium', 'Large'],
      'inputSize': ['Small', 'Medium', 'Large'],
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final labelSize = props['labelSize'] ?? 'Medium';
      double labelFontSize = labelSize == 'Small' ? 24.0 : labelSize == 'Large' ? 40.0 : 32.0;
      final inputSize = props['inputSize'] ?? 'Medium';
      double inputFontSize = inputSize == 'Small' ? 24.0 : inputSize == 'Large' ? 50.0 : 36.0;
      return LabeledInputField(
        label: props['label'] ?? 'Customer ID/ User ID',
        hintText: props['inputHint'] ?? 'Enter your ID',
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
        labelColor: props['labelColor'] ?? const Color(0xFF1E1E4C),
        labelFontSize: labelFontSize,
        labelWeight: props['labelWeight'] ?? FontWeight.normal,
        inputColor: props['inputColor'] ?? Colors.black87,
        inputFontSize: inputFontSize,
        inputWeight: props['inputWeight'] ?? FontWeight.normal,
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),

  ComponentMetadata(
    name: 'Password Field',
    category: 'Molecules',
    platform: ComponentPlatform.web,
    defaultProps: {
      'label': 'Password/ PIN',
      'labelColor': const Color(0xFF1E1E4C),
      'labelSize': 'Medium',
      'labelWeight': FontWeight.normal,
      'inputHint': 'Enter password',
      'inputColor': Colors.black87,
      'inputSize': 'Medium',
      'inputWeight': FontWeight.normal,
      'width': 700.0,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {
      'labelSize': ['Small', 'Medium', 'Large'],
      'inputSize': ['Small', 'Medium', 'Large'],
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final labelSize = props['labelSize'] ?? 'Medium';
      double labelFontSize = labelSize == 'Small' ? 24.0 : labelSize == 'Large' ? 40.0 : 32.0;
      final inputSize = props['inputSize'] ?? 'Medium';
      double inputFontSize = inputSize == 'Small' ? 24.0 : inputSize == 'Large' ? 50.0 : 36.0;
      return PasswordField(
        label: props['label'] ?? 'Password/ PIN',
        hintText: props['inputHint'] ?? 'Enter password',
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
        labelColor: props['labelColor'] ?? const Color(0xFF1E1E4C),
        labelFontSize: labelFontSize,
        labelWeight: props['labelWeight'] ?? FontWeight.normal,
        inputColor: props['inputColor'] ?? Colors.black87,
        inputFontSize: inputFontSize,
        inputWeight: props['inputWeight'] ?? FontWeight.normal,
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),

  ComponentMetadata(
    name: 'Dropdown',
    category: 'Molecules',
    platform: ComponentPlatform.web,
    defaultProps: {
      'label': 'Select Account',
      'value': 'Savings Account - 1234',
      'items': [
        'Savings Account - 1234',
        'Current Account - 5678',
        'Fixed Deposit - 9012',
        'Salary Account - 3456',
        'Business Account - 7890',
        'NRI Account - 1122',
      ],
      'width': 300.0,
      'activeColor': AppColors.hdfcBlue,
      'disabled': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {
      'value': [
        'Savings Account - 1234',
        'Current Account - 5678',
        'Fixed Deposit - 9012',
        'Salary Account - 3456',
        'Business Account - 7890',
        'NRI Account - 1122',
      ],
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return StatefulBuilder(
        builder: (context, setState) {
          return dk.Dropdown(
            label: props['label'],
            value: props['value'],
            items: List<String>.from(props['items'] ?? []),
            width: (props['width'] as num?)?.toDouble() ?? 300.0,
            activeColor: props['activeColor'] ?? AppColors.hdfcBlue,
            enabled: !(props['disabled'] ?? false),
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
            ),
            onChanged: (val) {
              setState(() => props['value'] = val);
              onUpdate?.call();
            },
          );
        },
      );
    },
  ),

  ComponentMetadata(
    name: 'QR Scan',
    category: 'Molecules',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'title': 'QR Scan',
      'width': 130.0,
      'height': 130.0,
      'blur': 15.0,
      'opacity': 0.2,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return Scan(
        title: props['title'] ?? 'QR Scan',
        subtitle: '',
        popupTitle: 'Scan Code',
        qrData: 'https://www.hdfcbank.com',
        imagePath: 'assets/Qr_scan.png',
        textColor: const Color(0xFF1E3A8A),
        circleColor: const Color(0xFFE8EEFF),
        accentColor: const Color(0xFF8B5CF6),
        width: (props['width'] as num?)?.toDouble() ?? 130.0,
        height: (props['height'] as num?)?.toDouble() ?? 130.0,
        blur: (props['blur'] as num?)?.toDouble() ?? 15.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
      );
    },
  ),

  ComponentMetadata(
    name: 'Action Items',
    category: 'Molecules',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'itemWidth': 100.0,
      'itemHeight': 100.0,
      'opacity': 0.1,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return ActionItems(
        items: [
          ActionItemData(title: 'Send Money', imagePath: 'assets/Send_money.png', isFullImage: true),
          ActionItemData(title: 'Pay Bills', imagePath: 'assets/Pay_bills.png', isFullImage: true),
          ActionItemData(title: 'Products', imagePath: 'assets/Product_services.png', isFullImage: true, showBadge: true),
        ],
        itemWidth: (props['itemWidth'] as num?)?.toDouble() ?? 100.0,
        itemHeight: (props['itemHeight'] as num?)?.toDouble() ?? 100.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.1,
        onItemTap: (item) => debugPrint('Tapped: ${item.title}'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Inline Action Row',
    category: 'Molecules',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'leftLabel': 'Or, login with mPIN',
      'rightLabel': 'Forgot mPIN?',
      'spacing': 80.0,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return InlineActionRow(
        leftLabel: props['leftLabel'] ?? 'Or, login with mPIN',
        rightLabel: props['rightLabel'] ?? 'Forgot mPIN?',
        spacing: (props['spacing'] as num?)?.toDouble() ?? 80.0,
        onLeftTap: () => debugPrint('Left Label Tapped'),
        onRightTap: () => debugPrint('Right Label Tapped'),
      );
    },
  ),

  // =========================================================================
  // ATOMS
  // =========================================================================

  ComponentMetadata(
    name: 'Glass Card',
    category: 'Atoms',
    platform: ComponentPlatform.web,
    defaultProps: {
      'width': 550.0,
      'height': 300.0,
      'opacity': 0.12,
      'showShadow': true,
      'showTitle': true,
      'borderRadius': 20.0,
      'tintColor': const Color(0xFF3B82F6),
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return GlassCard(
        width: (props['width'] as num?)?.toDouble() ?? 550.0,
        height: (props['height'] as num?)?.toDouble() ?? 300.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.12,
        showShadow: props['showShadow'] ?? true,
        borderRadius: (props['borderRadius'] as num?)?.toDouble() ?? 20.0,
        tintColor: props['tintColor'] ?? const Color(0xFF3B82F6),
        child: (props['showTitle'] ?? true)
            ? const Center(
                child: dk.Text(
                    text: 'Glass Card', fontSize: 20.0, color: Colors.black),
              )
            : const SizedBox(),
      );
    },
  ),

  ComponentMetadata(
    name: 'Glass Container',
    category: 'Atoms',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'blur': 15.0,
      'opacity': 0.1,
      'borderRadius': 20.0,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return dk.GlassContainer(
        blur: (props['blur'] as num?)?.toDouble() ?? 15.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.1,
        borderRadius: BorderRadius.circular(
            (props['borderRadius'] as num?)?.toDouble() ?? 20.0),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: dk.Text(text: 'Glass Container', fontSize: 18.0, color: Colors.black),
        ),
      );
    },
  ),

  ComponentMetadata(
    name: 'Text',
    category: 'Atoms',
    platform: ComponentPlatform.shared,
    defaultProps: {
      'text': 'Hello World',
      'size': 'Medium',
      'color': Colors.black,
      'fontWeight': FontWeight.normal,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {'size': ['Small', 'Medium', 'Large']},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double fontSize = size == 'Small' ? 24.0 : size == 'Large' ? 64.0 : 40.0;
      return dk.Text(
        text: props['text'] ?? 'Hello World',
        fontSize: fontSize,
        color: props['color'],
        fontWeight: props['fontWeight'],
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),

  ComponentMetadata(
    name: 'Text Field',
    category: 'Atoms',
    platform: ComponentPlatform.web,
    defaultProps: {
      'hintText': 'Enter text',
      'isPassword': false,
      'height': 80.0,
      'width': 400.0,
      'showErrorText': false,
      'color': Colors.black,
      'fontWeight': FontWeight.normal,
      'size': 'Medium',
      'disabled': false,
      'restrictNumbers': false,
      'restrictAlphabets': false,
      'restrictSpecialCharacters': false,
      'restrictCopyPaste': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {'size': ['Small', 'Medium', 'Large']},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double fontSize = size == 'Small' ? 20.0 : size == 'Large' ? 36.0 : 28.0;
      final List<FilteringTextInputFormatter> formatters = [];
      if (props['restrictNumbers'] ?? false) {
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'[0-9]')));
      }
      if (props['restrictAlphabets'] ?? false) {
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')));
      }
      if (props['restrictSpecialCharacters'] ?? false) {
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9\s]')));
      }
      return dk.TextField(
        hintText: props['hintText'] ?? 'Enter text',
        isPassword: props['isPassword'] ?? false,
        height: (props['height'] as num?)?.toDouble() ?? 80.0,
        width: (props['width'] as num?)?.toDouble() ?? 400.0,
        showErrorText: props['showErrorText'] ?? false,
        textColor: props['color'] ?? Colors.black,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
        fontSize: fontSize,
        enabled: !(props['disabled'] ?? false),
        keyboardType: (props['restrictAlphabets'] ?? false) && !(props['restrictNumbers'] ?? false)
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: formatters.isEmpty ? null : formatters,
        enableInteractiveSelection: !(props['restrictCopyPaste'] ?? false),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),

  ComponentMetadata(
    name: 'Button',
    category: 'Atoms',
    platform: ComponentPlatform.web,
    defaultProps: {
      'text': 'Know More',
      'size': 'Medium',
      'disabled': false,
      'color': const Color(0xFF004C8F),
      'opacity': 0.8,
      'fontWeight': FontWeight.normal,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {'size': ['Small', 'Medium', 'Large']},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double width = size == 'Small' ? 200.0 : size == 'Large' ? 450.0 : 321.0;
      double height = size == 'Small' ? 60.0 : size == 'Large' ? 100.0 : 80.0;
      return Button(
        text: props['text'] ?? 'Know More',
        width: width,
        height: height,
        disabled: props['disabled'] ?? false,
        color: props['color'] ?? const Color(0xFF004C8F),
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.8,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
        onTap: () => debugPrint('Button Pressed'),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),

  ComponentMetadata(
    name: 'Mobile Button',
    category: 'Atoms',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'text': 'Login with Fingerprint',
      'width': 321.0,
      'height': 61.0,
      'disabled': false,
      'buttonColor': const Color(0xFF5371F9),
      'isSingleColor': false,
      'opacity': 0.8,
      'textColor': Colors.white,
      'fontSize': 22.0,
      'fontWeight': FontWeight.w600,
      'borderRadius': 20.0,
      'fingerprint': false,
      'forward': false,
      'backward': false,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return dk.MobileButton(
        text: props['text'] ?? 'Login with Fingerprint',
        width: (props['width'] as num?)?.toDouble() ?? 321.0,
        height: (props['height'] as num?)?.toDouble() ?? 61.0,
        disabled: props['disabled'] ?? false,
        buttonColor: props['buttonColor'] ?? const Color(0xFF5371F9),
        isSingleColor: props['isSingleColor'] ?? false,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.8,
        textColor: props['textColor'] ?? Colors.white,
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 22.0,
        fontWeight: props['fontWeight'] ?? FontWeight.w600,
        borderRadius: (props['borderRadius'] as num?)?.toDouble() ?? 20.0,
        showFingerprint: props['fingerprint'] ?? false,
        showForwardArrow: props['forward'] ?? false,
        showBackwardArrow: props['backward'] ?? false,
        onTap: () => debugPrint('Mobile Button Pressed'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Checkbox',
    category: 'Atoms',
    platform: ComponentPlatform.shared,
    defaultProps: {
      'label': 'Keep me logged in',
      'size': 'Medium',
      'disabled': false,
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': const Color(0xFF1E1E4C),
      'fontWeight': FontWeight.normal,
      'opacity': 1.0,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {'size': ['Small', 'Medium', 'Large']},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final sizeOpt = props['size'] ?? 'Medium';
      double componentSize = sizeOpt == 'Small' ? 0.8 : sizeOpt == 'Large' ? 1.2 : 1.0;
      return dk.Checkbox(
        value: props['value'] ?? false,
        label: props['label'],
        size: componentSize,
        disabled: props['disabled'] ?? false,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 1.0,
        activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
        labelColor: props['labelColor'] ?? const Color(0xFF1E1E4C),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
        onChanged: (val) {
          onUpdate?.call();
          debugPrint('Checkbox: $val');
        },
        onPressed: () => debugPrint('Checkbox pressed'),
      );
    },
  ),

  ComponentMetadata(
    name: 'Text Button',
    category: 'Atoms',
    platform: ComponentPlatform.shared,
    defaultProps: {
      'text': 'Click Me',
      'size': 'Medium',
      'isClickable': true,
      'enableHover': true,
      'fontWeight': FontWeight.normal,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {'size': ['Small', 'Medium', 'Large']},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double fontSize = size == 'Small' ? 24.0 : size == 'Large' ? 64.0 : 40.0;
      return dk.TextButton(
        text: props['text'] ?? 'Click Me',
        fontSize: fontSize,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
        isClickable: props['isClickable'] ?? true,
        enableHover: props['enableHover'] ?? true,
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
        onPressed: () => debugPrint('TextButton Pressed'),
      );
    },
  ),

  // ComponentMetadata(
  //   name: 'Radio Button',
  //   category: 'Atoms',
  //   platform: ComponentPlatform.web,
  //   defaultProps: {
  //     'label': 'Radio Option',
  //     'value': true,
  //     'size': 'Medium',
  //     'activeColor': const Color(0xFF1E1E4C),
  //     'labelColor': Colors.black87,
  //     'fontWeight': FontWeight.normal,
  //     'disabled': false,
  //     'xOffset': 0.0,
  //     'yOffset': 0.0,
  //   },
  //   options: {'size': ['Small', 'Medium', 'Large']},
  //   builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
  //     final size = props['size'] ?? 'Medium';
  //     double fontSize = size == 'Small' ? 28.0 : size == 'Large' ? 50.0 : 40.0;
  //     return StatefulBuilder(
  //       builder: (context, setState) {
  //         return dk.RadioButton(
  //           label: props['label'] ?? 'Radio Option',
  //           value: props['value'] ?? false,
  //           fontSize: fontSize,
  //           fontWeight: props['fontWeight'] ?? FontWeight.normal,
  //           activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
  //           labelColor: props['labelColor'] ?? Colors.black87,
  //           offset: Offset(
  //             (props['xOffset'] as num?)?.toDouble() ?? 0.0,
  //             -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
  //           ),
  //           disabled: props['disabled'] ?? false,
  //           onChanged: (val) {
  //             setState(() => props['value'] = val);
  //             onUpdate?.call();
  //           },
  //         );
  //       },
  //     );
  //   },
  // ),

  ComponentMetadata(
    name: 'Toggle Switch',
    category: 'Atoms',
    platform: ComponentPlatform.web,
    defaultProps: {
      'label': 'Enable Notifications',
      'value': false,
      'size': 'Medium',
      'labelColor': Colors.black87,
      'fontWeight': FontWeight.normal,
      'disabled': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {'size': ['Small', 'Medium', 'Large']},
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final sizeOpt = props['size'] ?? 'Medium';
      double componentSize = sizeOpt == 'Small' ? 0.7 : sizeOpt == 'Large' ? 1.4 : 1.0;
      return StatefulBuilder(
        builder: (context, setState) {
          return dk.ToggleSwitch(
            label: props['label'],
            value: props['value'] ?? false,
            size: componentSize,
            fontSize: 30.0,
            fontWeight: props['fontWeight'] ?? FontWeight.normal,
            disabled: props['disabled'] ?? false,
            activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
            labelColor: props['labelColor'] ?? Colors.black87,
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
            ),
            onChanged: (val) {
              setState(() => props['value'] = val);
              onUpdate?.call();
            },
          );
        },
      );
    },
  ),

  ComponentMetadata(
    name: 'Image',
    category: 'Atoms',
    platform: ComponentPlatform.web,
    defaultProps: {
      'imagePath': 'assets/hdfc_logo.png',
      'size': 'Medium',
      'showShadow': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {
      'size': ['Small', 'Medium', 'Large'],
      'imagePath': [
        'assets/hdfc_logo.png',
        'assets/lock.png',
        'assets/now_logo.png',
        'assets/left_image.png',
        'assets/right_back.png',
        'assets/qr_login.png',
      ],
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final String path = props['imagePath'] ?? 'assets/hdfc_logo.png';
      final String size = props['size'] ?? 'Medium';
      final Map<String, Size> imageSizes = {
        'assets/hdfc_logo.png': const Size(400.0, 400.0),
        'assets/lock.png': const Size(100.0, 100.0),
        'assets/left_image.png': const Size(700.0, 700.0),
        'assets/now_logo.png': const Size(120.0, 120.0),
        'assets/right_back.png': const Size(700.0, 700.0),
        'assets/qr_login.png': const Size(400.0, 400.0),
      };
      Size currentSize = imageSizes[path] ?? const Size(300.0, 300.0);
      double multiplier = size == 'Small' ? 0.5 : size == 'Large' ? 1.5 : 1.0;
      return dkImage(
        imagePath: path,
        width: currentSize.width * multiplier,
        height: currentSize.height * multiplier,
        offsetX: (props['xOffset'] as num?)?.toDouble() ?? 0.0,
        offsetY: -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        showShadow: props['showShadow'] ?? false,
      );
    },
  ),

  ComponentMetadata(
    name: 'Custom Icon',
    category: 'Atoms',
    platform: ComponentPlatform.mobile,
    defaultProps: {
      'size': 60.0,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return dk.Icon(
        null,
        imagePath: 'assets/Icon.png',
        size: (props['size'] as num?)?.toDouble() ?? 60.0,
      );
    },
  ),

  ComponentMetadata(
    name: 'Login Button',
    category: 'Atoms',
    platform: ComponentPlatform.web,
    defaultProps: {
      'width': 300.0,
      'height': 52.0,
    },
    builder: (props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return LoginButton(
        width: (props['width'] as num?)?.toDouble() ?? 300.0,
        height: (props['height'] as num?)?.toDouble() ?? 52.0,
        onTap: () => debugPrint('Login'),
      );
    },
  ),
];
