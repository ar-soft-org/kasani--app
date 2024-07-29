import 'package:products_api/products_api.dart';
import 'package:rxdart/rxdart.dart';

class ProductsApiImpl extends ProductsApi {
  ProductsApiImpl();

  late final _productsStreamController =
      BehaviorSubject<List<Product>>.seeded(const []);

  // TODO: use sharedPreferences to save local products selected

  @override
  Stream<List<Product>> getProducts() {
    return _productsStreamController.asBroadcastStream();
  }

  @override
  Future<void> deleteProduct(String id) async {
    final products = [..._productsStreamController.value];
    final productIndex = products.indexWhere((p) => p.idProducto == id);
    if (productIndex == -1) {
      throw ProductNotFoundException();
    } else {
      products.removeAt(productIndex);
      _productsStreamController.add(products);
    }
  }

  @override
  void updateProduct(Product product) {
    final products = [..._productsStreamController.value];
    final productIndex =
        products.indexWhere((p) => p.idProducto == product.idProducto);
    if (productIndex == -1) {
      throw ProductNotFoundException();
    } else {
      products[productIndex] = product;
      _productsStreamController.add(products);
    }
  }

  // @override
  // Future<void> createOrder() async {
  //   _dioInstance.post('');
  // }

  @override
  Future<void> close() {
    return _productsStreamController.close();
  }
}
