import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:kasanipedido/repositories/category_repository.dart';
import 'package:kasanipedido/repositories/product_repository.dart';

class RepositoryProviders extends StatelessWidget {
  const RepositoryProviders(
      {super.key, required this.child, required this.values});

  final Widget child;
  final List<dynamic> values;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthenticationRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        ...values.map((r) => RepositoryProvider.value(value: r))
      ],
      child: child,
    );
  }
}
