import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class CreateOrderResponse {
  final String codigo;
  final String mensaje;
  final List<ProductData> productos;
  final String dtFechaEntrega;
  final String vcHoraEntrega;
  final String nombreLocal;

  CreateOrderResponse({
    required this.codigo,
    required this.mensaje,
    required this.productos,
    required this.dtFechaEntrega,
    required this.vcHoraEntrega,
    required this.nombreLocal,
  });

  CreateOrderResponse copyWith({
    String? codigo,
    String? mensaje,
    List<ProductData>? productos,
    String? dtFechaEntrega,
    String? vcHoraEntrega,
    String? nombreLocal,
  }) {
    return CreateOrderResponse(
      codigo: codigo ?? this.codigo,
      mensaje: mensaje ?? this.mensaje,
      productos: productos ?? this.productos,
      dtFechaEntrega: dtFechaEntrega ?? this.dtFechaEntrega,
      vcHoraEntrega: vcHoraEntrega ?? this.vcHoraEntrega,
      nombreLocal: nombreLocal ?? this.nombreLocal,
    );
  }

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      codigo: json['codigo'],
      mensaje: json['mensaje'],
      productos: List<ProductData>.from(
        json['productos'].map((x) => ProductData.fromJson(x))
      ),
      dtFechaEntrega: json['dt_fecha_entrega'],
      vcHoraEntrega: json['vc_hora_entrega'],
      nombreLocal: json['nombre_local'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'mensaje': mensaje,
      'productos': List<dynamic>.from(productos.map((x) => x.toJson())),
      'dt_fecha_entrega': dtFechaEntrega,
      'vc_hora_entrega': vcHoraEntrega,
      'nombre_local': nombreLocal,
    };
  }
}