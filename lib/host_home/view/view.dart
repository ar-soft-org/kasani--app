import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/edit_product/bloc/edit_product_bloc.dart';
import 'package:kasanipedido/host_home/cubit/host_home_cubit.dart';
import 'package:kasanipedido/profile/profile.dart';
import 'package:kasanipedido/screens/favourite_screen.dart';
import 'package:kasanipedido/screens/history_screen.dart';
import 'package:kasanipedido/screens/home_screen.dart';
import 'package:kasanipedido/shopping_cart/shopping_cart.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/vendor/bloc/vendor_bloc.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class HostHomePage extends StatelessWidget {
  const HostHomePage({super.key, this.client});

  static Widget initWithVendorBloc(
    VendorBloc bloc,
    Client client,
  ) {
    return HostHomePage(client: client);
  }

  final Client? client;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HostHomeCubit(),
        ),
        BlocProvider(
          create: (context) => EditProductBloc(
              shoppingCartRepository:
                  RepositoryProvider.of<ShoppingCartRepository>(context))
            ..add(const EditProductProductsDataRequested()),
        ),
      ],
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

    final countProducts =
        context.select((EditProductBloc bloc) => bloc.state.countProducts);

    final VendorState? vendorState =
        context.select((VendorBloc? bloc) => bloc?.state);
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
        floatingActionButton: vendorState?.status == VendorStatus.loaded
            ? FloatingActionButton(
                onPressed: () {
                  // Navigator.of(context).pushNamed(AppRouteNames.vendorPage);
                  Navigator.of(context).pop();
                },
                backgroundColor: AppColors.lightCyan,
                child: const Icon(Icons.person_outline),
              )
            : const SizedBox.shrink(),
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
                    badgeValue:
                        countProducts != null ? countProducts.toString() : '',
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
    this.badgeValue = '',
  });

  final String icon;
  final String label;
  final HostHomeTab groupValue;
  final HostHomeTab value;
  final String badgeValue;

  @override
  Widget build(BuildContext context) {
    final svgIcon = SvgPicture.asset(icon,
        color: groupValue != value
            ? const Color(0xff9586a8)
            : const Color(0xff008fad));

    return InkWell(
      onTap: () => context.read<HostHomeCubit>().setTab(value),
      child: Padding(
        padding: EdgeInsets.all(0.sp),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 37.h),
              child: Center(
                child: badgeValue.isNotEmpty
                    ? Badge(
                        backgroundColor: AppColors.lightCyan,
                        label: Text(badgeValue),
                        child: svgIcon,
                      )
                    : svgIcon,
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
