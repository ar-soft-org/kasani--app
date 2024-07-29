import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/host_home/cubit/host_home_cubit.dart';

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
          HomeScreen(),
          HistoryScreen(),
          ShoppingCartPage(),
          FavouriteScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppImages.menu),
              label: "",
              activeIcon: SvgPicture.asset(
                AppImages.menu,
                color: AppColors.lightCyan,
              ),
              backgroundColor: Colors.white,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: "",
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AppImages.fav),
              label: "",
              activeIcon: SvgPicture.asset(
                AppImages.fav,
                color: AppColors.lightCyan,
              ),
              backgroundColor: Colors.white,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: "",
              backgroundColor: Colors.white,
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedTab.index,
          selectedItemColor: AppColors.lightCyan,
          unselectedItemColor: AppColors.lightBlueGrey,
          iconSize: 28,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          onTap: (int index) {
            final tab = HostHomeTab.values.firstWhere(
              (t) => t.index == index,
            );
            context.read<HostHomeCubit>().setTab(tab);
          },
          elevation: 5,
        ),
      ),
    );
  }
}