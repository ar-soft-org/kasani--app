
part of 'favorite_products_bloc.dart';

class FavoriteProductsEvent {
  const FavoriteProductsEvent();
}

class FavoriteProductsSuscribe extends FavoriteProductsEvent {
  FavoriteProductsSuscribe({
    required this.user,
    required this.clientId,
    this.employeeId,
  });
  final User user;
  final String clientId;
  final String? employeeId;
}
