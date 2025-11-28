import 'package:flutter_bloc/flutter_bloc.dart';
import '../contract/auth_repository.dart';
import 'signup_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(const SignUpState());

  Future<void> signupSubmitted(String email, String password) async {
    emit(state.copyWith(status: SignUpStatus.submitting));

    try {
      await _authRepository.signUp(email: email, password: password);
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  // NEW METHOD
  Future<void> googleSignupSubmitted() async {
    emit(state.copyWith(status: SignUpStatus.submitting));

    try {
      // We reuse signInWithGoogle because OAuth handles account creation automatically
      await _authRepository.signInWithGoogle();
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> appleSignupSubmitted() async {
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      await _authRepository.signInWithApple();
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}