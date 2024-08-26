import 'package:products_api/products_api.dart';
import 'package:products_api_impl/src/product_service.dart';
import 'package:rxdart/rxdart.dart';

class ProductsApiImpl extends ProductsApi {
  ProductsApiImpl({
    required ProductService productService,
  }) : _productService = productService;

  final ProductService _productService;

  late final _productsStreamController =
      BehaviorSubject<List<Product>>.seeded(const []);

  late final _productsFromDbStreamController =
      BehaviorSubject<List<Product>>.seeded(const []);

  late final _productsDataStreamController =
      BehaviorSubject<Map<String, ProductData>>.seeded(const {});

  // TODO: use sharedPreferences to save local products selected

  @override
  Stream<List<Product>> getProducts() {
    return _productsStreamController.asBroadcastStream();
  }

  @override
  Stream<List<Product>> getProductsFromDb() {
    return _productsFromDbStreamController.asBroadcastStream();
  }

  @override
  Stream<Map<String, ProductData>> getProductsData() {
    return _productsDataStreamController.asBroadcastStream();
  }

  @override
  void addProduct(Product product) {
    final products = [..._productsStreamController.value];
    products.add(product);
    _productsStreamController.add(products);
  }

  @override
  void addProductData(ProductData productData) {
    // validate quantity

    if (productData.quantity < 0) {
      throw Exception('Quantity must be greater than 0');
    }

    final map = {..._productsDataStreamController.value};
    map[productData.productId] = productData;
    _productsDataStreamController.add(map);
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

  @override
  void updateProductData(ProductData productData) {
    if (productData.quantity < 0) {
      throw Exception('Quantity must be greater than 0');
    }

    final map = {..._productsDataStreamController.value};
    final element = map.containsKey(productData.productId);
    if (!element) {
      throw ProductDataNotFoundException();
    }
    map[productData.productId] = productData;
    _productsDataStreamController.add(map);
  }

  // @override
  // Future<void> createOrder() async {
  //   _dioInstance.post('');
  // }

  @override
  void deleteProduct(String id) {
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
  void deleteProductData(String id) async {
    final map = {..._productsDataStreamController.value};
    final element = map.containsKey(id);
    if (!element) {
      throw ProductDataNotFoundException();
    }
    map.remove(id);
    _productsDataStreamController.add(map);
  }

  @override
  void clearProductsData() {
    _productsDataStreamController.add(const {});
  }

  @override
  void clearProducts() {
    _productsStreamController.add(const []);
  }

  @override
  Future<void> close() async {
    await _productsStreamController.close();
    await _productsDataStreamController.close();
  }

  @override
  Future<List<Product>> getFavoriteProducts(
      FavoriteProductsRequest data) async {
    return _productService.fetchFavoriteProducts(data);
  }

  @override
  List<Product> getFilteredProducts(Iterable<String> ids) {
    final products = [..._productsFromDbStreamController.value];

    final filteredProducts =
        products.where((product) => ids.contains(product.idProducto)).toList();

    return filteredProducts;
  }

  @override
  void clearAndAddDbProducts(List<Product> products) {
    _productsFromDbStreamController.add(const []);
    _productsFromDbStreamController.add(products);
  }
}
