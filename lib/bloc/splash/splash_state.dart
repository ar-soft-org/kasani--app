part of 'splash_cubit.dart';

@immutable
sealed class SplashState { 
}

final class SplashInitial extends SplashState {}
final class SplashLoading extends SplashState {}

final class SplashHostSuccess extends SplashState {
  final bool logedIn;

  SplashHostSuccess({required this.logedIn});
}


final class SplashVendorSuccess extends SplashState {
  final bool logedIn;

  SplashVendorSuccess({required this.logedIn});
}


