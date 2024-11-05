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
    print('Intentando iniciar sesión con el usuario: $email');

    try {
      final userMap = await repository.loginUser(email, password);
      print('Respuesta del servidor: $userMap');

      final userId = userMap['userId'] ?? '';
      final token = userMap['token'] ?? '';

      if (userMap['requiereCambioContrasena'] == true) {
        if (userId.isNotEmpty && token.isNotEmpty) {
          print('Cambio de contraseña requerido para el usuario $userId');
          emit(LoginPasswordChangeRequired(userId, token));
        } else {
          print('Error: userId o token no asignados correctamente.');
          emit(LoginFailure('Datos incompletos para cambio de contraseña.'));
        }
        return;
      }

      if (userMap['id_empleado'] != null && userMap['id_empleado'].isNotEmpty) {
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
        print('No se pudo identificar el tipo de usuario.');
        emit(LoginFailure('No se pudo identificar el tipo de usuario.'));
      }
    } catch (e) {
      print('Error en el inicio de sesión: ${e.toString()}');
      emit(LoginFailure('Ocurrió un error en el inicio de sesión'));
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



