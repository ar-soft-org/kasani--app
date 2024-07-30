import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kasanipedido/api/dio_interceptor.dart';
import 'package:kasanipedido/data/services/order_booking/order_booking_service.dart';
import 'package:kasanipedido/services/authentication_service.dart';
import 'package:provider/provider.dart';

class ServiceProviders extends StatelessWidget {
  const ServiceProviders({
    super.key,
    required this.child,
    required this.dio,
    required this.orderBookingService,
  });

  final Widget child;
  final Dio dio;
  final OrderBookingService orderBookingService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthenticationService()),
        Provider.value(value: dio),
        Provider.value(value: orderBookingService),
        Provider(create: (_) => DioInterceptor(dio: dio))
      ],
      child: child,
    );
  }
}
