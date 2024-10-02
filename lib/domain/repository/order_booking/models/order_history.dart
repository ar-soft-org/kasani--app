class OrderHistory {
  final String idPedido;
  final String fechaHora;
  final String encargado;
  final String total;
  final String observacion;

  OrderHistory({
    required this.idPedido,
    required this.fechaHora,
    required this.encargado,
    required this.total,
    required this.observacion,
  });

  OrderHistory copyWith({
    String? idPedido,
    String? fechaHora,
    String? encargado,
    String? total,
    String? observacion,
  }) =>
      OrderHistory(
        idPedido: idPedido ?? this.idPedido,
        fechaHora: fechaHora ?? this.fechaHora,
        encargado: encargado ?? this.encargado,
        total: total ?? this.total,
        observacion: observacion ?? this.observacion,
      );

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        idPedido: json['id_pedido'],
        fechaHora: json['fecha_hora'],
        encargado: json['encargado'],
        total: json['total'],
        observacion: json['observacion'],
      );

  Map<String, dynamic> toJson() => {
        'id_pedido': idPedido,
        'fecha_hora': fechaHora,
        'encargado': encargado,
        'total': total,
        'observacion': observacion,
      };
}
