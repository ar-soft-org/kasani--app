part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginHostSuccess extends LoginState {
  final HostModel host;

  LoginHostSuccess(this.host);
}

final class LoginVendorSuccess extends LoginState {
  final VendorModel vendor;

  LoginVendorSuccess(this.vendor);
}

final class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}

final class LoginLogout extends LoginState {}

class LoginPasswordChangeRequired extends LoginState {
  final String userId;
  final String token;

  LoginPasswordChangeRequired(this.userId, this.token);
}
