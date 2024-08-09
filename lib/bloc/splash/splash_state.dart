part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}
final class SplashLoading extends SplashState {}

final class SplashSuccess extends SplashState {
  final bool logedIn;

  SplashSuccess({required this.logedIn});
}

// TODO: Login Vendor
final class SplashVendorSuccess extends SplashState {
  final bool logedIn;

  SplashVendorSuccess({required this.logedIn});
}


