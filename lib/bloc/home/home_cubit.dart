import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
        searchController = TextEditingController(), 
        super(const HomeState()) {
    searchController.addListener(_onSearchTextChanged);
  }

  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;
  final ShoppingCartRepository _shoppingCartRepository;
  final TextEditingController searchController;

  void _onSearchTextChanged() {
    final searchText = searchController.text;
    emit(state.copyWith(searchText: searchText)); 
  }


  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

    void clearSearch() {
    emit(state.copyWith(searchText: '')); 
  }
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

      CategoryModel? initialCategory = categories.isNotEmpty ? categories.first : null;
      SubCategoria? initialSubCategory = initialCategory?.subCategorias.isNotEmpty == true 
          ? initialCategory!.subCategorias.first 
          : null;

      final List<Product> initialProducts = initialSubCategory != null
          ? _getProductsBySubCategory(
              initialCategory!.nombreCategoria,
              initialSubCategory.nombreSubCategoria,
            )
          : [];

      emit(state.copyWith(
        status: HomeStatus.success,
        categories: categories,
        currentCategory: () => initialCategory,
        currentSubCategory: () => initialSubCategory,
        currentProducts: initialProducts,
      ));
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

  setCurrentSelection({
    required String id,
    required bool isCategory,
    int? index,
  }) {
    if (isCategory) {
      final category =
          state.categories.firstWhere((element) => element.idCategoria == id);

      emit(state.copyWith(
        currentCategory: () => category,
        currentSubCategory: () => null,
        selectedSubCategoryIndex: -1,
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
        selectedSubCategoryIndex: index ?? state.selectedSubCategoryIndex, 
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
