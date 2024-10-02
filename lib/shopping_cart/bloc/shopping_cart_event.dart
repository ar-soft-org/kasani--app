part of 'shopping_cart_bloc.dart';

sealed class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingCartSubscriptionRequested extends ShoppingCartEvent {
  const ShoppingCartSubscriptionRequested();
}

final class ShoppingCartProductsDataRequested extends ShoppingCartEvent {
  const ShoppingCartProductsDataRequested();
}

final class ShoppingCartProductDataAdd extends ShoppingCartEvent {
  const ShoppingCartProductDataAdd({required this.data});
  final ProductData data;

  @override
  List<Object> get props => [data];
}

final class ShoppingCartProductDataUpdated extends ShoppingCartEvent {
  const ShoppingCartProductDataUpdated({required this.data});
  final ProductData data;

  @override
  List<Object> get props => [data];
}

final class ShoppingCartProductDataDeleted extends ShoppingCartEvent {
  const ShoppingCartProductDataDeleted({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}

final class ShoppingCartAllDataCleared extends ShoppingCartEvent {
  const ShoppingCartAllDataCleared();
}
