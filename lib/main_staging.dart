import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:kasanipedido/app/app.dart';
import 'package:kasanipedido/bootstrap.dart';
import 'package:kasanipedido/data/services/order_booking/order_booking_service.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api_impl.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:products_api_impl/products_api_impl.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final productsApi = ProductsApiImpl();

  final shoppingCartRepository =
      ShoppingCartRepository(productsApi: productsApi);

  final dioInstance = Dio();

  final orderBookingService = OrderBookingService(dio: dioInstance);
  final orderBookingApi =
      OrderBookingApiImpl(orderBookingService: orderBookingService);

  final orderBookingRepository =
      OrderBookingRepository(orderBookingApi: orderBookingApi);

  bootstrap(() {
    return App(
      shoppingCartRepository: shoppingCartRepository,
      dio: dioInstance,
      orderBookingService: orderBookingService,
      orderBookingRepository: orderBookingRepository,
    );
  });
}
