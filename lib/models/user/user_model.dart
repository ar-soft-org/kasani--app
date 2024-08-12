abstract class User {
  final String conexion;
  final String idEmpresa;
  final String idSucursal;
  final String idUsuario;
  final String token;
  final String requiereCambioContrasena;

  User({
    required this.conexion,
    required this.idEmpresa,
    required this.idSucursal,
    required this.idUsuario,
    required this.token,
    required this.requiereCambioContrasena,
  });
}
