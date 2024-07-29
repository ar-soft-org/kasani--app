library shopping_cart_repository;

import 'package:products_api/products_api.dart';

class ShoppingCartRepository {
  const ShoppingCartRepository({
    required ProductsApi productsApi,
  }) : _productsApi = productsApi;

  final ProductsApi _productsApi;

  Stream<List<Product>> getProducts() => _productsApi.getProducts();

  Future<void> updateProduct(Product product) =>
      _productsApi.updateProduct(product);

  Future<void> deleteProduct(String id) => _productsApi.deleteProduct(id);

  Future<void> close() => _productsApi.close();
}
