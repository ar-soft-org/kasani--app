import 'package:products_api/products_api.dart';

abstract class ProductsApi {

  const ProductsApi();

  /// Provides a [Stream] of all products
  Stream<List<Product>> getProducts();

  /// Saves a [product]
  /// 
  /// If a [product] with the same id already exists, it will be replaced.
  Future<void> updateProduct(Product product);

  /// Deletes the `product` with the given id.
  /// 
  /// If no `product` with the given id exists, a [ProductNotFoundException] error i
  /// thrown.
  Future<void> deleteProduct(String id);

  // Future<void> createOrder();

  /// Closes the client and frees up any resources.
  Future<void> close();
}

class ProductNotFoundException implements Exception {}