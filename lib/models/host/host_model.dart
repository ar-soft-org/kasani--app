// To parse this JSON data, do
//
//     final hostModel = hostModelFromJson(jsonString);

import 'dart:convert';

import 'package:kasanipedido/models/subsidiary/subsidiary_model.dart';

HostModel hostModelFromJson(String str) => HostModel.fromJson(json.decode(str));

String hostModelToJson(HostModel data) => json.encode(data.toJson());

class HostModel {
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
    final List<SubsidiaryModel> locales;
    final String token;
    // FIXME: Problemas con símbolos especiales (ñ)
    // final String requiereCambioContrasea;

    HostModel({
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
        required this.locales,
        required this.token,
        // required this.requiereCambioContrasea,
    });

    HostModel copyWith({
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
        List<SubsidiaryModel>? locales,
        String? token,
        String? requiereCambioContrasea,
    }) => 
        HostModel(
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
            locales: locales ?? this.locales,
            token: token ?? this.token,
            // requiereCambioContrasea: requiereCambioContrasea ?? this.requiereCambioContrasea,
        );

    factory HostModel.fromJson(Map<String, dynamic> json) => HostModel(
        codigo: json["codigo"],
        respuesta: json["respuesta"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        correo: json["correo"],
        nombreCliente: json["nombre_cliente"],
        conexion: json["conexion"],
        idEmpresa: json["id_empresa"],
        idSucursal: json["id_sucursal"],
        idUsuario: json["id_usuario"],
        idEmpleado: json["id_empleado"],
        idCliente: json["id_cliente"],
        locales: List<SubsidiaryModel>.from(json["locales"].map((x) => SubsidiaryModel.fromJson(x))),
        token: json["token"],
        // requiereCambioContrasea: json["requiere_cambio_contraseña"],
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "respuesta": respuesta,
        "nombres": nombres,
        "apellidos": apellidos,
        "correo": correo,
        "nombre_cliente": nombreCliente,
        "conexion": conexion,
        "id_empresa": idEmpresa,
        "id_sucursal": idSucursal,
        "id_usuario": idUsuario,
        "id_empleado": idEmpleado,
        "id_cliente": idCliente,
        "locales": List<dynamic>.from(locales.map((x) => x.toJson())),
        "token": token,
        // "requiere_cambio_contraseña": requiereCambioContrasea,
    };
}


