import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(
    AuthenticationRepository repository,
  )   : _repository = repository,
        super(ChangePasswordInitial());

  final AuthenticationRepository _repository;

  changePassword(String userId, String password) async {
    emit(ChangePasswordLoading());
    try {
      await _repository.changePassword(
        userId: userId,
        password: password,
      );
      emit(ChangePasswordSuccess());
    } on BadRequestException catch (e) {
      emit(ChangePasswordFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      emit(ChangePasswordFailure(message: e.message));
    } catch (e) {
      emit(ChangePasswordFailure(message: e.toString()));
    }
  }
}
