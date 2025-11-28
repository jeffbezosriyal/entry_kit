import 'package:bloc_test/bloc_test.dart';
import 'package:entry_kit/entry_kit.dart';
import 'package:entry_kit/src/logic/login_cubit.dart';
import 'package:entry_kit/src/logic/login_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Create a Mock Repository
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late LoginCubit loginCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginCubit = LoginCubit(mockAuthRepository);
  });

  group('LoginCubit', () {
    test('initial state is LoginState()', () {
      expect(loginCubit.state, const LoginState());
    });

    // --- EMAIL LOGIN TESTS ---
    blocTest<LoginCubit, LoginState>(
      'emits [submitting, success] when loginSubmitted succeeds',
      build: () {
        // Arrange: Mock the repo to return success (void)
        when(() => mockAuthRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {});
        return loginCubit;
      },
      act: (cubit) => cubit.loginSubmitted('test@test.com', 'password'),
      expect: () => [
        const LoginState(status: LoginStatus.submitting),
        const LoginState(status: LoginStatus.success),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [submitting, failure] when loginSubmitted fails',
      build: () {
        // Arrange: Mock the repo to throw an error
        when(() => mockAuthRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(Exception('Invalid credentials'));
        return loginCubit;
      },
      act: (cubit) => cubit.loginSubmitted('test@test.com', 'wrong'),
      expect: () => [
        const LoginState(status: LoginStatus.submitting),
        const LoginState(
            status: LoginStatus.failure,
            errorMessage: 'Exception: Invalid credentials'
        ),
      ],
    );

    // --- GOOGLE LOGIN TESTS ---
    blocTest<LoginCubit, LoginState>(
      'emits [submitting, success] when googleLoginSubmitted succeeds',
      build: () {
        when(() => mockAuthRepository.signInWithGoogle())
            .thenAnswer((_) async => null); // Return null or Mock Account
        return loginCubit;
      },
      act: (cubit) => cubit.googleLoginSubmitted(),
      expect: () => [
        const LoginState(status: LoginStatus.submitting),
        const LoginState(status: LoginStatus.success),
      ],
    );

    // --- APPLE LOGIN TESTS ---
    blocTest<LoginCubit, LoginState>(
      'emits [submitting, success] when appleLoginSubmitted succeeds',
      build: () {
        when(() => mockAuthRepository.signInWithApple())
            .thenAnswer((_) async => null);
        return loginCubit;
      },
      act: (cubit) => cubit.appleLoginSubmitted(),
      expect: () => [
        const LoginState(status: LoginStatus.submitting),
        const LoginState(status: LoginStatus.success),
      ],
    );
  });
}