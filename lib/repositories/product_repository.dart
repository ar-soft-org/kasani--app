import 'package:kasanipedido/api/api.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:shopping_cart_repository/shopping_cart_repository.dart';

class ProductRepository {
  Future<dynamic> fetchProducts({
    required String token,
    String? conexion,
    String? idEmpresa,
    String? idSucursal,
    String? idUsuario,
    String? idEmpleado,
  }) async {
    const path = KasaniEndpoints.products;
    final headers = Api.authHeaders(token);

    final response = await Api.post(
      path,
      headers: headers,
      data: {
        'conexion': conexion,
        'id_empresa': idEmpresa,
        'id_sucursal': idSucursal,
        'id_usuario': idUsuario,
        'id_empleado': idEmpleado,
      },
    );

    if (response is! List &&
        response['codigo'] == "99" &&
        response['mensaje'] is String) {
      throw UnauthorizedException(response['mensaje'] ?? 'Unauthorized');
    }

    return (response as List<dynamic>)
        .map((e) => Product.fromJson(e))
        .toList();
  }
}
