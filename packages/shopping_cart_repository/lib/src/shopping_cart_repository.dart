library shopping_cart_repository;

import 'package:products_api/products_api.dart';

class ShoppingCartRepository {
  const ShoppingCartRepository({
    required ProductsApi productsApi,
  }) : _productsApi = productsApi;

  final ProductsApi _productsApi;

  Stream<List<Product>> getProducts() => _productsApi.getProducts();

  Stream<Map<String, ProductData>> getProductsData() =>
      _productsApi.getProductsData();

  void addProduct(Product product) => _productsApi.addProduct(product);

  void addProductData(ProductData data) => _productsApi.addProductData(data);

  void updateProduct(Product product) => _productsApi.updateProduct(product);

  void updateProductData(ProductData data) => _productsApi.updateProductData(data);

  void deleteProduct(String id) => _productsApi.deleteProduct(id);

  void deleteProductData(String id) => _productsApi.deleteProductData(id);

  void clearProductsData() => _productsApi.clearProductsData();

  Future<void> close() => _productsApi.close();
}
