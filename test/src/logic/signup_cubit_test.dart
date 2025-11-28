import 'package:bloc_test/bloc_test.dart';
import 'package:entry_kit/entry_kit.dart';
import 'package:entry_kit/src/logic/signup_cubit.dart';
import 'package:entry_kit/src/logic/signup_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUpCubit signUpCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUpCubit = SignUpCubit(mockAuthRepository);
  });

  group('SignUpCubit', () {
    test('initial state is SignUpState()', () {
      expect(signUpCubit.state, const SignUpState());
    });

    // --- EMAIL SIGN UP TESTS ---
    blocTest<SignUpCubit, SignUpState>(
      'emits [submitting, success] when signupSubmitted succeeds',
      build: () {
        when(() => mockAuthRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {});
        return signUpCubit;
      },
      act: (cubit) => cubit.signupSubmitted('new@test.com', 'password'),
      expect: () => [
        const SignUpState(status: SignUpStatus.submitting),
        const SignUpState(status: SignUpStatus.success),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [submitting, failure] when signupSubmitted fails',
      build: () {
        when(() => mockAuthRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception('Email already in use'));
        return signUpCubit;
      },
      act: (cubit) => cubit.signupSubmitted('taken@test.com', 'password'),
      expect: () => [
        const SignUpState(status: SignUpStatus.submitting),
        const SignUpState(
          status: SignUpStatus.failure,
          errorMessage: 'Exception: Email already in use',
        ),
      ],
    );

    // --- GOOGLE SIGN UP TESTS ---
    blocTest<SignUpCubit, SignUpState>(
      'emits [submitting, success] when googleSignupSubmitted succeeds',
      build: () {
        when(() => mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => null);
        return signUpCubit;
      },
      act: (cubit) => cubit.googleSignupSubmitted(),
      expect: () => [
        const SignUpState(status: SignUpStatus.submitting),
        const SignUpState(status: SignUpStatus.success),
      ],
    );

    // --- APPLE SIGN UP TESTS ---
    blocTest<SignUpCubit, SignUpState>(
      'emits [submitting, success] when appleSignupSubmitted succeeds',
      build: () {
        when(() => mockAuthRepository.signInWithApple())
            .thenAnswer((_) async => null);
        return signUpCubit;
      },
      act: (cubit) => cubit.appleSignupSubmitted(),
      expect: () => [
        const SignUpState(status: SignUpStatus.submitting),
        const SignUpState(status: SignUpStatus.success),
      ],
    );
  });
}