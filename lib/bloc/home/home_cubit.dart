import 'package:bloc/bloc.dart';
import 'package:kasanipedido/models/category/category_model.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:kasanipedido/models/subcategory/subcategory_model.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:kasanipedido/repositories/category_repository.dart';
import 'package:kasanipedido/repositories/product_repository.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.categoryRepository,
    required this.productRepository,
    required ShoppingCartRepository shoppingCartRepository,
  })  : _shoppingCartRepository = shoppingCartRepository,
        super(HomeState());

  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;
  final ShoppingCartRepository _shoppingCartRepository;

  fetchCategoriesSubCategories(HostModel host) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final categories = await categoryRepository.fetchCategoriesSubCategories(
        token: host.token,
        conexion: host.conexion,
        idEmpleado: host.idEmpleado,
        idEmpresa: host.idEmpresa,
        idSucursal: host.idSucursal,
        idUsuario: host.idUsuario,
      );
      emit(state.copyWith(
          status: HomeStatus.success,
          categories: categories,
          currentCategory: () => null,
          currentSubCategory: () => null,
          currentProducts: []));
    } on UnauthorizedException catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: () => e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: () => e.toString(),
      ));
    } finally {
      emit(state.copyWith(errorMessage: () => null));
    }
  }

  fetchProducts(HostModel host) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final products = await productRepository.fetchProducts(
        token: host.token,
        conexion: host.conexion,
        idEmpresa: host.idEmpresa,
        idSucursal: host.idSucursal,
        idUsuario: host.idUsuario,
        idEmpleado: host.idEmpleado,
      );

      emit(state.copyWith(
        status: HomeStatus.success,
        products: products,
      ));

      _updateProductsByCategory(products);
    } on UnauthorizedException catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: () => e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: () => e.toString(),
      ));
    } finally {
      emit(state.copyWith(errorMessage: () => null));
    }
  }

  _updateProductsByCategory(List<Product> products) {
    final productsByCategory = <String, List<Product>>{};

    for (var product in products) {
      if (productsByCategory.containsKey(product.categoria)) {
        productsByCategory[product.categoria]!.add(product);
      } else {
        productsByCategory[product.categoria] = [product];
      }
    }

    emit(state.copyWith(productsByCategory: () => productsByCategory));
  }

  setCurrentCategory(String categoryId) {
    final category = state.categories
        .firstWhere((element) => element.idCategoria == categoryId);

    emit(state.copyWith(
      currentCategory: () => category,
      currentSubCategory: () => category.subCategorias.first,
    ));
  }

  setCurrentSubCategory(String subCategoryId) {
    final subCategory = state.currentCategory!.subCategorias
        .firstWhere((element) => element.idSubCategoria == subCategoryId);

    final products = _getProductsBySubCategory(
        state.currentCategory!.nombreCategoria, subCategory.nombreSubCategoria);

    emit(state.copyWith(
        currentSubCategory: () => subCategory, currentProducts: products));
  }

  addProductData(Product product, {ProductData? data}) {
    _shoppingCartRepository.addProductData(data ??
        ProductData.initialValue(product.idProducto, product.precio).copyWith(
          quantity: 1,
        ));
  }

  updateProductData(ProductData data) {
    _shoppingCartRepository.updateProductData(data);
  }

  deleteProductData(String id) {
    _shoppingCartRepository.deleteProductData(id);
    _shoppingCartRepository.deleteProduct(id);
  }

  _getProductsBySubCategory(String category, String subCategory) {
    final products = state.products
        .where((element) =>
            element.categoria == category &&
            element.subCategoria == subCategory)
        .toList();
    return [...products];
  }
}
