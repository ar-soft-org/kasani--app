import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/order_history_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/models/user/user_model.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({
    required OrderRepository orderRepository,
  })  : _orderRepository = orderRepository,
        super(const OrderHistoryState());

  final OrderRepository _orderRepository;

  Future<void> getOrdersHistory(
    User host, {
    String? clientId,
    String? employeeId,
    required int days,
  }) async {
    emit(state.copyWith(status: OrderHistoryStatus.loading));

    final now = DateTime.now().add(const Duration(days: 30));
    // nowString format is '20240701'
    final nowString =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    final startDate = now.subtract(Duration(days: days == 0 ? 90 : days));

    final startDateString =
        '${startDate.year}${startDate.month.toString().padLeft(2, '0')}${startDate.day.toString().padLeft(2, '0')}';

    try {
      final data = OrderHistoryRequest(
        conexion: host.conexion,
        idEmpresa: host.idEmpresa,
        idSucursal: host.idSucursal,
        idUsuario: host.idUsuario,
        idEmpleado: employeeId ?? '',
        idCliente: clientId ?? '',
        fechaInicio: startDateString,
        fechaFinal: nowString,
      );

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
