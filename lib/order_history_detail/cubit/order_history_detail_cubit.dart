import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/models/user/user_model.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

part 'order_history_detail_state.dart';

class OrderHistoryDetailCubit extends Cubit<OrderHistoryDetailState> {
  OrderHistoryDetailCubit({
    required OrderRepository orderRepository,
    required OrderHistory orderHistory,
    required ShoppingCartRepository shoppingCartRepository,
  })  : _orderRepository = orderRepository,
        _shoppingCartRepository = shoppingCartRepository,
        super(OrderHistoryDetailState(
          orderHistory: orderHistory,
        ));

  final OrderRepository _orderRepository;
  final ShoppingCartRepository _shoppingCartRepository;

  Future<void> getOrderHistoryDetail(
    User user, {
    String? employeeId,
  }) async {
    emit(state.copyWith(status: OrderHistoryDetailStatus.loading));

    try {
      final data = OrderHistoryDetailRequest(
        conexion: user.conexion,
        idEmpresa: user.idEmpresa,
        idSucursal: user.idSucursal,
        idUsuario: user.idUsuario,
        idEmpleado: employeeId ?? '',
        idPedido: state.orderHistory.idPedido,
      );

      final detail = await _orderRepository.getOrderHistoryDetail(data);
      emit(state.copyWith(
          detail: () => detail, status: OrderHistoryDetailStatus.success));
    } on OrderApiException catch (e) {
      emit(state.copyWith(
          status: OrderHistoryDetailStatus.failure,
          errorMessage: 'Something went wrong: ${e.message}'));
    } catch (e) {
      emit(state.copyWith(
          status: OrderHistoryDetailStatus.failure,
          errorMessage: 'Something went wrong: ${e.toString()}'));
    } finally {
      emit(state.copyWith(
          status: OrderHistoryDetailStatus.initial, errorMessage: ''));
    }
  }

  orderAgain() {
    final ids = state.detail?.detalle.map((p) => p.idProducto);

    if (ids == null) {
      throw Exception('No products found');
    }

    final products = _shoppingCartRepository.getFilteredProducts(ids);

    if (products.isEmpty) {
      throw Exception('No products found');
    }

    _clearProductsAndTheirData();

    // add products to shopping cart
    for (final product in products) {
      _shoppingCartRepository.addProduct(product);
    }

    // add data to products
    for (final product in state.detail!.detalle) {
      _shoppingCartRepository.addProductData(ProductData(
        productId: product.idProducto,
        quantity: num.parse(product.cantidad).toDouble(),
        price: num.parse(product.precio).toDouble(),
        observation: product.observacion,
      ));
    }

    emit(state.copyWith(message: () => 'Productos agregados al carrito'));
    emit(state.copyWith(message: () => null));
  }

  _clearProductsAndTheirData() {
    _shoppingCartRepository.clearProducts();
    _shoppingCartRepository.clearProductsData();
  }
}
