import 'package:entry_kit/entry_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Reuse the mock
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  // Helper to pump the widget wrapped in MaterialApp
  Future<void> pumpLoginView(WidgetTester tester, {
    bool google = false,
    bool apple = false,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginView(
          authRepository: mockRepo,
          enableGoogleAuth: google,
          enableAppleAuth: apple,
          texts: const LoginTexts(
            loginButton: 'LOGIN_BTN',
            googleButton: 'GOOGLE_BTN',
            appleButton: 'APPLE_BTN',
          ),
        ),
      ),
    );
  }

  group('LoginView Widget Tests', () {
    testWidgets('renders email and password fields', (tester) async {
      await pumpLoginView(tester);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('LOGIN_BTN'), findsOneWidget);
    });

    testWidgets('hides social buttons by default', (tester) async {
      await pumpLoginView(tester, google: false, apple: false);

      expect(find.text('GOOGLE_BTN'), findsNothing);
      expect(find.text('APPLE_BTN'), findsNothing);
    });

    testWidgets('shows Google button when enabled', (tester) async {
      await pumpLoginView(tester, google: true, apple: false);

      expect(find.text('GOOGLE_BTN'), findsOneWidget);
      expect(find.text('APPLE_BTN'), findsNothing);
    });

    testWidgets('shows Apple button when enabled', (tester) async {
      await pumpLoginView(tester, google: false, apple: true);

      expect(find.text('GOOGLE_BTN'), findsNothing);
      expect(find.text('APPLE_BTN'), findsOneWidget);
    });

    testWidgets('shows validation errors on empty submit', (tester) async {
      await pumpLoginView(tester);

      // 1. Tap Login Button with empty fields
      await tester.tap(find.text('LOGIN_BTN'));
      await tester.pumpAndSettle(); // Wait for validation to paint

      // 2. Verify Email Error
      // Note: LoginView logic forces this specific string for ANY email error
      expect(find.text('Enter a valid email address'), findsOneWidget);

      // 3. Verify Password Error
      // Since it's empty, it returns "Required", not "Length"
      expect(find.text('Password is required'), findsOneWidget);
    });

    // OPTIONAL: Add a new test for Short Passwords specifically
    testWidgets('shows length error on short password', (tester) async {
      await pumpLoginView(tester);

      // 1. Enter a short password
      await tester.enterText(find.byType(TextFormField).last, '123');

      // 2. Tap Login
      await tester.tap(find.text('LOGIN_BTN'));
      await tester.pumpAndSettle();

      // 3. Now we expect the length error
      expect(find.text('Password must be at least 6 characters'), findsOneWidget);
    });
  });
}