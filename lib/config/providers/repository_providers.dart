import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/domain/repository/auth/auth_repository.dart';
import 'package:kasanipedido/domain/repository/client/client_repository.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:kasanipedido/repositories/category_repository.dart';
import 'package:kasanipedido/repositories/product_repository.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class RepositoryProviders extends StatelessWidget {
  const RepositoryProviders({
    super.key,
    required this.child,
    required this.shoppingCartRepository,
    required this.orderBookingRepository,
    required this.dio,
    required this.clientRepository,
    required this.authRepository,
  });

  final Widget child;
  final Dio dio;
  final ShoppingCartRepository shoppingCartRepository;
  final OrderRepository orderBookingRepository;
  final ClientRepository clientRepository;
  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) => AuthenticationRepository(dio: dio)),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider.value(value: shoppingCartRepository),
        RepositoryProvider.value(value: orderBookingRepository),
        RepositoryProvider.value(value: clientRepository),
        RepositoryProvider.value(value: authRepository),
      ],
      child: child,
    );
  }
}
