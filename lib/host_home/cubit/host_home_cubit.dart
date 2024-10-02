import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'host_home_state.dart';

class HostHomeCubit extends Cubit<HostHomeState> {
  HostHomeCubit() : super(const HostHomeState());

  void setTab(HostHomeTab tab) => emit(HostHomeState(tab: tab));
}
