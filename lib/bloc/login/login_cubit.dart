import 'package:bloc/bloc.dart';
import 'package:kasanipedido/helpers/storage/user_storage.dart';
import 'package:kasanipedido/models/host/host_model.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.repository,
  }) : super(LoginInitial());

  final AuthenticationRepository repository;

  loginHost(String email, String password) async {
    emit(LoginLoading());

    try {
      final host = await repository.loginHost(email, password);
      await UserStorage.setHost(host.toJson().toString());
      final newState = LoginSuccess(host);
      emit(newState);
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
}
