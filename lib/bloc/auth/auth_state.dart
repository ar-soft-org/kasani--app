part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class AuthHostSuccess extends AuthState {
  final HostModel host;

  AuthHostSuccess({required this.host});
}

final class AuthVendorSuccess extends AuthState {
  final VendorModel vendor;

  AuthVendorSuccess({required this.vendor});
}
final class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

final class AuthLogout extends AuthState {}
