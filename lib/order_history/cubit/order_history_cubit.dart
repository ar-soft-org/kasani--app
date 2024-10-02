import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/models/host/host_model.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({
    required OrderRepository orderRepository,
  })  : _orderRepository = orderRepository,
        super(const OrderHistoryState());

  final OrderRepository _orderRepository;

  Future<void> getOrdersHistory(HostModel host) async {
    emit(state.copyWith(status: OrderHistoryStatus.loading));

    try {
      final data = OrderHistoryRequest(
          conexion: host.conexion,
          idEmpresa: host.idEmpresa,
          idSucursal: host.idSucursal,
          idUsuario: host.idUsuario,
          // FIXME:
          // idEmpleado: host.idEmpleado.isEmpty ? '2' : host.idEmpleado,
          idEmpleado: host.idEmpleado,
          idCliente: host.idCliente,
          fechaInicio: '20240701',
          fechaFinal: '20240730');

      final history = await _orderRepository.getOrdersHistory(data);
      emit(
          state.copyWith(history: history, status: OrderHistoryStatus.success));
    } on OrderApiException catch (e) {
      emit(state.copyWith(
          status: OrderHistoryStatus.failure,
          errorMessage: 'Something went wrong: ${e.message}'));
    } catch (e) {
      emit(state.copyWith(
          status: OrderHistoryStatus.failure,
          errorMessage: 'Something went wrong: ${e.toString()}'));
    } finally {
      emit(
          state.copyWith(status: OrderHistoryStatus.initial, errorMessage: ''));
    }
  }
}
