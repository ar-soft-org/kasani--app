part of 'order_history_detail_cubit.dart';

enum OrderHistoryDetailStatus { initial, loading, success, failure }

class OrderHistoryDetailState extends Equatable {
  const OrderHistoryDetailState({
    required this.orderHistory,
    this.status = OrderHistoryDetailStatus.initial,
    this.detail,
    this.errorMessage = '',
  });

  final OrderHistory orderHistory;
  final OrderHistoryDetailStatus status;
  final OrderHistoryDetail? detail;
  final String errorMessage;

  copyWith({
    OrderHistoryDetailStatus? status,
    OrderHistory? orderHistory,
    OrderHistoryDetail? Function()? detail,
    String? errorMessage,
  }) =>
      OrderHistoryDetailState(
        detail: detail != null ? detail() : this.detail,
        orderHistory: orderHistory ?? this.orderHistory,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        orderHistory,
        detail,
        errorMessage,
      ];
}
