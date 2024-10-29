import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/models/category/category_model.dart';
import 'package:kasanipedido/models/subcategory/subcategory_model.dart';
import 'package:kasanipedido/models/user/user_model.dart';
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

  fetchCategoriesSubCategories(User host, {String? employeId}) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final categories = await categoryRepository.fetchCategoriesSubCategories(
        token: host.token,
        conexion: host.conexion,
        idEmpleado: employeId ?? '',
        idEmpresa: host.idEmpresa,
        idSucursal: host.idSucursal,
        idUsuario: host.idUsuario,
      );
      emit(state.copyWith(
          status: HomeStatus.success,
          categories: categories,
          currentCategory: () => categories.isEmpty ? null : categories.first,
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

  fetchProducts(User host, {String? employeId}) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final products = await productRepository.fetchProducts(
        token: host.token,
        conexion: host.conexion,
        idEmpresa: host.idEmpresa,
        idSucursal: host.idSucursal,
        idUsuario: host.idUsuario,
        idEmpleado: employeId ?? '',
      );

      emit(state.copyWith(
        status: HomeStatus.success,
        products: products,
        currentProducts: products,
      ));
      _shoppingCartRepository.clearAndAddDbProducts(products);

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

  setCurrentSelection({required String id, required bool isCategory}) {
    if (isCategory) {
      final category =
          state.categories.firstWhere((element) => element.idCategoria == id);

      if (state.currentCategory?.idCategoria == category.idCategoria) {
        emit(state.copyWith(
          currentCategory: () => category,
          currentSubCategory: () => null,
          currentProducts: state.products
              .where((product) => product.categoria == category.nombreCategoria)
              .toList(),
        ));
        return;
      }

      emit(state.copyWith(
        currentCategory: () => category,
        currentSubCategory: () => null,
        currentProducts: state.products
            .where((product) => product.categoria == category.nombreCategoria)
            .toList(),
      ));
    } else {
      if (state.currentCategory == null) return;

      final subCategory = state.currentCategory!.subCategorias
          .firstWhere((element) => element.idSubCategoria == id);

      final products = _getProductsBySubCategory(
          state.currentCategory!.nombreCategoria,
          subCategory.nombreSubCategoria);

      emit(state.copyWith(
        currentCategory: () => state.currentCategory,
        currentSubCategory: () => subCategory,
        currentProducts: products,
      ));
    }
  }

  addProductData(Product product, {ProductData? data}) {
    _shoppingCartRepository.addProductData(data ??
        ProductData.initialValue(product.idProducto, product.precio).copyWith(
          quantity: 1,
        ));
  }

  updateProductData(ProductData data) {
    ProductData updatedData =
        data.quantity < 0 ? data.copyWith(quantity: 0) : data;

    _shoppingCartRepository.updateProductData(updatedData);
  }

  deleteProductData(String id) {
    _shoppingCartRepository.deleteProductData(id);
    _shoppingCartRepository.deleteProduct(id);
  }

  List<Product> _getProductsBySubCategory(
      String categoryName, String subCategoryName) {
    return state.products
        .where((product) =>
            product.categoria == categoryName &&
            product.subCategoria == subCategoryName)
        .toList();
  }
}
