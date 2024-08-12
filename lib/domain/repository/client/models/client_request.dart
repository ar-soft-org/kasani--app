class ClientRequest {
  final String conexion;
  final String idEmpresa;
  final String idSucursal;
  final String idUsuario;
  final String idEmpleado;

  ClientRequest({
    required this.conexion,
    required this.idEmpresa,
    required this.idSucursal,
    required this.idUsuario,
    required this.idEmpleado,
  });

  Map<String, dynamic> toJson() => {
        'conexion': conexion,
        'id_empresa': idEmpresa,
        'id_sucursal': idSucursal,
        'id_usuario': idUsuario,
        'id_empleado': idEmpleado,
      };
}
