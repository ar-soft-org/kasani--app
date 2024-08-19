import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kasanipedido/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:kasanipedido/utils/app_route_names.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        authRepository: RepositoryProvider.of(context),
      ),
      child: const ForgotPasswordView(),
    );
  }
}

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ForgotPasswordCubit>().state;

    return Scaffold(
      backgroundColor: AppColors.ice,
      body: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Correo enviado con éxito'),
                ),
              );
          } else if (state.status == ForgotPasswordStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Error al enviar el correo'),
                ),
              );
          }
        },
        child: SafeArea(
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
                    if (state.status == ForgotPasswordStatus.success) {
                      return const _SuccessMessage();
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

class _SuccessMessage extends StatelessWidget {
  const _SuccessMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(AppImages.checkCircle),
        SizedBox(height: 10.h),
        SizedBox(height: 30.h),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Un correo electrónico ha sido enviado a tu dirección de correo electrónico con instrucciones para restablecer tu contraseña.',
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
              Navigator.of(context).pushReplacementNamed(AppRouteNames.login);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: Size.fromHeight(45.h),
              backgroundColor: const Color(0XFF009EBF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Text(
              'Volver al inicio de sesión',
              style: TextStyle(
                fontFamily: GoogleFonts.beVietnamPro().fontFamily,
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Inputs extends StatefulWidget {
  const _Inputs({super.key});

  @override
  State<_Inputs> createState() => _InputsState();
}

class _InputsState extends State<_Inputs> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget suffixIcon(bool isObscure) {
    return Icon(
      isObscure ? Icons.visibility : Icons.visibility_off,
      color: AppColors.greyText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Recuperar contraseña',
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
                  controller: _controller,
                  focusNode: _focusNode,
                  label: 'Email',
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Campo requerido';
                    }
                    // validate email
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(p0)) {
                      return 'Correo electrónico inválido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
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
              if (formKey.currentState!.validate()) {
                context
                    .read<ForgotPasswordCubit>()
                    .submitEmail(_controller.text.trim());
              }

              // show error message
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Error al enviar el correo'),
                  ),
                );
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: Size.fromHeight(45.h),
              backgroundColor: const Color(0XFF009EBF),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            child: Text(
              'Siguiente',
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
              Navigator.of(context).pop();
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
    this.suffix,
    required this.controller,
    required this.focusNode,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
  });

  final String label;
  final Widget? suffix;
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
