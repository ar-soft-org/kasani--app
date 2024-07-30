import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class CreateOrderRequest {
  final String conexion;
  final String idEmpresa;
  final String idSucursal;
  final String idUsuario;
  final String idEmpleado;
  final String idCliente;
  final String usuario;
  final String idLocal;
  final String fechaEntrega;
  final String horaEntrega;
  final String observacion;
  final List<ProductData> productos;

  CreateOrderRequest({
    required this.conexion,
    required this.idEmpresa,
    required this.idSucursal,
    required this.idUsuario,
    required this.idEmpleado,
    required this.idCliente,
    required this.usuario,
    required this.idLocal,
    required this.fechaEntrega,
    required this.horaEntrega,
    required this.observacion,
    required this.productos,
  });

  CreateOrderRequest copyWith({
    String? conexion,
    String? idEmpresa,
    String? idSucursal,
    String? idUsuario,
    String? idEmpleado,
    String? idCliente,
    String? usuario,
    String? idLocal,
    String? fechaEntrega,
    String? horaEntrega,
    String? observacion,
    List<ProductData>? productos,
  }) {
    return CreateOrderRequest(
      conexion: conexion ?? this.conexion,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idSucursal: idSucursal ?? this.idSucursal,
      idUsuario: idUsuario ?? this.idUsuario,
      idEmpleado: idEmpleado ?? this.idEmpleado,
      idCliente: idCliente ?? this.idCliente,
      usuario: usuario ?? this.usuario,
      idLocal: idLocal ?? this.idLocal,
      fechaEntrega: fechaEntrega ?? this.fechaEntrega,
      horaEntrega: horaEntrega ?? this.horaEntrega,
      observacion: observacion ?? this.observacion,
      productos: productos ?? this.productos,
    );
  }

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    return CreateOrderRequest(
      conexion: json['conexion'],
      idEmpresa: json['id_empresa'],
      idSucursal: json['id_sucursal'],
      idUsuario: json['id_usuario'],
      idEmpleado: json['id_empleado'],
      idCliente: json['id_cliente'],
      usuario: json['usuario'],
      idLocal: json['id_local'],
      fechaEntrega: json['fecha_entrega'],
      horaEntrega: json['hora_entrega'],
      observacion: json['observacion'],
      productos: List<ProductData>.from(
          json['productos'].map((x) => ProductData.fromJson(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conexion': conexion,
      'id_empresa': idEmpresa,
      'id_sucursal': idSucursal,
      'id_usuario': idUsuario,
      'id_empleado': idEmpleado,
      'id_cliente': idCliente,
      'usuario': usuario,
      'id_local': idLocal,
      'fecha_entrega': fechaEntrega,
      'hora_entrega': horaEntrega,
      'observacion': observacion,
      'productos': List<dynamic>.from(productos.map((x) => x.toJson())),
    };
  }
}
