import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/edit_product/bloc/edit_product_bloc.dart';
import 'package:kasanipedido/host_home/cubit/host_home_cubit.dart';
import 'package:kasanipedido/profile/profile.dart';
import 'package:kasanipedido/screens/favourite_screen.dart';
import 'package:kasanipedido/screens/history_detail_screen.dart';
import 'package:kasanipedido/screens/history_screen.dart';
import 'package:kasanipedido/screens/home_screen.dart';
import 'package:kasanipedido/screens/home_screen_continution.dart';
import 'package:kasanipedido/shopping_cart/shopping_cart.dart';
import 'package:kasanipedido/utils/colors.dart';
import 'package:kasanipedido/utils/images.dart';
import 'package:kasanipedido/vendor/bloc/vendor_bloc.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class HostHomePage extends StatelessWidget {
  const HostHomePage({
    super.key,
    this.client,
    this.homeCubit,
    this.initialTab = HostHomeTab.home,
  });

  final Client? client;
  final HomeCubit? homeCubit;
  final HostHomeTab initialTab;

  static Widget initWithVendorBloc(
      VendorBloc bloc, Client client, HomeCubit? homeCubit,
      {HostHomeTab initialTab = HostHomeTab.home}) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: bloc),
        if (homeCubit != null) BlocProvider.value(value: homeCubit),
      ],
      child: HostHomePage(
        client: client,
        homeCubit: homeCubit,
        initialTab: initialTab,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HostHomeCubit()..setTab(initialTab)),
        if (homeCubit != null) BlocProvider.value(value: homeCubit!),
        BlocProvider(
          create: (context) => EditProductBloc(
            shoppingCartRepository: context.read<ShoppingCartRepository>(),
          )..add(const EditProductProductsDataRequested()),
        ),
      ],
      child: HostHomeView(homeCubit: homeCubit),
    );
  }
}

class HostHomeView extends StatelessWidget {
  const HostHomeView({super.key, this.homeCubit});

  final HomeCubit? homeCubit;

  @override
  Widget build(BuildContext context) {
    return HostScreen(homeCubit: homeCubit);
  }
}

class HostScreen extends StatelessWidget {
  const HostScreen({super.key, this.homeCubit});
  final HomeCubit? homeCubit;

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HostHomeCubit cubit) => cubit.state.tab);
    final isBottomBarVisible = context.select((HostHomeCubit cubit) => cubit.state.isBottomBarVisible);
    final countProducts = context.select((EditProductBloc bloc) => bloc.state.countProducts);
    final VendorState? vendorState = context.select((VendorBloc? bloc) => bloc?.state);

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: [
          const HomeScreen(),
          const HistoryPage(),
          const ShoppingCartPage(),
          const FavoriteProductsPage(),
          const ProfilePage(),
          ContinueHomePage(homeCubit: homeCubit),
          HistoryDetailPage(), // Añadir HistoryDetailPage aquí
        ],
      ),
      floatingActionButton: vendorState?.status == VendorStatus.loaded
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: AppColors.lightCyan,
              child: const Icon(Icons.person_outline),
            )
          : const SizedBox.shrink(),
      bottomNavigationBar: isBottomBarVisible
          ? BottomAppBar(
              color: AppColors.appBar,
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
                        label: 'Inicio',
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
                        badgeValue: countProducts?.toString() ?? '',
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
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
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
    final svgIcon = SvgPicture.asset(
      icon,
      color: groupValue != value ? Colors.white : const Color(0xff0FB9DD),
    );

    return InkWell(
      onTap: () => context.read<HostHomeCubit>().setTab(value),
      child: Padding(
        padding: EdgeInsets.all(0.sp),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: 0.h, top: 5),
              child: ConstrainedBox(
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
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 70.w),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xffb6bfd4),
                    fontSize: 10.sp, 
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
