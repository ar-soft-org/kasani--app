import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/bloc/auth/auth_cubit.dart';
import 'package:kasanipedido/bloc/home/home_cubit.dart';
import 'package:kasanipedido/bloc/login/login_cubit.dart';
import 'package:kasanipedido/bloc/splash/splash_cubit.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:kasanipedido/repositories/category_repository.dart';
import 'package:kasanipedido/repositories/product_repository.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class BlocProviders extends StatelessWidget {
  const BlocProviders({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(
              repository:
                  RepositoryProvider.of<AuthenticationRepository>(context)),
        ),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => SplashCubit()),
        BlocProvider(
          create: (context) => HomeCubit(
            categoryRepository:
                RepositoryProvider.of<CategoryRepository>(context),
            productRepository:
                RepositoryProvider.of<ProductRepository>(context),
            shoppingCartRepository:
                RepositoryProvider.of<ShoppingCartRepository>(context),
          ),
        ),
      ],
      child: child,
    );
  }
}
