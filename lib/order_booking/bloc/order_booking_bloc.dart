import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/domain/repository/client/models/subsidiary.dart';
import 'package:kasanipedido/domain/repository/order_booking/models/create_order_request.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_api.dart';
import 'package:kasanipedido/domain/repository/order_booking/order_booking_repository.dart';
import 'package:kasanipedido/models/user/user_model.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

part 'order_booking_event.dart';
part 'order_booking_state.dart';

class OrderBookingBloc extends Bloc<OrderBookingEvent, OrderBookingState> {
  OrderBookingBloc({
    required OrderRepository orderBookingRepository,
  })  : _orderBookingRepository = orderBookingRepository,
        super(const OrderBookingState()) {
    on<OrderBookingSubsidiariesRequested>(_onSubsidiariesRequested);
    on<OrderBookingSubsidiarySelected>(_onSubsidiarySelected);
    on<OrderBookingDateSelected>(_onDateSelected);
    on<OrderBookingCommentSaved>(_onCommentSaved);
    on<OrderBookingOrderCreated>(_onOrderCreated);
  }

  final OrderRepository _orderBookingRepository;

  _onSubsidiariesRequested(
    OrderBookingSubsidiariesRequested event,
    Emitter<OrderBookingState> emit,
  ) async {
    emit(state.copyWith(status: OrderBookingStatus.loading));

    try {
      final subsidiaries = event.subsidiaries;
      emit(state.copyWith(
        subsidiaries: subsidiaries,
        status: OrderBookingStatus.success,
        currentSubsidiary:
            subsidiaries.length == 1 ? () => subsidiaries.first : () => null,
      ));
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

    final user = event.user;
    final data = CreateOrderRequest(
      conexion: user.conexion,
      idEmpresa: user.idEmpresa,
      idSucursal: user.idSucursal,
      idUsuario: user.idUsuario,
      idEmpleado: event.employeId ?? '',
      idCliente: event.clientId ?? '',
      usuario: event.email,
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
