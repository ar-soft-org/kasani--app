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
  }

  final ShoppingCartRepository _shoppingCartRepository;

  void _onSubmitted(
    EditProductSubmitted event,
    Emitter<EditProductState> emit,
  ) async {
    final product = event.product;
    _shoppingCartRepository.updateProduct(product);
  }
}
