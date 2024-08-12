import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasanipedido/models/user/user_model.dart';
import 'package:products_api/products_api.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';
part 'favorite_products_event.dart';
part 'favorite_products_state.dart';

class FavoriteProductsBloc
    extends Bloc<FavoriteProductsEvent, FavoriteProductsState> {
  FavoriteProductsBloc({required ShoppingCartRepository shoppingCartRepository})
      : _shoppingCartRepository = shoppingCartRepository,
        super(FavoriteProductsState()) {
    on<FavoriteProductsSuscribe>((event, emit) async {
      final user = event.user;

      try {
        FavoriteProductsRequest request = FavoriteProductsRequest(
          conexion: user.conexion,
          idCliente: event.clientId,
          idEmpleado: event.employeeId ?? '',
          idEmpresa: user.idEmpresa,
          idSucursal: user.idSucursal,
          idUsuario: user.idUsuario,
        );

        emit(state.copyWith(status: FavoriteProductsStatus.loading));

        final products =
            await _shoppingCartRepository.getFavoriteProducts(request);
        emit(state.copyWith(
          products: products,
          status: FavoriteProductsStatus.success,
        ));
      } catch (e) {
        emit(state.copyWith(status: FavoriteProductsStatus.failure));
      }
    });
  }

  final ShoppingCartRepository _shoppingCartRepository;
}
