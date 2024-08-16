import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_detail_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/models/user/user_model.dart';

part 'order_history_detail_state.dart';

class OrderHistoryDetailCubit extends Cubit<OrderHistoryDetailState> {
  OrderHistoryDetailCubit({
    required OrderRepository orderRepository,
    required OrderHistory orderHistory,
  })  : _orderRepository = orderRepository,
        super(OrderHistoryDetailState(
          orderHistory: orderHistory,
        ));

  final OrderRepository _orderRepository;

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
    // TODO: Implement order again
  }
}
