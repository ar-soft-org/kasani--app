import 'package:kasanipedido/api/api.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:kasanipedido/models/host/host_model.dart';

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class AuthenticationRepository {
  Future<void> clientSignIn() {
    throw UnimplementedError();
  }

  Future<HostModel> loginHost(String email, String password) async {
    const path = KasaniEndpoints.loginHost;
    final headers = Api.generalHeaders();

    final response = await Api.post(
      path,
      headers: headers,
      data: {
        'usuario': email,
        'contraseña': password,
        'id_aplicacion': 3,
        'id_establecimiento': 64
      },
    );

    if (response['codigo'] == "99" && response['mensaje'] is String) {
      throw UnauthorizedException(response['mensaje'] ?? 'Unauthorized');
    }

    return HostModel.fromJson(response);
  }
}
