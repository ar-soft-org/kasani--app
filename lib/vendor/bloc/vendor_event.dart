part of 'vendor_bloc.dart';

sealed class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object> get props => [];
}

class VendorInitialEvent extends VendorEvent {}

class LoadClientsEvent extends VendorEvent {
  final VendorModel vendor;

  const LoadClientsEvent({required this.vendor});
}
class SelectClientEvent extends VendorEvent {
  final Client client;

  const SelectClientEvent({required this.client});
}
