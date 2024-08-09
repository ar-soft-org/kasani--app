import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/login/login_cubit.dart';
import 'package:kasanipedido/change_password/cubit/change_password_cubit.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChangePasswordCubit(context.read<AuthenticationRepository>()),
      child: const ChangePasswordView(),
    );
  }
}

enum ChangePasswordViews { changePassword, success }

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  ChangePasswordViews currentView = ChangePasswordViews.changePassword;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        // show snackbar when state is ChangePasswordFailure
        if (state is ChangePasswordFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );

          if (state.message.contains('99 - ')) {
            // remove token
            context.read<LoginCubit>().logoutHost();
            // navigate to login page
            Navigator.of(context).pushReplacementNamed('login');
          }
        } else if (state is ChangePasswordSuccess) {
          // navigate to host page
          // show snackbar success
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(
          //     const SnackBar(
          //       content: Text('Contraseña actualizada correctamente'),
          //     ),
          //   );
          // Navigator.of(context).pushReplacementNamed('host');

          setState(() {
            currentView = ChangePasswordViews.success;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.ice,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                SizedBox(height: 40.h),
                Image.asset(
                  AppImages.logo,
                  height: 120.h,
                  width: 174.w,
                ),
                SizedBox(height: 30.h),
                Builder(
                  builder: (context) {
                    if (currentView == ChangePasswordViews.success) {
                      return Column(
                        children: [
                          SvgPicture.asset(AppImages.checkCircle),
                          SizedBox(height: 10.h),
                          SizedBox(height: 30.h),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Actualización de contraseña exitosa',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacementNamed('host');
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                minimumSize: Size.fromHeight(45.h),
                                backgroundColor: const Color(0XFF009EBF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r)),
                              ),
                              child: Text('Siguiente',
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.beVietnamPro().fontFamily,
                                      fontSize: 14.sp,
                                      color: Colors.white)),
                            ),
                          ),
                        ],
                      );
                    }
                    return const _Inputs();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Inputs extends StatefulWidget {
  const _Inputs({super.key});

  @override
  State<_Inputs> createState() => _InputsState();
}

class _InputsState extends State<_Inputs> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  bool obscureTextP1 = true;
  bool obscureTextP2 = true;

  HostModel? user;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();

    // validate userId
    final authCubit = context.read<AuthCubit>();
    if (authCubit.state is! AuthHostSuccess) {
      // navigate to login page
      Navigator.of(context).pushReplacementNamed('login');
    } else {
      user = (authCubit.state as AuthHostSuccess).host;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  process() {
    // validate form
    if (formKey.currentState?.validate() ?? false) {
      // get userId
      final userId = user?.idUsuario ?? '';

      // change password
      context.read<ChangePasswordCubit>().changePassword(
            userId,
            _passwordController.text,
          );
    } else {
      // show error (snackbar)
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Por favor, complete los campos correctamente'),
          ),
        );
    }
  }

  back() {
    context.read<LoginCubit>().logoutHost();
    // navigate to login page
    Navigator.of(context).pushReplacementNamed('login');
  }

  Widget suffixIcon(bool isObscure) {
    return Icon(
      isObscure ? Icons.visibility : Icons.visibility_off,
      color: AppColors.greyText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChangePasswordCubit>().state;
    return Column(
      children: [
        Text(
          'Cambia tu contraseña',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.lightCyan,
          ),
        ),
        SizedBox(height: 20.h),
        Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0.w),
            child: Column(
              children: [
                MyTextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: obscureTextP1,
                    label: 'Contraseña',
                    suffix: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureTextP1 = !obscureTextP1;
                          });
                        },
                        child: suffixIcon(obscureTextP1)),
                    onFieldSubmitted: (_) {
                      process();
                    }),
                SizedBox(height: 20.h),
                MyTextFormField(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  obscureText: obscureTextP2,
                  label: 'Repetir contraseña',
                  suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          obscureTextP2 = !obscureTextP2;
                        });
                      },
                      child: suffixIcon(obscureTextP2)),
                  validator: (value) {
                    // should not be empty
                    if (value == null || value.isEmpty) {
                      return 'Por favor, repita la contraseña';
                    }

                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    process();
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(height: 60.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: ElevatedButton(
            onPressed: () {
              if (state is! ChangePasswordLoading) {
                process();
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: Size.fromHeight(45.h),
              backgroundColor: const Color(0XFF009EBF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Text(
              state is ChangePasswordLoading ? 'Cargando...' : 'Siguiente',
              style: TextStyle(
                  fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                  fontSize: 14.sp,
                  color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: TextButton(
            onPressed: () {
              back();
            },
            style: TextButton.styleFrom(
              elevation: 0,
              minimumSize: Size.fromHeight(45.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Text(
              'Volver',
              style: TextStyle(
                  fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                  fontSize: 14.sp,
                  color: AppColors.lightCyan),
            ),
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    required this.label,
    required this.suffix,
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final Widget suffix;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AppColors.greyText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            width: 1.5.sp,
            color: AppColors.greyText,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        suffix: suffix,
      ),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
