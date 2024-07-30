class OrderHistoryDetailRequest {
  final String conexion;
  final String idEmpresa;
  final String idSucursal;
  final String idUsuario;
  final String idEmpleado;
  final String idPedido;

  OrderHistoryDetailRequest({
    required this.conexion,
    required this.idEmpresa,
    required this.idSucursal,
    required this.idUsuario,
    required this.idEmpleado,
    required this.idPedido,
  });

  OrderHistoryDetailRequest copyWith({
    String? conexion,
    String? idEmpresa,
    String? idSucursal,
    String? idUsuario,
    String? idEmpleado,
    String? idPedido,
  }) =>
      OrderHistoryDetailRequest(
        conexion: conexion ?? this.conexion,
        idEmpresa: idEmpresa ?? this.idEmpresa,
        idSucursal: idSucursal ?? this.idSucursal,
        idUsuario: idUsuario ?? this.idUsuario,
        idEmpleado: idEmpleado ?? this.idEmpleado,
        idPedido: idPedido ?? this.idPedido,
      );

  factory OrderHistoryDetailRequest.fromJson(Map<String, dynamic> json) =>
      OrderHistoryDetailRequest(
        conexion: json['conexion'],
        idEmpresa: json['id_empresa'],
        idSucursal: json['id_sucursal'],
        idUsuario: json['id_usuario'],
        idEmpleado: json['id_empleado'],
        idPedido: json['id_pedido'],
      );

  Map<String, dynamic> toJson() => {
        'conexion': conexion,
        'id_empresa': idEmpresa,
        'id_sucursal': idSucursal,
        'id_usuario': idUsuario,
        'id_empleado': idEmpleado,
        'id_pedido': idPedido,
      };
}
