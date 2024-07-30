import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';

class OrderBookingRepository {
  OrderBookingRepository({required OrderBookingApi orderBookingApi})
      : _orderBookingApi = orderBookingApi;
  final OrderBookingApi _orderBookingApi;

  createOrder(CreateOrderRequest data) => _orderBookingApi.createOrder(data);
}
