import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class PasswordChangeRequiredException implements Exception {
  final String message;

  PasswordChangeRequiredException(this.message);
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);
}

class AuthenticationRepository {
  AuthenticationRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  Future<void> clientSignIn() {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    const path = KasaniEndpoints.loginHost;

    // Log de lo que se enviará al API
    print('Enviando solicitud POST a $path con datos: '
        '{usuario: $email, contraseña: $password, id_aplicacion: 3, id_establecimiento: 64}');

    final response = await _dio.post(
      path,
      data: {
        'usuario': email,
        'contraseña': password,
        'id_aplicacion': 3,
        'id_establecimiento': 64
      },
    );

    // Log de la respuesta del API
    print('Respuesta del API para $path: ${response.data}');
    print('Código de respuesta: ${response.data['codigo']}');

    if (response.data['codigo'] == '99' && response.data['mensaje'] is String) {
      throw UnauthorizedException(response.data['mensaje'] ?? 'Unauthorized');
    }

    // Si el código es "00", se comprueba si requiere cambio de contraseña
    if (response.data['codigo'] == '00') {
      final requiereCambioContrasena =
          response.data['requiere_cambio_contraseña'];
      if (requiereCambioContrasena == 'SI') {
        print('Código 00 recibido: Se requiere cambio de contraseña');
        throw PasswordChangeRequiredException('Cambio de contraseña requerido');
      } else {
        print('Código 00 recibido: No se requiere cambio de contraseña');
      }
    }

    return response.data;
  }

  Future<void> changePassword({
    required String userId,
    required String password,
    required String token,
  }) async {
    const path = KasaniEndpoints.changePassword;

    try {
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final requestPayload = {
        'id_usuario': userId.toString(),
        'contraseña': password.toString(),
      };

      print(
          'Enviando solicitud POST a $path con datos: $requestPayload y encabezado: $headers');

      final response = await _dio.post(
        path,
        data: requestPayload,
        options: Options(headers: headers),
      );

      print('Respuesta completa del API: ${response.data}');
      print('Tipo de response.data: ${response.data.runtimeType}');

      if (response.data is Map) {
        final codigo = response.data['codigo'];
        final mensaje = response.data['mensaje'];

        print('Código de respuesta: $codigo');
        print('Mensaje de respuesta: $mensaje');

        if (codigo == '99' && mensaje is String) {
          throw UnauthorizedException(mensaje);
        }
      } else {
        throw BadRequestException(
            'Formato de respuesta inesperado o vacío: ${response.data}');
      }
    } on DioException catch (e) {
      print(
          'DioException capturada. Detalles de la excepción: ${e.toString()}');
      print('Datos de respuesta de DioException: ${e.response?.data}');

      if (e.response?.data is Map) {
        String errorCode = e.response?.data['codigo'] ?? '';
        String errorMessage =
            e.response?.data['mensaje'] ?? e.message ?? 'Bad Request';

        final error =
            errorCode.isNotEmpty ? '$errorCode - $errorMessage' : errorMessage;
        print('Error en la solicitud POST a $path: $error');

        throw BadRequestException(error);
      } else {
        throw BadRequestException(
            'Respuesta inesperada o vacía: ${e.response?.data}');
      }
    }
  }
}
