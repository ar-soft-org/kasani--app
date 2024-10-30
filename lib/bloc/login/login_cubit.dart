import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:kasanipedido/helpers/storage/user_storage.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:kasanipedido/models/vendor/vendor_model.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository repository;

  LoginCubit({required this.repository}) : super(LoginInitial());

  loginUser(String email, String password) async {
    emit(LoginLoading());

    try {
      final userMap = await repository.loginUser(email, password);
      final token = userMap['token'] ?? '';

      if (userMap['requiere_cambio_contraseña'] == 'SI') {
        final userId = userMap['id_usuario'] ?? '';
        emit(LoginPasswordChangeRequired(userId, token));
        return;
      }

      if (userMap['id_empleado'] != null && userMap['id_empleado'] is String && userMap['id_empleado'].isNotEmpty) {
        final vendor = VendorModel.fromJson(userMap);
        await UserStorage.setVendor(json.encode(vendor.toJson()));
        print('Usuario autenticado como Vendor: ${vendor.toJson()}');
        emit(LoginVendorSuccess(vendor));
      } else if (userMap['nombre_cliente'] != null && userMap['nombre_cliente'].isNotEmpty) {
        final host = HostModel.fromJson(userMap);
        await UserStorage.setHost(json.encode(host.toJson()));
        print('Usuario autenticado como Cliente (Host): ${host.toJson()}');
        emit(LoginHostSuccess(host));
      } else {
        emit(LoginFailure('No se pudo identificar el tipo de usuario.'));
      }
    } catch (e) {
      String errorMessage = 'Ocurrió un error en el inicio de sesión';
      if (e is DioException && e.response?.data is Map) {
        final responseData = e.response?.data;
        errorMessage = responseData['mensaje'] ?? errorMessage;
        print('Respuesta del servidor: $responseData');
      }

      emit(LoginFailure(errorMessage));
    }
  }

  logoutHost() async {
    emit(LoginLoading());
    await UserStorage.deleteHost();
    emit(LoginLogout());
  }

  logoutVendor() async {
    emit(LoginLoading());
    await UserStorage.deleteVendor();
    emit(LoginLogout());
  }
}
