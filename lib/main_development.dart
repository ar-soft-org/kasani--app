import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:kasanipedido/app/app.dart';
import 'package:kasanipedido/bootstrap.dart';
import 'package:kasanipedido/data/services/auth/auth_service.dart';
import 'package:kasanipedido/data/services/client/client_service.dart';
import 'package:kasanipedido/data/services/order_booking/order_service.dart';
import 'package:kasanipedido/domain/repository/auth/auth_repository.dart';
import 'package:kasanipedido/domain/repository/client/client_api_impl.dart';
import 'package:kasanipedido/domain/repository/client/client_repository.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api_impl.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/firebase_options.dart';
import 'package:kasanipedido/translation/supported_locales.dart';
import 'package:products_api_impl/products_api_impl.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("0b6de201-cba8-42b8-906c-9e2c3bf40a39");
  OneSignal.Notifications.requestPermission(true);

  final dioInstance = Dio();

  final productService = ProductService(dio: dioInstance);
  final productsApi = ProductsApiImpl(productService: productService);

  final clientService = ClientService(dio: dioInstance);
  final clientApi = ClientApiImpl(service: clientService);

  final shoppingCartRepository =
      ShoppingCartRepository(productsApi: productsApi);

  final clientRepository = ClientRepository(clientApi: clientApi);

  final orderService = OrderService(dio: dioInstance);
  final orderBookingApi = OrderBookingApiImpl(orderService: orderService);

  final authService = AuthService(dio: dioInstance);
  final authRepository = AuthRepository(authService);

  final orderBookingRepository =
      OrderRepository(orderBookingApi: orderBookingApi);

  bootstrap(() {
    return EasyLocalization(
      supportedLocales: SupportedLocales.locales,
      path: 'assets/translations',
      fallbackLocale: const Locale('es', 'PE'),
      child: App(
        shoppingCartRepository: shoppingCartRepository,
        dio: dioInstance,
        orderService: orderService,
        orderBookingRepository: orderBookingRepository,
        clientRepository: clientRepository,
        authRepository: authRepository,
      ),
    );
  });
}
