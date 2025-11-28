import 'package:flutter/material.dart';

class LoginTheme {
  final Color? backgroundColor;
  final Color? primaryColor;
  final Color? inputFillColor;
  final TextStyle? titleStyle;
  final TextStyle? inputTextStyle;
  final double inputBorderRadius;

  const LoginTheme({
    this.backgroundColor,
    this.primaryColor,
    this.inputFillColor,
    this.titleStyle,
    this.inputTextStyle,
    this.inputBorderRadius = 8.0,
  });
}
