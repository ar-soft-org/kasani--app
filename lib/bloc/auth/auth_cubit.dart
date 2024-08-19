import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:kasanipedido/helpers/storage/user_storage.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:kasanipedido/models/vendor/vendor_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  loadVendorLogged() async {
    emit(AuthLoading());
    try {
      final vendorJson = await UserStorage.getVendor();
      if (vendorJson != null) {
        final vendor = VendorModel.fromJson(json.decode(vendorJson));
        log(vendor.toJson().toString());
        _deleteHostData();
        emit(AuthVendorSuccess(vendor: vendor));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  loadUserLogged() async {
    emit(AuthLoading());
    try {
      final hostJson = await UserStorage.getHost();
      if (hostJson != null) {
        final host = HostModel.fromJson(json.decode(hostJson));
        log(host.toJson().toString());
        _deleteVendorData();
        emit(AuthHostSuccess(host: host));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  deleteUserData() async {
    emit(AuthLoading());
    try {
      await UserStorage.deleteHost();
      await UserStorage.deleteVendor();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  _deleteHostData() async {
    await UserStorage.deleteHost();
  }

  _deleteVendorData() async {
    await UserStorage.deleteVendor();
  }

  
}
