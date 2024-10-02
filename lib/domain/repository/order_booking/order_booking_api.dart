import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_response.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_request.dart';

abstract class OrderBookingApi {
  /// create [Order]
  ///
  /// if has error, thrown [CreateOrderException]
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request);

  /// get [Order]s history
  ///
  ///
  Future<List<OrderHistory>> getOrdersHistory(OrderHistoryRequest data);

  Future<OrderHistoryDetail> getOrderHistoryDetail(
      OrderHistoryDetailRequest data);
}

class CreateOrderException implements Exception {
  final String message;

  CreateOrderException({required this.message});
}

class OrderApiException implements Exception {
  final String message;

  OrderApiException({required this.message});
}
