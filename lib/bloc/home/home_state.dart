part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;

  final List<CategoryModel> categories;
  final CategoryModel? currentCategory;
  final SubCategoria? currentSubCategory;

  final List<Product> products;
  final List<Product> currentProducts;
  final Map<String, List<Product>>? productsByCategory;

  HomeState({
    this.status = HomeStatus.initial,
    this.categories = const [],
    this.products = const [],
    this.currentCategory,
    this.currentSubCategory,
    this.currentProducts = const [],
    this.errorMessage,
    this.productsByCategory = const {},
  });

  copyWith({
    HomeStatus? status,
    List<CategoryModel>? categories,
    CategoryModel? Function()? currentCategory,
    SubCategoria? Function()? currentSubCategory,
    String? Function()? errorMessage,
    List<Product>? products,
    List<Product>? currentProducts,
    Map<String, List<Product>>? Function()? productsByCategory,
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
      productsByCategory: productsByCategory != null
          ? productsByCategory()
          : this.productsByCategory,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        products,
        currentCategory,
        currentSubCategory,
        currentProducts,
        errorMessage,
        productsByCategory,
      ];
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
