import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';

class OrderRepository {
  OrderRepository({required OrderBookingApi orderBookingApi})
      : _orderBookingApi = orderBookingApi;
  final OrderBookingApi _orderBookingApi;

  createOrder(CreateOrderRequest data) => _orderBookingApi.createOrder(data);

  Future<List<OrderHistory>> getOrdersHistory(OrderHistoryRequest data) =>
      _orderBookingApi.getOrdersHistory(data);
      
  Future<OrderHistoryDetail> getOrderHistoryDetail(OrderHistoryDetailRequest data) =>
      _orderBookingApi.getOrderHistoryDetail(data);
}
