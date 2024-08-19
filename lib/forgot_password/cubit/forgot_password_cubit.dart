import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/data/services/auth/auth_service.dart';
import 'package:kasanipedido/domain/repository/auth/auth_repository.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const ForgotPasswordState());

  final AuthRepository _authRepository;

  void submitEmail(String email) async {
    try {
      await _authRepository.forgotPassword(email);

      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } on AuthException catch (_) {
      emit(state.copyWith(status: ForgotPasswordStatus.error));
    }
  }
}
