
class FavoriteProductsRequest {
    final String conexion;
    final String idEmpresa;
    final String idSucursal;
    final String idUsuario;
    final String idEmpleado;
    final String idCliente;

    FavoriteProductsRequest({
        required this.conexion,
        required this.idEmpresa,
        required this.idSucursal,
        required this.idUsuario,
        required this.idEmpleado,
        required this.idCliente,
    });

    Map<String, dynamic> toJson() => {
        "conexion": conexion,
        "id_empresa": idEmpresa,
        "id_sucursal": idSucursal,
        "id_usuario": idUsuario,
        "id_empleado": idEmpleado,
        "id_cliente": idCliente,
    };
}
