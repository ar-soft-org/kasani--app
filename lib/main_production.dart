import 'package:flutter/widgets.dart';
import 'package:kasanipedido/app/app.dart';
import 'package:kasanipedido/bootstrap.dart';
import 'package:products_api_impl/products_api_impl.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final productsApi = ProductsApiImpl();

  final shoppingCartRepository =
      ShoppingCartRepository(productsApi: productsApi);

  await bootstrap(() {
    return App(
      shoppingCartRepository: shoppingCartRepository,
    );
  });
}
