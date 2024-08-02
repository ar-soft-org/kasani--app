
part of 'favorite_products_bloc.dart';

class FavoriteProductsEvent {
  const FavoriteProductsEvent();
}

class FavoriteProductsSuscribe extends FavoriteProductsEvent {
  FavoriteProductsSuscribe({
    required this.hostModel,
  });
  HostModel hostModel;
}
