import 'package:flutter_bloc/flutter_bloc.dart';
import '../contract/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit(this._authRepository)
      : super(const ForgotPasswordState());

  Future<void> submitResetRequest(String email) async {
    emit(state.copyWith(status: ForgotPasswordStatus.submitting));

    try {
      await _authRepository.resetPassword(email: email);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
