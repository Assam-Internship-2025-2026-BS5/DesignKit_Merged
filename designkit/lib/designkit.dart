library designkit;

// ─────────────────────────────────────────────────────────────────────────────
// CORE TOKENS  (from Web team – BS06)
// ─────────────────────────────────────────────────────────────────────────────
export 'core/tokens/colors.dart';
export 'core/tokens/typography.dart';
export 'core/tokens/radius.dart';
export 'core/tokens/spacing.dart';
export 'core/tokens/shadows.dart';

// FOUNDATIONS
export 'core/foundations/custom_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ATOMS – SHARED  (Web BS06 versions; richer API with Offset support)
// ─────────────────────────────────────────────────────────────────────────────
export 'components/atoms/text.dart';
export 'components/atoms/text_button.dart';
export 'components/atoms/text_field.dart';
export 'components/atoms/logo.dart';
export 'components/atoms/image_atom.dart';
export 'components/atoms/glass_card.dart';
export 'components/atoms/button.dart';
export 'components/atoms/login_button.dart';
export 'components/atoms/checkbox.dart';
export 'components/atoms/radio_button.dart';
export 'components/atoms/toggle_switch.dart';
export 'components/atoms/dropdown.dart';

// ATOMS – MOBILE (from Mobile team – BS05; renamed to avoid conflicts)
export 'components/atoms/glass_container.dart';   // GlassContainer
export 'components/atoms/mobile_button.dart';     // MobileButton
export 'components/atoms/icon.dart';              // Icon
export 'components/atoms/mobile_image.dart';      // MobileImageWidget

// ─────────────────────────────────────────────────────────────────────────────
// MOLECULES – WEB  (from Web team – BS06)
// ─────────────────────────────────────────────────────────────────────────────
export 'components/molecules/digicart_security.dart';
export 'components/molecules/labeled_input_field.dart';
export 'components/molecules/password_field.dart';
export 'components/molecules/qr_login.dart';

// MOLECULES – MOBILE  (from Mobile team – BS05)
export 'components/molecules/action_items.dart';
export 'components/molecules/inline_action_row.dart';
export 'components/molecules/primary_button.dart';
export 'components/molecules/scan.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ORGANISMS – WEB  (from Web team – BS06)
// ─────────────────────────────────────────────────────────────────────────────
export 'components/organisms/landing_form.dart';
export 'components/organisms/left_info_section.dart';
export 'components/organisms/right_login_container.dart';

// ORGANISMS – MOBILE  (from Mobile team – BS05)
export 'components/organisms/app_header.dart';
export 'components/organisms/auth_section.dart';
export 'components/organisms/bottom_nav.dart';
export 'components/organisms/header.dart';         // Header

// ─────────────────────────────────────────────────────────────────────────────
// TEMPLATES
// ─────────────────────────────────────────────────────────────────────────────
export 'components/templates/login_template.dart'; // LoginTemplate (responsive)

// ─────────────────────────────────────────────────────────────────────────────
// PAGES
// ─────────────────────────────────────────────────────────────────────────────
export 'components/pages/netbanking_login_page.dart'; // Web  – NetBankingLoginPage
export 'components/pages/home_page.dart';             // Mobile – HomePage
