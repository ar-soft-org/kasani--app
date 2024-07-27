part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState {
  final HomeStatus status;
  final String? errorMessage;

  final List<CategoryModel> categories;
  final CategoryModel? currentCategory;
  final SubCategoria? currentSubCategory;

  final List<ProductModel> products;
  final List<ProductModel> currentProducts;

  HomeState({
    this.status = HomeStatus.initial,
    this.categories = const [],
    this.products = const [],
    this.currentCategory,
    this.currentSubCategory,
    this.currentProducts = const [],
    this.errorMessage,
  });

  copyWith({
    HomeStatus? status,
    List<CategoryModel>? categories,
    CategoryModel? Function()? currentCategory,
    SubCategoria? Function()? currentSubCategory,
    String? Function()? errorMessage,
    List<ProductModel>? products,
    List<ProductModel>? currentProducts,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      currentCategory:
          currentCategory != null ? currentCategory() : this.currentCategory,
      currentSubCategory: currentSubCategory != null
          ? currentSubCategory()
          : this.currentSubCategory,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      products: products ?? this.products,
      currentProducts: currentProducts ?? this.currentProducts,
    );
  }
}

extension HomeStateX on HomeState {
  bool get hasError => errorMessage != null;

  bool get hasCurrentCategory => currentCategory != null;

  bool get hasCurrentSubCategory => currentSubCategory != null;

  bool get hasCategories => categories.isNotEmpty;

  bool get hasSubCategories =>
      currentCategory != null && currentCategory!.subCategorias.isNotEmpty;

  bool get isLoading => status == HomeStatus.loading;
}