import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_response.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';

class OrderBookingService {
  const OrderBookingService({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  Future<CreateOrderResponse> createOrder(CreateOrderRequest data) async {
    const path = KasaniEndpoints.prepedidoRegister;

    try {
      inspect(_dio.options.headers.toString());
      inspect(data.toMap());

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
}
