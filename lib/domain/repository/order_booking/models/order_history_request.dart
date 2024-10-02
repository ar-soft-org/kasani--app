class OrderHistoryRequest {
    final String conexion;
    final String idEmpresa;
    final String idSucursal;
    final String idUsuario;
    final String idEmpleado;
    final String fechaInicio;
    final String fechaFinal;
    final String idCliente;

    OrderHistoryRequest({
        required this.conexion,
        required this.idEmpresa,
        required this.idSucursal,
        required this.idUsuario,
        required this.idEmpleado,
        required this.fechaInicio,
        required this.fechaFinal,
        required this.idCliente,
    });

    OrderHistoryRequest copyWith({
        String? conexion,
        String? idEmpresa,
        String? idSucursal,
        String? idUsuario,
        String? idEmpleado,
        String? fechaInicio,
        String? fechaFinal,
        String? idCliente,
    }) => 
        OrderHistoryRequest(
            conexion: conexion ?? this.conexion,
            idEmpresa: idEmpresa ?? this.idEmpresa,
            idSucursal: idSucursal ?? this.idSucursal,
            idUsuario: idUsuario ?? this.idUsuario,
            idEmpleado: idEmpleado ?? this.idEmpleado,
            fechaInicio: fechaInicio ?? this.fechaInicio,
            fechaFinal: fechaFinal ?? this.fechaFinal,
            idCliente: idCliente ?? this.idCliente,
        );

    factory OrderHistoryRequest.fromJson(Map<String, dynamic> json) => OrderHistoryRequest(
        conexion: json['conexion'],
        idEmpresa: json['id_empresa'],
        idSucursal: json['id_sucursal'],
        idUsuario: json['id_usuario'],
        idEmpleado: json['id_empleado'],
        fechaInicio: json['fecha_inicio'],
        fechaFinal: json['fecha_final'],
        idCliente: json['id_cliente'],
    );

    Map<String, dynamic> toJson() => {
        'conexion': conexion,
        'id_empresa': idEmpresa,
        'id_sucursal': idSucursal,
        'id_usuario': idUsuario,
        'id_empleado': idEmpleado,
        'fecha_inicio': fechaInicio,
        'fecha_final': fechaFinal,
        'id_cliente': idCliente,
    };
}
