part of 'shopping_cart_bloc.dart';

enum ShoppingCartStatus { initial, loading, success, failure }

final class ShoppingCartState extends Equatable {
  const ShoppingCartState({
    this.status = ShoppingCartStatus.initial,
    this.products = const [],
    this.productsData = const {},
  });

  final ShoppingCartStatus status;
  final List<Product> products;
  final Map<String, ProductData> productsData;

  ShoppingCartState copyWith({
    ShoppingCartStatus Function()? status,
    List<Product> Function()? products,
    Map<String, ProductData> Function()? productsData,
  }) {
    return ShoppingCartState(
      status: status != null ? status() : this.status,
      products: products != null ? products() : this.products,
      productsData: productsData != null ? productsData() : this.productsData,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        productsData,
      ];
}
