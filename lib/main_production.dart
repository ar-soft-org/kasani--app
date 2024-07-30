import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:kasanipedido/app/app.dart';
import 'package:kasanipedido/bootstrap.dart';
import 'package:kasanipedido/data/services/order_booking/order_service.dart';
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

  final orderService = OrderService(dio: dioInstance);
  final orderBookingApi =
      OrderBookingApiImpl(orderService: orderService);

  final orderBookingRepository =
      OrderRepository(orderBookingApi: orderBookingApi);

  bootstrap(() {
    return App(
      shoppingCartRepository: shoppingCartRepository,
      dio: dioInstance,
      orderService: orderService,
      orderBookingRepository: orderBookingRepository,
    );
  });
}
