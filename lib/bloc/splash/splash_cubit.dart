import 'package:bloc/bloc.dart';
import 'package:kasanipedido/helpers/storage/user_storage.dart';
import 'package:meta/meta.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  validateLocalSession() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));
    final hostJson = await UserStorage.getHost();
    final vendorJson = await UserStorage.getVendor();
  
    if (hostJson != null) {
      emit(SplashHostSuccess(logedIn: true));
    } else if (vendorJson != null) {
      emit(SplashVendorSuccess(logedIn: true));
    } else {
      emit(SplashHostSuccess(logedIn: false));
    }
    
  }
}
