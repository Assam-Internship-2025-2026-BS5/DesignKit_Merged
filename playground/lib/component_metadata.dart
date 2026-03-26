import 'package:flutter/material.dart';

/// Identifies which platform a component was designed for.
enum ComponentPlatform {
  /// Used in both mobile and web contexts.
  shared,

  /// Mobile app component (from BS05 team).
  mobile,

  /// Web / NetBanking component (from BS06 team).
  web,
}

class ComponentMetadata {
  final String name;
  final String category;

  /// Platform tag – drives the badge shown in the sidebar.
  final ComponentPlatform platform;

  final Widget Function(Map<String, dynamic> props,
      {bool isFullScreen, VoidCallback? onUpdate}) builder;

  final Map<String, dynamic> defaultProps;

  /// Enum / segmented options for string-typed properties.
  final Map<String, List<String>>? options;

  /// Optional static implementation code snippet shown in the code panel.
  final String? implementationCode;

  ComponentMetadata({
    required this.name,
    required this.category,
    this.platform = ComponentPlatform.shared,
    required this.builder,
    required this.defaultProps,
    this.options,
    this.implementationCode,
  });
}
