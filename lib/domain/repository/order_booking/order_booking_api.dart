import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_response.dart';

abstract class OrderBookingApi {
  /// create [Order]
  ///
  ///
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request);
}

class CreateOrderException implements Exception {
  final String message;

  CreateOrderException({required this.message});
}
