import 'package:flutter_bloc/flutter_bloc.dart';
import '../contract/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(const LoginState());

  /// Standard Email/Password Login
  Future<void> loginSubmitted(String email, String password) async {
    // 1. Update state to loading
    emit(state.copyWith(status: LoginStatus.submitting));

    try {
      // 2. Delegate to the contract
      await _authRepository.signIn(email: email, password: password);

      // 3. Success
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      // 4. Failure
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Google Sign In
  Future<void> googleLoginSubmitted() async {
    // 1. Update state to loading
    emit(state.copyWith(status: LoginStatus.submitting));

    try {
      // 2. Delegate to the contract
      await _authRepository.signInWithGoogle();

      // 3. Success
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      // 4. Failure
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> appleLoginSubmitted() async {
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.signInWithApple();
      emit(state.copyWith(status: LoginStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}