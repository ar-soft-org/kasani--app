import 'package:flutter/widgets.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/change_password/view/view.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/forgot_password/view/forgot_password_page.dart';
import 'package:kasanipedido/host_home/host_home.dart';
import 'package:kasanipedido/profile/view/view.dart';
import 'package:kasanipedido/screens/history_screen.dart';
import 'package:kasanipedido/screens/login_screen.dart';
import 'package:kasanipedido/screens/order_check_out_screen.dart';
import 'package:kasanipedido/vendor/bloc/vendor_bloc.dart';
import 'package:kasanipedido/vendor/view/vendor_page.dart';
import 'package:kasanipedido/screens/welcome_screen.dart';
import 'package:kasanipedido/screens/widgets/order_completed_screen.dart';
import 'package:kasanipedido/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:kasanipedido/utils/app_route_names.dart';

class AppRoutes {
  static const initialRoute = 'welcome';

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRouteNames.login: (context) => const LoginScreen(),
    'welcome': (context) => const WelcomeScreen(),
    'order_booking': (context) {
      final map =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      final vendorBloc = map['vendor_bloc'] as VendorBloc?;

      if (vendorBloc != null) {
        return OrderBookingPage.initWithVendorBloc(
          context,
          vendorBloc,
          map['bloc'] as ShoppingCartBloc,
        );
      }

      return OrderBookingPage.init(context, map['bloc'] as ShoppingCartBloc);
    },
    'history_screen': (context) => const HistoryScreen(),
    'continue_home': (context) {
      final map =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final homeCubit = map?['cubit'] as HomeCubit?;
      return HostHomePage(
        homeCubit: homeCubit,
        initialTab: HostHomeTab.continueHome,
      );
    },
    AppRouteNames.host: (context) {
      final map =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final Client? client = map?['client'];
      final VendorBloc? bloc = map?['bloc'] as VendorBloc?;
      final HomeCubit? homeCubit = map?['cubit'] as HomeCubit?;

      if (bloc != null && client != null) {
        return HostHomePage.initWithVendorBloc(bloc, client, homeCubit);
      }

      return HostHomePage(client: client, homeCubit: homeCubit);
    },
    'history_detail': (context) => HostHomePage(
          initialTab: HostHomeTab.history,
          homeCubit: ModalRoute.of(context)?.settings.arguments as HomeCubit?,
        ),
    'order_completed': (context) => const OrderCompletedPageView(),
    AppRouteNames.vendorPage: (context) => const VendorPage(),
    AppRouteNames.profilePage: (context) => const ProfilePage(),
    AppRouteNames.changePassword: (context) => const ChangePasswordPage(),
    AppRouteNames.forgotPassword: (context) => const ForgotPasswordPage(),
  };
}
