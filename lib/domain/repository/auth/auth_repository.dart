import 'package:kasanipedido/data/services/auth/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<void> forgotPassword(String email) async {
    await _authService.forgotPassword(email);
  }
}
