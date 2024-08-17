import 'package:products_api/products_api.dart';

abstract class ProductsApi {

  const ProductsApi();

  /// Provides a [Stream] of all products selected by the user
  Stream<List<Product>> getProducts();

  void addProductData(ProductData productData);

  void updateProductData(ProductData productData);

  void deleteProductData(String id);

  /// Provides a [Stream] of all products
  Stream<Map<String, ProductData>> getProductsData();

  /// Saves a [product]
  /// 
  /// If a [product] with the same id already exists, it will be replaced.
  void updateProduct(Product product);

  void addProduct(Product product);

  /// Deletes the `product` with the given id.
  /// 
  /// If no `product` with the given id exists, a [ProductNotFoundException] error i
  /// thrown.
  void deleteProduct(String id);

  // Future<void> createOrder();

  /// Closes the client and frees up any resources.
  Future<void> close();

  void clearProductsData();

  void clearProducts();

  Future<List<Product>> getFavoriteProducts(FavoriteProductsRequest data);

  /// Provides a [Stream] of all products from db
  Stream<List<Product>> getProductsFromDb();

  void clearAndAddDbProducts(List<Product> products);

  List<Product> getFilteredProducts(Iterable<String> ids);

}

class ProductNotFoundException implements Exception {}

class ProductDataNotFoundException implements Exception {}

