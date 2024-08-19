import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kasanipedido/config/providers/bloc_providers.dart';
import 'package:kasanipedido/config/providers/repository_providers.dart';
import 'package:kasanipedido/config/providers/service_providers.dart';
import 'package:kasanipedido/config/router/app_router.dart';
import 'package:kasanipedido/data/services/order_booking/order_service.dart';
import 'package:kasanipedido/domain/repository/auth/auth_repository.dart';
import 'package:kasanipedido/domain/repository/client/client_repository.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/exports/exports.dart';
import 'package:kasanipedido/utils/navigation_keys.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.shoppingCartRepository,
    required this.dio,
    required this.orderService,
    required this.orderBookingRepository,
    required this.clientRepository,
    required this.authRepository,
  });

  final ShoppingCartRepository shoppingCartRepository;
  final OrderService orderService;
  final OrderRepository orderBookingRepository;
  final ClientRepository clientRepository;
  final AuthRepository authRepository;
  final Dio dio;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: ServiceProviders(
        dio: dio,
        orderService: orderService,
        child: RepositoryProviders(
          shoppingCartRepository: shoppingCartRepository,
          orderBookingRepository: orderBookingRepository,
          clientRepository: clientRepository,
          dio: dio,
          authRepository: authRepository,
          child: const BlocProviders(
            child: AppView(),
          ),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: mainNav,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      title: 'Kasini',
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: AppColors.lightCyan,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
