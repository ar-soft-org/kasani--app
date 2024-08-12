import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasanipedido/api/dio_interceptor.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/splash/splash_cubit.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/utils/app_route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigateToLogin() {
    Navigator.of(context).pushReplacementNamed('login');
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashCubit>(context).validateLocalSession();
    Intl.defaultLocale = 'es_PE';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          listenWhen: (previous, current) =>
              current is SplashHostSuccess || current is SplashVendorSuccess,
          listener: (context, state) {
            if (state is SplashHostSuccess && state.logedIn) {
              BlocProvider.of<AuthCubit>(context).loadUserLogged();
            } else if (state is SplashVendorSuccess && state.logedIn) {
              BlocProvider.of<AuthCubit>(context).loadVendorLogged();
            } else if (state is SplashHostSuccess && !state.logedIn) {
              Navigator.of(context).pushReplacementNamed('login');
            } else if (state is SplashVendorSuccess && !state.logedIn) {
              Navigator.of(context).pushReplacementNamed('login');
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthHostSuccess) {
              context.read<DioInterceptor>().removeInterceptors();
              context.read<DioInterceptor>().addInterceptor({
                HttpHeaders.authorizationHeader: 'Bearer ${state.host.token}'
              });
              if (state.host.requiereCambioContrasena == 'NO') {
                Navigator.of(context).pushReplacementNamed('host');
              } else {
                Navigator.of(context).pushReplacementNamed('change-password');
              }
            } else if (state is AuthVendorSuccess) {
              context.read<DioInterceptor>().removeInterceptors();
              context.read<DioInterceptor>().addInterceptor({
                HttpHeaders.authorizationHeader: 'Bearer ${state.vendor.token}'
              });
              if (state.vendor.requiereCambioContrasena == 'NO') {
                Navigator.of(context).pushReplacementNamed(AppRouteNames.vendorPage);
              } else {
                Navigator.of(context).pushReplacementNamed('change-password');
              }
            } else if (state is AuthLogout || state is AuthError) {
              Navigator.of(context).pushReplacementNamed('login');
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.transparent, // Dark background color
        appBar: null,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppImages.secondBg,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.logo,
                    height: 200.h, width: 159.w, fit: BoxFit.fitHeight),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
