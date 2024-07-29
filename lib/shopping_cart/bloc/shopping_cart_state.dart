part of 'shopping_cart_bloc.dart';

enum ShoppingCartStatus { initial, loading, success, failure }

final class ShoppingCartState extends Equatable {
  const ShoppingCartState({
    this.status = ShoppingCartStatus.initial,
    this.products = const [],
  });

  final ShoppingCartStatus status;
  final List<Product> products;

  ShoppingCartState copyWith({
    ShoppingCartStatus Function()? status,
    List<Product> Function()? products,
  }) {
    return ShoppingCartState(
      status: status != null ? status() : this.status,
      products: products != null ? products() : this.products,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
      ];
}
