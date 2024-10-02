import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_response.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';

class OrderService {
  const OrderService({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  Future<CreateOrderResponse> createOrder(CreateOrderRequest data) async {
    const path = KasaniEndpoints.orderRegister;

    try {
      final response = await _dio.post(path, data: data.toMap());

      final responseCode = response.data['codigo'];
      if (responseCode is String && responseCode != '00') {
        throw CreateOrderException(
            message: response.data['mensaje'] ?? 'Something went wrong');
      }

      return CreateOrderResponse.fromJson(response.data);
    } on CreateOrderException catch (e) {
      throw CreateOrderException(message: e.message);
    } catch (e) {
      throw CreateOrderException(message: e.toString());
    }
  }

  Future<List<OrderHistory>> fetchOrdersHistory(
      OrderHistoryRequest data) async {
    const path = KasaniEndpoints.orderHistory;

    try {
      final response = await _dio.post(path, data: data.toJson());

      final list = List<OrderHistory>.from(
        (response.data as List<dynamic>).map((e) => OrderHistory.fromJson(e)),
      );

      return list;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw OrderApiException(
            message: e.response?.data['mensaje'] ??
                e.message ??
                e.error?.toString() ??
                e.toString() ??
                'Something went wrong');
      }

      throw OrderApiException(message: e.error?.toString() ?? e.toString());
    }
  }

  Future<OrderHistoryDetail> fetchOrderHistoryDetail(
      OrderHistoryDetailRequest data) async {
    const path = KasaniEndpoints.orderHistoryDetail;

    try {
      final response = await _dio.post(path, data: data.toJson());

      final detail = OrderHistoryDetail.fromJson(response.data);

      return detail;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw OrderApiException(
            message: e.response?.data['mensaje'] ??
                e.message ??
                e.error?.toString() ??
                e.toString() ??
                'Something went wrong');
      }

      throw OrderApiException(message: e.error?.toString() ?? e.toString());
    }
  }
}
