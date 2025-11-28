import '../config/password_config.dart';

class InputValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!_emailRegExp.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  // UPDATED: Now accepts config
  static String? validatePassword(String? value, PasswordConfig config) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < config.minLength) {
      return 'Password must be at least ${config.minLength} characters';
    }

    if (config.requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }

    if (config.requireDigit && !value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }

    if (config.requireSpecialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character';
    }

    return null;
  }
}