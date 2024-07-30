part of 'order_history_cubit.dart';

enum OrderHistoryStatus { initial, loading, success, failure }

class OrderHistoryState extends Equatable {
  const OrderHistoryState(
      {this.status = OrderHistoryStatus.initial,
      this.history = const [],
      this.errorMessage = ''});

  final OrderHistoryStatus status;
  final List<OrderHistory> history;
  final String errorMessage;

  copyWith({
    OrderHistoryStatus? status,
    List<OrderHistory>? history,
    String? errorMessage,
  }) =>
      OrderHistoryState(
        history: history ?? this.history,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        status,
        history,
        errorMessage,
      ];
}
