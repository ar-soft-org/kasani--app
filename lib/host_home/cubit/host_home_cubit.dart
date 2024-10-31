import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'host_home_state.dart';

class HostHomeCubit extends Cubit<HostHomeState> {
  HostHomeCubit() : super(const HostHomeState(isBottomBarVisible: true));

  Map<String, dynamic>? _arguments;

  void setTab(HostHomeTab tab) {
    bool shouldShowBottomBar = tab != HostHomeTab.cart;
    emit(state.copyWith(tab: tab, isBottomBarVisible: shouldShowBottomBar));
  }

  void setBottomBarVisibility(bool isVisible) {
    emit(state.copyWith(isBottomBarVisible: isVisible));
  }

  void setArguments(Map<String, dynamic> arguments) {
    _arguments = arguments;
  }

  Map<String, dynamic>? getArguments() => _arguments;
}
