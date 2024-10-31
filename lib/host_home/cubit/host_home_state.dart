part of 'host_home_cubit.dart';

enum HostHomeTab { home, history, cart, favorites, profile, continueHome,historyDetail }

final class HostHomeState extends Equatable {
  const HostHomeState({
    this.tab = HostHomeTab.home,
    this.isBottomBarVisible = true,
  });

  final HostHomeTab tab;
  final bool isBottomBarVisible;

  HostHomeState copyWith({
    HostHomeTab? tab,
    bool? isBottomBarVisible,
  }) {
    return HostHomeState(
      tab: tab ?? this.tab,
      isBottomBarVisible: isBottomBarVisible ?? true, 
    );
  }

  @override
  List<Object> get props => [tab, isBottomBarVisible];
}
