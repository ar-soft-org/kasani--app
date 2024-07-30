import 'package:flutter_bloc/flutter_bloc.dart';
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
                profileCategoryTile('Historial de pedidos', () {
                  Navigator.of(context).pushNamed('history_screen');
                  // Get.to(const HistoryScreen());
                }),
                verticalSpacer(20),
                profileCategoryTile(
                  state is LoginLoading ? 'Cerrando Sesión' : 'Cerrar sesión',
                  () {
                    context.read<LoginCubit>().logoutHost();
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

Widget profileCategoryTile(String title, void Function() onTap) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w, right: 75.w, top: 30.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(title, FontWeight.w400, 14,
            GoogleFonts.beVietnamPro().fontFamily.toString(), AppColors.black),
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
