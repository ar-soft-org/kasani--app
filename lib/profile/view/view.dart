import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/api/dio_interceptor.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/login/login_cubit.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/profile/cubit/profile_cubit.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        shoppingCartRepository:
            RepositoryProvider.of<ShoppingCartRepository>(context),
      ),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.select((AuthCubit cubit) => cubit.state);

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) {
        return current is LoginLogout;
      },
      listener: (context, state) {
        context.read<ProfileCubit>().clearProductsData();
        Navigator.of(context).pushReplacementNamed('login');
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.ice,
          appBar: customAppBar(context, 'INFORMACIÓN', false),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalSpacer(40),
                Container(
                  width: 320.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: AssetImage(
                            AppImages.profile,
                          ),
                          fit: BoxFit.fill)),
                ),
                verticalSpacer(20),
                profileCategoryTile('Mi perfil', () {}),

                if (authState is AuthVendorSuccess) ...[
                  Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        top: 30.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${authState.vendor.nombres} ${authState.vendor.apellidos}'),
                          Text(authState.vendor.correo),
                          SizedBox(height: 20.h),
                          Divider(height: 2.h, thickness: 2.h),
                          SizedBox(height: 20.h),
                        ],
                      ))
                ],
                if (authState is AuthHostSuccess) ...[
                  Padding(
                      padding: EdgeInsets.only(
                        left: 10.w,
                        right: 10.w,
                        top: 30.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${authState.host.nombres} ${authState.host.apellidos}'),
                          Text(authState.host.correo),
                          SizedBox(height: 20.h),
                          Divider(height: 2.h, thickness: 2.h),
                          SizedBox(height: 20.h),
                          ...authState.host.locales.map((e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.nombreLocal),
                                Text(e.direccionLocal),
                                SizedBox(height: 10.h),
                              ],
                            );
                          }).toList()
                        ],
                      ))
                ],
                // profileCategoryTile('Historial de pedidos', () {
                //   Navigator.of(context).pushNamed('history_screen');
                // }),
                verticalSpacer(20),
                profileCategoryTile(
                  state is LoginLoading ? 'Cerrando Sesión' : 'Cerrar sesión',
                  showNavIcon: true,
                  // TODO: Login Vendor
                  // TODO: Si es vendedor usar logoutVendor
                  () {
                    context.read<DioInterceptor>().removeInterceptors();
                    if (authState is AuthVendorSuccess) {
                      context.read<LoginCubit>().logoutVendor();
                    } else if (authState is AuthHostSuccess) {
                      context.read<LoginCubit>().logoutHost();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget profileCategoryTile(String title, void Function() onTap,
    {bool showNavIcon = false}) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 75.w, top: 30.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(title, FontWeight.w400, 14,
            GoogleFonts.beVietnamPro().fontFamily.toString(), AppColors.black),
        if (showNavIcon)
          GestureDetector(
              onTap: onTap,
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.black,
                size: 18,
              )),
      ],
    ),
  );
}
