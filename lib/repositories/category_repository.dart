import 'dart:developer';

import 'package:kasanipedido/api/api.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:kasanipedido/models/category/category_model.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';

class CategoryRepository {
  Future<List<CategoryModel>> fetchCategoriesSubCategories({
    required String token,
    String? conexion,
    String? idEmpresa,
    String? idSucursal,
    String? idUsuario,
    String? idEmpleado,
  }) async {
    log(token);
    const path = KasaniEndpoints.categoriesSubcategories;
    final headers = Api.authHeaders(token);

    final response = await Api.post(
      path,
      headers: headers,
      data: {
        'conexion': conexion,
        'id_empresa': idEmpresa,
        'id_sucursal': idSucursal,
        'id_usuario': idUsuario,
        'id_empelado': idEmpleado,
      },
    );

    if (response is! List &&
        response['codigo'] == "99" &&
        response['mensaje'] is String) {
      throw UnauthorizedException(response['mensaje'] ?? 'Unauthorized');
    }

    return (response as List<dynamic>)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }
}
