import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:kasanipedido/helpers/storage/user_storage.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:kasanipedido/models/vendor/vendor_model.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.repository,
  }) : super(LoginInitial());

  final AuthenticationRepository repository;

  loginUser(String email, String password) async {
    emit(LoginLoading());

    try {
      final userMap = await repository.loginUser(email, password);

      if (userMap['id_empleado'] != null && userMap['id_empleado'] is String && userMap['id_empleado'].toString().isNotEmpty) {
        final vendor = VendorModel.fromJson(userMap);
        await UserStorage.setVendor(json.encode(vendor.toJson()));
        emit(LoginVendorSuccess(vendor));
      } else {
        final host = HostModel.fromJson(userMap);
        await UserStorage.setHost(json.encode(host.toJson()));
        emit(LoginHostSuccess(host));

      }
    } on UnauthorizedException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(LoginFailure(e.toString()));
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
