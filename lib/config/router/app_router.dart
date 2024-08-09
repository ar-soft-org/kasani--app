import 'package:flutter/widgets.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/change_password/view/view.dart';
import 'package:kasanipedido/host_home/host_home.dart';
import 'package:kasanipedido/screens/history_detail_screen.dart';
import 'package:kasanipedido/screens/history_screen.dart';
import 'package:kasanipedido/screens/home_screen_continution.dart';
import 'package:kasanipedido/screens/login_screen.dart';
import 'package:kasanipedido/screens/order_check_out_screen.dart';
import 'package:kasanipedido/screens/vendor_screen.dart';
import 'package:kasanipedido/screens/welcome_screen.dart';
import 'package:kasanipedido/screens/widgets/order_completed_screen.dart';
import 'package:kasanipedido/shopping_cart/bloc/shopping_cart_bloc.dart';

class AppRoutes {
  static const initialRoute = 'welcome';

  // FIXME: use const for route names
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (context) => const LoginScreen(),
    'welcome': (context) => const WelcomeScreen(),
    'order_booking': (context) {
      final map =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      return OrderBookingPage.init(context, map['bloc'] as ShoppingCartBloc);
    },
    'history_screen': (context) => const HistoryScreen(),
    'continue_home': (context) {
      final map =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      return ContinueHomePage(homeCubit: map['cubit'] as HomeCubit);
    },
    'host': (context) => const HostHomePage(),
    'vender': (context) => const VendorScreen(),
    'history_detail': (context) => const HistoryDetailPage(),
    'order_completed': (context) => const OrderCompletedPageView(),
    'change-password': (context) => const ChangePasswordPage(),
  };
}
