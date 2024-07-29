import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/login/login_cubit.dart';
import 'package:kasanipedido/exports/exports.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();

  TextEditingController pw = TextEditingController();

  bool isObscure = true;

  bool? isVendor = false;

  loadDevData() {
    email.text = "info@restaurantsanceferino.com";
    pw.text = "15122077273";
  }

  @override
  void initState() {
    super.initState();
    log("LoginScreen initState");
    // if (kDebugMode) {
      loadDevData();
    // }
  }

  @override
  void dispose() {
    email.dispose();
    pw.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = BlocProvider.of<LoginCubit>(context).state;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
    ));
    log("LoginScreen build");
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listenWhen: (previous, current) {
            return current is LoginSuccess || current is LoginFailure;
          },
          listener: (context, state) {
            if (state is LoginSuccess) {
              BlocProvider.of<AuthCubit>(context).loadUserLogged();
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              log('AuthSuccess');
              Navigator.of(context).pushReplacementNamed('host');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: null,
        bottomNavigationBar: null,
        body: Stack(
          children: [
            SizedBox(
              height: 400.h,
              width: 390.w,
              child: Image.asset(
                AppImages.loginbg,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 70.h,
              left: 115.w,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  AppImages.logo,
                  height: 120.h,
                  width: 174.w,
                ),
              ),
            ),
            Container(
              color: AppColors.lightCyan.withOpacity(0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
                    child: Container(
                      width: 346.w,
                      height: 391.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40.w),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 40.h),
                      child: Column(
                        children: [
                          textField(
                              email,
                              46,
                              296,
                              "Email",
                              "email",
                              10,
                              AppColors.tfBg,
                              false,
                              false,
                              false,
                              false,
                              () {},
                              context),
                          verticalSpacer(10),
                          textField(
                              pw,
                              46,
                              296,
                              "Password",
                              "password",
                              10,
                              AppColors.tfBg,
                              false,
                              false,
                              false,
                              isObscure, () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          }, context),
                          verticalSpacer(10),
                          // checkbox is vendor
                          Row(
                            children: [
                              Checkbox(
                                value: isVendor,
                                onChanged: (value) {
                                  setState(() {
                                    isVendor = value;
                                  });
                                },
                              ),
                              customText(
                                  "Ingresar como vendedor",
                                  FontWeight.w400,
                                  16,
                                  GoogleFonts.inter.toString(),
                                  AppColors.lightCyan),
                            ],
                          ),
                          verticalSpacer(10),
                          const Spacer(),
                          customButton(
                              context,
                              false,
                              state is LoginLoading
                                  ? "Cargando..."
                                  : "INGRESAR",
                              16, () {
                            if (email.text == "Vendedor") {
                              Navigator.of(context).pushNamed('vendor');
                              // Get.to(const VendorScreen());
                            } else {
                              if (isVendor == true) {
                                BlocProvider.of<LoginCubit>(context)
                                    .loginVendor(email.text, pw.text);
                              } else {
                                BlocProvider.of<LoginCubit>(context)
                                    .loginHost(email.text, pw.text);
                              }
                            }
                          }, 308, 58, Colors.transparent, AppColors.lightCyan,
                              100,
                              showShadow: true),
                          verticalSpacer(20),
                          customText(
                              "¿Perdiste tu contraseña?",
                              FontWeight.w600,
                              16,
                              GoogleFonts.inter.toString(),
                              AppColors.lightCyan),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
