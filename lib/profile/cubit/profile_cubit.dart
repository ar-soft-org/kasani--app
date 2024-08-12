import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required ShoppingCartRepository shoppingCartRepository,
  })  : _shoppingCartRepository = shoppingCartRepository,
        super(const ProfileState());

  final ShoppingCartRepository _shoppingCartRepository;

  clearProductsData() {
    _shoppingCartRepository.clearProducts();
    _shoppingCartRepository.clearProductsData();
  }
}
