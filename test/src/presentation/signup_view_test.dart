import 'package:entry_kit/entry_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  Future<void> pumpSignUpView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SignUpView(
          authRepository: mockRepo,
          texts: const LoginTexts(
            createAccountButton: 'SIGNUP_BTN',
            passwordMatchError: 'NO_MATCH',
          ),
        ),
      ),
    );
  }

  group('SignUpView Widget Tests', () {
    testWidgets('renders all 3 fields', (tester) async {
      await pumpSignUpView(tester);

      // Email, Password, Confirm Password
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.text('SIGNUP_BTN'), findsOneWidget);
    });

    testWidgets('shows mismatch error when passwords differ', (tester) async {
      await pumpSignUpView(tester);

      // 1. Find the fields (Order: Email, Password, Confirm)
      final fields = find.byType(TextFormField);

      // 2. Enter valid email
      await tester.enterText(fields.at(0), 'test@test.com');

      // 3. Enter Password "A"
      await tester.enterText(fields.at(1), 'Password123!');

      // 4. Enter Confirm Password "B" (Different)
      await tester.enterText(fields.at(2), 'Different123!');

      // 5. Tap Sign Up
      await tester.tap(find.text('SIGNUP_BTN'));
      await tester.pumpAndSettle();

      // 6. Expect the Mismatch Error
      expect(find.text('NO_MATCH'), findsOneWidget);
    });

    testWidgets('submits when passwords match', (tester) async {
      // Mock the success response
      when(() => mockRepo.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async {});

      await pumpSignUpView(tester);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'test@test.com');
      await tester.enterText(fields.at(1), 'Password123!');
      await tester.enterText(fields.at(2), 'Password123!'); // Match!

      await tester.tap(find.text('SIGNUP_BTN'));
      await tester.pumpAndSettle();

      // Should verify that no errors are present
      expect(find.text('NO_MATCH'), findsNothing);
      // And verify repo was called
      verify(() => mockRepo.signUp(
        email: 'test@test.com',
        password: 'Password123!',
      )).called(1);
    });
  });
}