part of 'host_home_cubit.dart';

enum HostHomeTab { home, history, cart, favorites, profile }

final class HostHomeState extends Equatable {
  const HostHomeState({
    this.tab = HostHomeTab.home,
  });

  final HostHomeTab tab;

  @override
  List<Object> get props => [tab];
}
