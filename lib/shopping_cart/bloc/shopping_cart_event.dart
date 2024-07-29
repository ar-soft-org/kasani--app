part of 'shopping_cart_bloc.dart';

sealed class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [];
}

final class ShoppingCartSubscriptionRequested extends ShoppingCartEvent {
  const ShoppingCartSubscriptionRequested();
}
