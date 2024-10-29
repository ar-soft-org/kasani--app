import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/repositories/authentication_repository.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthenticationRepository _repository;
  final String token; 

  ChangePasswordCubit({
    required AuthenticationRepository repository,
    required this.token,
  }) : _repository = repository, super(ChangePasswordInitial());

  Future<void> changePassword(String userId, String password) async {
    emit(ChangePasswordLoading());
    try {
      await _repository.changePassword(
        userId: userId,
        password: password,
        token: token,
      );
      emit(ChangePasswordSuccess());
    } on BadRequestException catch (e) {
      final errorMessage = e.message ?? 'Ocurrió un error en la solicitud';
      emit(ChangePasswordFailure(message: errorMessage));
    } on UnauthorizedException catch (e) {
      final errorMessage = e.message ?? 'Acceso no autorizado';
      emit(ChangePasswordFailure(message: errorMessage));
    } catch (e) {
      final errorMessage = e.toString();
      emit(ChangePasswordFailure(message: errorMessage));
    }
  }
}
