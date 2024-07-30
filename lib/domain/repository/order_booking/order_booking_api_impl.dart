import 'package:kasanipedido/data/services/order_booking/order_booking_service.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_response.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';

class OrderBookingApiImpl extends OrderBookingApi {
  final OrderBookingService _service;

  OrderBookingApiImpl({required OrderBookingService orderBookingService})
      : _service = orderBookingService;

  @override
  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) {
    return _service.createOrder(request);
  }
}
