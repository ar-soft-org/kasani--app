import 'dart:convert';

VendorModel vendorFromJson(String str) =>
    VendorModel.fromJson(json.decode(str));

String vendorToJson(VendorModel data) => json.encode(data.toJson());

class VendorModel {
  final String codigo;
  final String respuesta;
  final String nombres;
  final String apellidos;
  final String correo;
  final String nombreCliente;
  final String conexion;
  final String idEmpresa;
  final String idSucursal;
  final String idUsuario;
  final String idEmpleado;
  final String idCliente;
  final String token;
  final String requiereCambioContrasena;

  VendorModel({
    required this.codigo,
    required this.respuesta,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.nombreCliente,
    required this.conexion,
    required this.idEmpresa,
    required this.idSucursal,
    required this.idUsuario,
    required this.idEmpleado,
    required this.idCliente,
    required this.token,
    required this.requiereCambioContrasena,
  });

  VendorModel copyWith({
    String? codigo,
    String? respuesta,
    String? nombres,
    String? apellidos,
    String? correo,
    String? nombreCliente,
    String? conexion,
    String? idEmpresa,
    String? idSucursal,
    String? idUsuario,
    String? idEmpleado,
    String? idCliente,
    String? token,
    String? requiereCambioContrasea,
  }) =>
      VendorModel(
        codigo: codigo ?? this.codigo,
        respuesta: respuesta ?? this.respuesta,
        nombres: nombres ?? this.nombres,
        apellidos: apellidos ?? this.apellidos,
        correo: correo ?? this.correo,
        nombreCliente: nombreCliente ?? this.nombreCliente,
        conexion: conexion ?? this.conexion,
        idEmpresa: idEmpresa ?? this.idEmpresa,
        idSucursal: idSucursal ?? this.idSucursal,
        idUsuario: idUsuario ?? this.idUsuario,
        idEmpleado: idEmpleado ?? this.idEmpleado,
        idCliente: idCliente ?? this.idCliente,
        token: token ?? this.token,
        requiereCambioContrasena:
            requiereCambioContrasea ?? this.requiereCambioContrasena,
      );

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
        codigo: json['codigo'],
        respuesta: json['respuesta'],
        nombres: json['nombres'],
        apellidos: json['apellidos'],
        correo: json['correo'],
        nombreCliente: json['nombre_cliente'],
        conexion: json['conexion'],
        idEmpresa: json['id_empresa'],
        idSucursal: json['id_sucursal'],
        idUsuario: json['id_usuario'],
        idEmpleado: json['id_empleado'],
        idCliente: json['id_cliente'],
        token: json['token'],
        requiereCambioContrasena: json['requiere_cambio_contraseña'],
      );

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'respuesta': respuesta,
        'nombres': nombres,
        'apellidos': apellidos,
        'correo': correo,
        'nombre_cliente': nombreCliente,
        'conexion': conexion,
        'id_empresa': idEmpresa,
        'id_sucursal': idSucursal,
        'id_usuario': idUsuario,
        'id_empleado': idEmpleado,
        'id_cliente': idCliente,
        'token': token,
        'requiere_cambio_contraseña': requiereCambioContrasena,
      };
}
