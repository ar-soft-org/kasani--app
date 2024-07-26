import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/bloc/login/login_cubit.dart';
import 'package:kasanipedido/bloc/splash/splash_cubit.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';

class BlocProviders extends StatelessWidget {
  const BlocProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(
              repository:
                  RepositoryProvider.of<AuthenticationRepository>(context)),
        ),
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(create: (context) => HomeCubit()),
      ],
      child: child,
    );
  }
}
