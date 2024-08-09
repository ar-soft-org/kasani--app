import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:kasanipedido/helpers/storage/user_storage.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  loadVendorLogged() async {
    // TODO: Login Vendor
  }

  loadUserLogged() async {
    emit(AuthLoading());
    try {
      final hostJson = await UserStorage.getHost();
      if (hostJson != null) {
        final host = HostModel.fromJson(json.decode(hostJson));
        log(host.toJson().toString());
        emit(AuthSuccess(host: host));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
