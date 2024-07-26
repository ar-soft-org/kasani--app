import 'package:flutter/widgets.dart';
import 'package:kasanipedido/screens/history_detail_screen.dart';
import 'package:kasanipedido/screens/history_screen.dart';
import 'package:kasanipedido/screens/home_screen_continution.dart';
import 'package:kasanipedido/screens/host_screen.dart';
import 'package:kasanipedido/screens/login_screen.dart';
import 'package:kasanipedido/screens/order_check_out_screen.dart';
import 'package:kasanipedido/screens/vendor_screen.dart';
import 'package:kasanipedido/screens/welcome_screen.dart';

class AppRoutes {
  static const initialRoute = 'welcome';

  // FIXME: use const for route names
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (context) => const LoginScreen(),
    'welcome': (context) => const WelcomeScreen(),
    'order_booking': (context) => const OrderBookingScreen(),
    'history_screen': (context) => const HistoryScreen(),
    'continue_home': (context) => const ContinueHomeScreen(),
    'host': (context) => const HostScreen(),
    'vender': (context) => const VendorScreen(),
    'history_detail': (context) => const HistoryDetailScreen()
  };
}
