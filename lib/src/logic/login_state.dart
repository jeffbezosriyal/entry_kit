import 'package:equatable/equatable.dart';

enum LoginStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  /// Helper method to clone the state with modifications
  LoginState copyWith({
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}