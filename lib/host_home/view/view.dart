import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kasanipedido/host_home/cubit/host_home_cubit.dart';
import 'package:kasanipedido/profile/profile.dart';
import 'package:kasanipedido/screens/favourite_screen.dart';
import 'package:kasanipedido/screens/history_screen.dart';
import 'package:kasanipedido/screens/home_screen.dart';
import 'package:kasanipedido/shopping_cart/shopping_cart.dart';
import 'package:kasanipedido/utils/images.dart';

class HostHomePage extends StatelessWidget {
  const HostHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HostHomeCubit(),
      child: const HostHomeView(),
    );
  }
}

class HostHomeView extends StatelessWidget {
  const HostHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HostScreen();
  }
}

class HostScreen extends StatelessWidget {
  const HostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HostHomeCubit cubit) => cubit.state.tab);
    return Scaffold(
        body: IndexedStack(
          index: selectedTab.index,
          children: const [
            EditProductPage(),
            HistoryPage(),
            ShoppingCartPage(),
            FavoriteProductsPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 70.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _HomeTabButton(
                    icon: AppImages.homeIcon,
                    label: 'Incio',
                    groupValue: selectedTab,
                    value: HostHomeTab.home,
                  ),
                  _HomeTabButton(
                    icon: AppImages.menu,
                    label: 'Historial',
                    groupValue: selectedTab,
                    value: HostHomeTab.history,
                  ),
                  _HomeTabButton(
                    icon: AppImages.cartIcon,
                    label: 'Carrito',
                    groupValue: selectedTab,
                    value: HostHomeTab.cart,
                  ),
                  _HomeTabButton(
                    icon: AppImages.fav,
                    label: 'Favoritos',
                    groupValue: selectedTab,
                    value: HostHomeTab.favorites,
                  ),
                  _HomeTabButton(
                    icon: AppImages.profileIcon,
                    label: 'Perfil',
                    groupValue: selectedTab,
                    value: HostHomeTab.profile,
                  )
                ],
              ),
            ),
          ),
        )

        // BottomNavigationBar(
        //   backgroundColor: Colors.white,
        //   items: [
        //     const BottomNavigationBarItem(
        //         icon: Icon(Icons.home_outlined),
        //         label: "",
        //         backgroundColor: Colors.white),
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(AppImages.menu),
        //       label: "",
        //       activeIcon: SvgPicture.asset(
        //         AppImages.menu,
        //         color: AppColors.lightCyan,
        //       ),
        //       backgroundColor: Colors.white,
        //     ),
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.shopping_cart_outlined),
        //       label: "",
        //       backgroundColor: Colors.white,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: SvgPicture.asset(AppImages.fav),
        //       label: "",
        //       activeIcon: SvgPicture.asset(
        //         AppImages.fav,
        //         color: AppColors.lightCyan,
        //       ),
        //       backgroundColor: Colors.white,
        //     ),
        //     const BottomNavigationBarItem(
        //       icon: Icon(Icons.person_2_outlined),
        //       label: "",
        //       backgroundColor: Colors.white,
        //     ),
        //   ],
        //   type: BottomNavigationBarType.fixed,
        //   currentIndex: selectedTab.index,
        //   selectedItemColor: AppColors.lightCyan,
        //   unselectedItemColor: AppColors.lightBlueGrey,
        //   iconSize: 28,
        //   selectedFontSize: 0,
        //   unselectedFontSize: 0,
        //   onTap: (int index) {
        //     final tab = HostHomeTab.values.firstWhere(
        //       (t) => t.index == index,
        //     );
        //     context.read<HostHomeCubit>().setTab(tab);
        //   },
        //   elevation: 5,
        // ),

        );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.groupValue,
  });

  final String icon;
  final String label;
  final HostHomeTab groupValue;
  final HostHomeTab value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<HostHomeCubit>().setTab(value),
      child: Padding(
        padding: EdgeInsets.all(0.sp),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 37.h),
              child: Center(
                child: SvgPicture.asset(icon,
                    color: groupValue != value
                        ? const Color(0xff9586a8)
                        : const Color(0xff008fad)),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 70.w),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    /// FIXME: use theme
                    color: Color(0xff898a8a),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
