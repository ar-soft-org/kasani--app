part of 'order_booking_bloc.dart';

sealed class OrderBookingEvent extends Equatable {
  const OrderBookingEvent();

  @override
  List<Object> get props => [];
}

final class OrderBookingSubsidiariesRequested extends OrderBookingEvent {
  const OrderBookingSubsidiariesRequested();
}

final class OrderBookingSubsidiarySelected extends OrderBookingEvent {
  final SubsidiaryModel subsidiary;

  const OrderBookingSubsidiarySelected({required this.subsidiary});

  @override
  List<Object> get props => [subsidiary];
}

final class OrderBookingDateSelected extends OrderBookingEvent {
  final String dateStr;

  const OrderBookingDateSelected({required this.dateStr});

  @override
  List<Object> get props => [dateStr];
}

final class OrderBookingCommentSaved extends OrderBookingEvent {
  final String comment;

  const OrderBookingCommentSaved({required this.comment});

  @override
  List<Object> get props => [comment];
}

final class OrderBookingOrderCreated extends OrderBookingEvent {
  final HostModel host;
  final List<ProductData> productsData;

  const OrderBookingOrderCreated({
    required this.host,
    required this.productsData,
  });

  @override
  List<Object> get props => [
        host,
        productsData,
      ];
}
