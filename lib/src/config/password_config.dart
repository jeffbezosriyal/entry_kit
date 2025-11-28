class PasswordConfig {
  final int minLength;
  final bool requireUppercase;
  final bool requireDigit;
  final bool requireSpecialChar;

  const PasswordConfig({
    this.minLength = 6, // Default to 6
    this.requireUppercase = false,
    this.requireDigit = false,
    this.requireSpecialChar = false,
  });
}
