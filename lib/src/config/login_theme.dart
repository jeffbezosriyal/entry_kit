import 'package:flutter/material.dart';

/// Defines the visual properties for the EntryKit widgets.
///
/// Use this class to match the authentication screens to your brand's
/// color palette and border styling.
class LoginTheme {
  /// The background color of the scaffold.
  final Color? backgroundColor;

  /// The primary accent color, used for buttons and loading indicators.
  final Color? primaryColor;

  /// The fill color for text input fields.
  final Color? inputFillColor;

  /// The text style for the main screen titles (e.g. "Welcome").
  final TextStyle? titleStyle;

  /// The text style for text inside input fields.
  final TextStyle? inputTextStyle;

  /// The border radius for buttons and input fields. Defaults to 8.0.
  final double inputBorderRadius;

  /// Creates a configuration for the login UI theme.
  const LoginTheme({
    this.backgroundColor,
    this.primaryColor,
    this.inputFillColor,
    this.titleStyle,
    this.inputTextStyle,
    this.inputBorderRadius = 8.0,
  });
}