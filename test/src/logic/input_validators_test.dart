import 'package:flutter_test/flutter_test.dart';
import 'package:entry_kit/src/config/password_config.dart';
import 'package:entry_kit/src/logic/input_validators.dart';

void main() {
  group('InputValidators', () {
    // --- EMAIL TESTS ---
    group('validateEmail', () {
      test('returns error when null', () {
        expect(InputValidators.validateEmail(null), 'Email is required');
      });

      test('returns error when empty', () {
        expect(InputValidators.validateEmail(''), 'Email is required');
      });

      test('returns error when format is invalid', () {
        expect(InputValidators.validateEmail('not-an-email'),
            'Enter a valid email address');
        expect(InputValidators.validateEmail('missing@dot'),
            'Enter a valid email address');
      });

      test('returns null when valid', () {
        expect(InputValidators.validateEmail('test@example.com'), isNull);
      });
    });

    // --- PASSWORD TESTS ---
    group('validatePassword', () {
      test('returns error when null or empty', () {
        const config = PasswordConfig();
        expect(InputValidators.validatePassword(null, config),
            'Password is required');
        expect(InputValidators.validatePassword('', config),
            'Password is required');
      });

      test('validates minimum length', () {
        const config = PasswordConfig(minLength: 5);
        // Too short
        expect(InputValidators.validatePassword('1234', config),
            'Password must be at least 5 characters');
        // Correct length
        expect(InputValidators.validatePassword('12345', config), isNull);
      });

      test('validates uppercase requirement', () {
        // NOTE: Default minLength is 6, so inputs must be 6+ chars
        const config = PasswordConfig(requireUppercase: true);

        expect(InputValidators.validatePassword('lower_case', config),
            'Password must contain an uppercase letter');
        // "UpperPass" is >6 chars and has uppercase -> Should Pass
        expect(InputValidators.validatePassword('UpperPass', config), isNull);
      });

      test('validates digit requirement', () {
        const config = PasswordConfig(requireDigit: true);

        expect(InputValidators.validatePassword('no-digit', config),
            'Password must contain a number');
        expect(InputValidators.validatePassword('digit123', config), isNull);
      });

      test('validates special char requirement', () {
        const config = PasswordConfig(requireSpecialChar: true);

        expect(InputValidators.validatePassword('plainText', config),
            'Password must contain a special character');
        expect(InputValidators.validatePassword('special!', config), isNull);
      });

      test('passes when all strict rules are met', () {
        const config = PasswordConfig(
          minLength: 8,
          requireUppercase: true,
          requireDigit: true,
          requireSpecialChar: true,
        );

        expect(InputValidators.validatePassword('StrongP@ss1', config), isNull);
      });
    });
  });
}
