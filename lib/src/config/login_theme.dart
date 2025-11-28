import 'package:flutter/material.dart';

/// Defines the visual styling for the EntryKit screens.
///
/// Use this to match the login screens to your app's brand colors and shapes.
class LoginTheme {
  /// The background color of the entire screen.
  final Color? backgroundColor;

  /// The primary accent color, used for buttons and loading indicators.
  final Color? primaryColor;

  /// The background color of the text input fields.
  final Color? inputFillColor;

  /// The text style for the screen title (e.g., "Welcome Back").
  final TextStyle? titleStyle;

  /// The text style for input fields.
  final TextStyle? inputTextStyle;

  /// The border radius for input fields and buttons. Defaults to 8.0.
  final double inputBorderRadius;

  /// Creates a custom theme configuration.
  const LoginTheme({
    this.backgroundColor,
    this.primaryColor,
    this.inputFillColor,
    this.titleStyle,
    this.inputTextStyle,
    this.inputBorderRadius = 8.0,
  });
}