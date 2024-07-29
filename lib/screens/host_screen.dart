
import 'package:kasanipedido/exports/exports.dart';

import 'order_check_out_screen.dart';


class HostScreen extends StatefulWidget {
  const HostScreen({super.key});


  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const HistoryScreen(),
    const ShoppingCartPage(),
    const FavouriteScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
            items:  <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "",
                  backgroundColor: Colors.white
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppImages.menu),
                label: "",
                activeIcon: SvgPicture.asset(AppImages.menu,color: AppColors.lightCyan,),
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
                activeIcon: SvgPicture.asset(AppImages.fav,color: AppColors.lightCyan,),
                backgroundColor: Colors.white,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined),
                label: "",
                backgroundColor: Colors.white,
              ),

            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.lightCyan,
            unselectedItemColor: AppColors.lightBlueGrey,
            iconSize: 28,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            onTap: _onItemTapped,
            elevation: 5
        ),
      ),
    );
  }
}