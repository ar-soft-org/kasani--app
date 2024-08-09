part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthSuccess extends AuthState {
  final HostModel host;

  AuthSuccess({required this.host});
}

final class AuthVendorSuccess extends AuthState {
  // TODO: Login Vendor
  // final VendorModel host;

  // AuthVendorSuccess({required this.host});
}
final class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

final class AuthLogout extends AuthState {}
