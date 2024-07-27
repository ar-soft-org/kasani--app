import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/splash/splash_cubit.dart';
import 'package:kasanipedido/exports/exports.dart';

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
    // Future.delayed(const Duration(seconds: 3), navigateToLogin);
    BlocProvider.of<SplashCubit>(context).validateLocalSession();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SplashCubit, SplashState>(
          listenWhen: (previous, current) => current is SplashSuccess,
          listener: (context, state) {
            if (state is SplashSuccess && state.logedIn) {
              BlocProvider.of<AuthCubit>(context).loadUserLogged();
            } else if (state is SplashSuccess && !state.logedIn) {
              Navigator.of(context).pushReplacementNamed('login');
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacementNamed('host');
            } else if (state is AuthLogout || state is AuthError) {
              // FIXME: Considerar delete de host
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
