import 'package:kasanipedido/data/services/order_booking/order_service.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_response.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';

class OrderBookingApiImpl extends OrderBookingApi {
  final OrderService _service;

  OrderBookingApiImpl({required OrderService orderService})
      : _service = orderService;

  @override
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) {
    return _service.createOrder(request);
  }

  @override
  Future<List<OrderHistory>> getOrdersHistory(OrderHistoryRequest data) {
    return _service.fetchOrdersHistory(data);
  }

  @override
  Future<OrderHistoryDetail> getOrderHistoryDetail(OrderHistoryDetailRequest data) {
    return _service.fetchOrderHistoryDetail(data);
  }
}
