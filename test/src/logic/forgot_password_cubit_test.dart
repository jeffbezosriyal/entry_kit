import 'package:bloc_test/bloc_test.dart';
import 'package:entry_kit/entry_kit.dart';
import 'package:entry_kit/src/logic/forgot_password_cubit.dart';
import 'package:entry_kit/src/logic/forgot_password_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ForgotPasswordCubit forgotPasswordCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    forgotPasswordCubit = ForgotPasswordCubit(mockAuthRepository);
  });

  group('ForgotPasswordCubit', () {
    test('initial state is ForgotPasswordState()', () {
      expect(forgotPasswordCubit.state, const ForgotPasswordState());
    });

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits [submitting, success] when submitResetRequest succeeds',
      build: () {
        when(() => mockAuthRepository.resetPassword(email: any(named: 'email')))
            .thenAnswer((_) async {});
        return forgotPasswordCubit;
      },
      act: (cubit) => cubit.submitResetRequest('reset@test.com'),
      expect: () => [
        const ForgotPasswordState(status: ForgotPasswordStatus.submitting),
        const ForgotPasswordState(status: ForgotPasswordStatus.success),
      ],
    );

    blocTest<ForgotPasswordCubit, ForgotPasswordState>(
      'emits [submitting, failure] when submitResetRequest fails',
      build: () {
        when(() => mockAuthRepository.resetPassword(email: any(named: 'email')))
            .thenThrow(Exception('User not found'));
        return forgotPasswordCubit;
      },
      act: (cubit) => cubit.submitResetRequest('unknown@test.com'),
      expect: () => [
        const ForgotPasswordState(status: ForgotPasswordStatus.submitting),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'Exception: User not found',
        ),
      ],
    );
  });
}
