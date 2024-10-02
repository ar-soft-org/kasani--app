import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  EditProductBloc({
    required ShoppingCartRepository shoppingCartRepository,
  })  : _shoppingCartRepository = shoppingCartRepository,
        super(const EditProductState()) {
    on<EditProductSubmitted>(_onSubmitted);
    on<EditProductAddProduct>(_onAddProduct);
    on<EditProductProductsDataRequested>(_onProductsDataRequested);
  }

  final ShoppingCartRepository _shoppingCartRepository;

  Future<void> _onProductsDataRequested(
    EditProductProductsDataRequested event,
    Emitter<EditProductState> emit,
  ) async {
    emit(state.copyWith(status: () => EditProductStatus.loading));

    await emit.forEach<Map<String, ProductData>>(
      _shoppingCartRepository.getProductsData(),
      onData: (productsData) => state.copyWith(
        status: () => EditProductStatus.success,
        productsData: () => productsData,
      ),
      onError: (_, __) => state.copyWith(
        status: () => EditProductStatus.failure,
      ),
    );
  }

  void _onSubmitted(
    EditProductSubmitted event,
    Emitter<EditProductState> emit,
  ) async {
    final product = event.product;
    _shoppingCartRepository.updateProduct(product);
  }

  void _onAddProduct(
    EditProductAddProduct event,
    Emitter<EditProductState> emit,
  ) async {
    final product = event.product;
    _shoppingCartRepository.addProduct(product);
  }
}
