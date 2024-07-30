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
    on<ShoppingCartProductsDataRequested>(_onProductsDataRequested);
    on<ShoppingCartProductDataAdd>(_onProductsDataAdd);
    on<ShoppingCartProductDataUpdated>(_onProductsDataUpdated);
    on<ShoppingCartProductDataDeleted>(_onProductsDataDeleted);
    on<ShoppingCartAllDataCleared>(_onProductsDataCleared);
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

  Future<void> _onProductsDataRequested(
    ShoppingCartProductsDataRequested event,
    Emitter<ShoppingCartState> emit,
  ) async {
    emit(state.copyWith(status: () => ShoppingCartStatus.loading));

    await emit.forEach<Map<String, ProductData>>(
      _shoppingCartRepository.getProductsData(),
      onData: (productsData) => state.copyWith(
        status: () => ShoppingCartStatus.success,
        productsData: () => productsData,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ShoppingCartStatus.failure,
      ),
    );
  }

  void _onProductsDataAdd(
    ShoppingCartProductDataAdd event,
    Emitter<ShoppingCartState> emit,
  ) {
    final data = event.data;
    _shoppingCartRepository.updateProductData(data);
  }

  void _onProductsDataUpdated(
    ShoppingCartProductDataUpdated event,
    Emitter<ShoppingCartState> emit,
  ) {
    final data = event.data;
    _shoppingCartRepository.updateProductData(data);
  }

  void _onProductsDataDeleted(
    ShoppingCartProductDataDeleted event,
    Emitter<ShoppingCartState> emit,
  ) {
    final id = event.id;
    _shoppingCartRepository.deleteProductData(id);
    _shoppingCartRepository.deleteProduct(id);
  }

  void _onProductsDataCleared(
    ShoppingCartAllDataCleared event,
    Emitter<ShoppingCartState> emit,
  ) {
    _shoppingCartRepository.clearProductsData();
    _shoppingCartRepository.clearProducts();
  }
}
