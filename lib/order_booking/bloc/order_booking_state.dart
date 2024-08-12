part of 'order_booking_bloc.dart';

enum OrderBookingStatus { initial, loading, success, failure }

enum CreateOrderStatus { initial, loading, success, failure }

final class OrderBookingState extends Equatable {
  const OrderBookingState({
    this.status = OrderBookingStatus.initial,
    this.createOrderStatus = CreateOrderStatus.initial,
    this.subsidiaries = const [],
    this.currentSubsidiary,
    this.dateStr,
    this.comment = '',
    this.errorMessage = '',
  });

  final OrderBookingStatus status;
  final CreateOrderStatus createOrderStatus;
  final List<Subsidiary> subsidiaries;

  final Subsidiary? currentSubsidiary;
  final String? dateStr;
  final String comment;
  final String errorMessage;

  copyWith({
    OrderBookingStatus? status,
    CreateOrderStatus? createOrderStatus,
    List<Subsidiary>? subsidiaries,
    Subsidiary? Function()? currentSubsidiary,
    String? Function()? dateStr,
    String? comment,
    String? errorMessage,
  }) =>
      OrderBookingState(
        status: status ?? this.status,
        createOrderStatus: createOrderStatus ?? this.createOrderStatus,
        subsidiaries: subsidiaries ?? this.subsidiaries,
        currentSubsidiary: currentSubsidiary != null
            ? currentSubsidiary()
            : this.currentSubsidiary,
        dateStr: dateStr != null ? dateStr() : this.dateStr,
        comment: comment ?? this.comment,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        createOrderStatus,
        subsidiaries,
        currentSubsidiary,
        dateStr,
        comment,
        errorMessage,
      ];
}

extension OrderBookingStateX on OrderBookingState {
  bool get isStepOneCompleted {
    return currentSubsidiary != null && dateStr != null;
  }
}
