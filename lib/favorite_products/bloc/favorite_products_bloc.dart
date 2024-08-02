
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:products_api/products_api.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';
part 'favorite_products_event.dart';
part 'favorite_products_state.dart';

class FavoriteProductsBloc extends Bloc<FavoriteProductsEvent, FavoriteProductsState> {
  FavoriteProductsBloc({required ShoppingCartRepository shoppingCartRepository}) 
  : _shoppingCartRepository = shoppingCartRepository, super(FavoriteProductsState()){
    on<FavoriteProductsSuscribe>((event, emit) async {
      final host = event.hostModel;
      FavoriteProductsRequest request = FavoriteProductsRequest(
        conexion: host.conexion,
        idCliente: host.idCliente,
        idEmpleado: host.idEmpleado,
        idEmpresa: host.idEmpresa,
        idSucursal: host.idSucursal,
        idUsuario: host.idUsuario,

      );
      final products = await _shoppingCartRepository.getFavoriteProducts(request);
      emit(FavoriteProductsState(products: products));
      inspect(products);
    });
  }
  
  final ShoppingCartRepository _shoppingCartRepository;

}