import 'package:equatable/equatable.dart';

enum SignUpStatus { initial, submitting, success, failure }

class SignUpState extends Equatable {
  final SignUpStatus status;
  final String? errorMessage;

  const SignUpState({
    this.status = SignUpStatus.initial,
    this.errorMessage,
  });

  SignUpState copyWith({
    SignUpStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
