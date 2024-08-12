import 'dart:convert';

import 'subsidiary.dart';

List<Client> clientFromJson(String str) =>
    List<Client>.from(json.decode(str).map((x) => Client.fromJson(x)));

String clientToJson(List<Client> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Client {
  final String idCliente;
  final String tipoDocumento;
  final String documento;
  final String nombres;
  final String encargado;
  final String pedidoHoy;
  final String usuario;
  final List<Subsidiary> locales;

  Client({
    required this.idCliente,
    required this.tipoDocumento,
    required this.documento,
    required this.nombres,
    required this.encargado,
    required this.pedidoHoy,
    required this.usuario,
    required this.locales,
  });

  Client copyWith({
    String? idCliente,
    String? tipoDocumento,
    String? documento,
    String? nombres,
    String? encargado,
    String? pedidoHoy,
    String? usuario,
    List<Subsidiary>? locales,
  }) =>
      Client(
        idCliente: idCliente ?? this.idCliente,
        tipoDocumento: tipoDocumento ?? this.tipoDocumento,
        documento: documento ?? this.documento,
        nombres: nombres ?? this.nombres,
        encargado: encargado ?? this.encargado,
        pedidoHoy: pedidoHoy ?? this.pedidoHoy,
        usuario: usuario ?? this.usuario,
        locales: locales ?? this.locales,
      );

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        idCliente: json['id_cliente'],
        tipoDocumento: json['tipo_documento'],
        documento: json['documento'],
        nombres: json['nombres'],
        encargado: json['encargado'],
        pedidoHoy: json['pedido_hoy'],
        usuario: json['usuario'],
        locales: List<Subsidiary>.from(
            json['locales'].map((x) => Subsidiary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'id_cliente': idCliente,
        'tipo_documento': tipoDocumento,
        'documento': documento,
        'nombres': nombres,
        'encargado': encargado,
        'pedido_hoy': pedidoHoy,
        'usuario': usuario,
        'locales': List<dynamic>.from(locales.map((x) => x.toJson())),
      };
}
