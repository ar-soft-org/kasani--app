import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:kasanipedido/repositories/category_repository.dart';
import 'package:kasanipedido/repositories/product_repository.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class RepositoryProviders extends StatelessWidget {
  const RepositoryProviders({
    super.key,
    required this.child,
    required this.shoppingCartRepository,
  });

  final Widget child;
  final ShoppingCartRepository shoppingCartRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthenticationRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider.value(value: shoppingCartRepository)
      ],
      child: child,
    );
  }
}
