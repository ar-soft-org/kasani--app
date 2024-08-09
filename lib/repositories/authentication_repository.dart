import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:kasanipedido/models/host/host_model.dart';

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
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

  // TODO: Login Vendor
  Future<HostModel> loginVendor(String email, String password) async {
    const path = KasaniEndpoints.loginHost;

    final response = await _dio.post(
      path,
      data: {
        'usuario': email,
        'contraseña': password,
        'id_aplicacion': 3,
        'id_establecimiento': 64
      },
    );

    if (response.data['codigo'] == '99' && response.data['mensaje'] is String) {
      throw UnauthorizedException(response.data['mensaje'] ?? 'Unauthorized');
    }

    return HostModel.fromJson(response.data);
  }

  Future<HostModel> loginHost(String email, String password) async {
    const path = KasaniEndpoints.loginHost;

    final response = await _dio.post(
      path,
      data: {
        'usuario': email,
        'contraseña': password,
        'id_aplicacion': 3,
        'id_establecimiento': 64
      },
    );

    if (response.data['codigo'] == '99' && response.data['mensaje'] is String) {
      throw UnauthorizedException(response.data['mensaje'] ?? 'Unauthorized');
    }

    return HostModel.fromJson(response.data);
  }

  Future<void> changePassword({
    required String userId,
    required String password,
  }) async {
    // TODO: move to service
    const path = KasaniEndpoints.changePassword;

    try {
      final response = await _dio.post(
        path,
        data: {
          'id_usuario': userId,
          'contraseña': password,
        },
      );

      if (response.data['codigo'] == '99' &&
          response.data['mensaje'] is String) {
        throw UnauthorizedException(response.data['mensaje'] ?? 'Unauthorized');
      }
    } on DioException catch (e) {
      String error = e.response?.data['codigo'] ?? '';
      error += error.isEmpty ? '' : ' - ';
      error += e.response?.data['mensaje'] ?? e.message ?? 'Bad Request';
      throw BadRequestException(
        error,
      );
    }
  }
}
