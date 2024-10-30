import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}

class AuthService {
  AuthService({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        KasaniEndpoints.forgotPassword,
        data: {
          'usuario': email,
        },
      );

      print('Respuesta del API para forgotPassword: ${response.data}');
      final codigo = response.data['codigo'];
      final mensaje = response.data['mensaje'] ?? 'Error desconocido';

      if (codigo != '00') {
        throw AuthException(mensaje); 
      }

      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data['mensaje'] ?? 'An error occurred';
      throw AuthException(message);
    }
  }
}
