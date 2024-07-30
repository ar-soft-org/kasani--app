import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/helpers/storage/user_storage.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:kasanipedido/models/subsidiary/subsidiary_model.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

part 'order_booking_event.dart';
part 'order_booking_state.dart';

class OrderBookingBloc extends Bloc<OrderBookingEvent, OrderBookingState> {
  OrderBookingBloc({
    required OrderBookingRepository orderBookingRepository,
  })  : _orderBookingRepository = orderBookingRepository,
        super(const OrderBookingState()) {
    on<OrderBookingSubsidiariesRequested>(_onSubsidiariesRequested);
    on<OrderBookingSubsidiarySelected>(_onSubsidiarySelected);
    on<OrderBookingDateSelected>(_onDateSelected);
    on<OrderBookingCommentSaved>(_onCommentSaved);
    on<OrderBookingOrderCreated>(_onOrderCreated);
  }

  final OrderBookingRepository _orderBookingRepository;

  _onSubsidiariesRequested(
    OrderBookingSubsidiariesRequested event,
    Emitter<OrderBookingState> emit,
  ) async {
    emit(state.copyWith(status: OrderBookingStatus.loading));

    try {
      final hostJson = await UserStorage.getHost();
      if (hostJson != null) {
        final host = HostModel.fromJson(json.decode(hostJson));
        emit(state.copyWith(
          subsidiaries: host.locales,
          status: OrderBookingStatus.success,
          currentSubsidiary:
              host.locales.length == 1 ? () => host.locales.first : () => null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(status: OrderBookingStatus.failure));
    }
  }

  _onSubsidiarySelected(
    OrderBookingSubsidiarySelected event,
    Emitter<OrderBookingState> emit,
  ) {
    emit(state.copyWith(currentSubsidiary: () => event.subsidiary));
  }

  _onDateSelected(
    OrderBookingDateSelected event,
    Emitter<OrderBookingState> emit,
  ) {
    emit(state.copyWith(dateStr: () => event.dateStr));
  }

  _onCommentSaved(
    OrderBookingCommentSaved event,
    Emitter<OrderBookingState> emit,
  ) {
    emit(state.copyWith(comment: event.comment));
  }

  _onOrderCreated(
    OrderBookingOrderCreated event,
    Emitter<OrderBookingState> emit,
  ) async {
    emit(state.copyWith(
      createOrderStatus: CreateOrderStatus.loading,
    ));

    final host = event.host;
    final data = CreateOrderRequest(
      conexion: host.conexion,
      idEmpresa: host.idEmpresa,
      idSucursal: host.idSucursal,
      idUsuario: host.idUsuario,
      // FIXME
      idEmpleado: host.idEmpleado.isEmpty ? '2' : host.idEmpleado,
      idCliente: host.idCliente,
      usuario: host.correo,
      idLocal: state.currentSubsidiary!.idLocal,
      fechaEntrega: state.dateStr!,
      horaEntrega: state.currentSubsidiary!.horaEntrega,
      observacion: state.comment,
      productos: event.productsData,
    );

    try {
      final result = await _orderBookingRepository.createOrder(data);
      inspect(result);
      emit(state.copyWith(createOrderStatus: CreateOrderStatus.success));
    } on CreateOrderException catch (e) {
      emit(state.copyWith(
        createOrderStatus: CreateOrderStatus.failure,
        errorMessage: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        createOrderStatus: CreateOrderStatus.failure,
        errorMessage: e.toString(),
      ));
    } finally {
      emit(state.copyWith(
        createOrderStatus: CreateOrderStatus.initial,
        errorMessage: '',
      ));
    }
  }
}
