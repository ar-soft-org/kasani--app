import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  ShoppingCartBloc({
    required ShoppingCartRepository shoppingCartRepository,
  })  : _shoppingCartRepository = shoppingCartRepository,
        super(const ShoppingCartState()) {
    on<ShoppingCartSubscriptionRequested>(_onSubscriptionRequested);
  }

  final ShoppingCartRepository _shoppingCartRepository;

  Future<void> _onSubscriptionRequested(
    ShoppingCartSubscriptionRequested event,
    Emitter<ShoppingCartState> emit,
  ) async {
    emit(state.copyWith(status: () => ShoppingCartStatus.loading));

    await emit.forEach<List<Product>>(
      _shoppingCartRepository.getProducts(),
      onData: (products) => state.copyWith(
        status: () => ShoppingCartStatus.success,
        products: () => products,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ShoppingCartStatus.failure,
      ),
    );
  }
}
