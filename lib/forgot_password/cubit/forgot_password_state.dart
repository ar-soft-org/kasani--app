part of 'forgot_password_cubit.dart';

enum ForgotPasswordStatus { initial, loading, success, error }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
  });

  final ForgotPasswordStatus status;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        status,
      ];
}
