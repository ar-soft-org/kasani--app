import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}

class AuthService {
  AuthService({required Dio dio}) : _dio = dio;
  final Dio _dio;

  forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        KasaniEndpoints.forgotPassword,
        data: {
          'usuario': email,
        },
      );

      if (response.data['codigo'] != '00') {
        throw AuthException(response.data['mensaje'] ?? 'An error occurred');
      }

      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data['mensaje'] ?? 'An error occurred';
      throw AuthException(message);
    }
  }
}
