part of 'favorite_products_bloc.dart';

enum FavoriteProductsStatus { initial, loading, success, failure }

class FavoriteProductsState {
  FavoriteProductsState({
    this.products = const [],
    this.status = FavoriteProductsStatus.initial,
  });

  final FavoriteProductsStatus status;
  final List<Product> products;

  FavoriteProductsState copyWith({
    FavoriteProductsStatus? status,
    List<Product>? products,
  }) {
    return FavoriteProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }
}

extension FavoriteProductsStateX on FavoriteProductsState {
  bool get isLoading => status == FavoriteProductsStatus.loading;
  bool get isSuccess => status == FavoriteProductsStatus.success;
  bool get isFailure => status == FavoriteProductsStatus.failure;
}
