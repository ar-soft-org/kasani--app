part of 'vendor_bloc.dart';

enum VendorStatus { initial, loading, loaded, error }

class VendorState extends Equatable {
  const VendorState({
    this.status = VendorStatus.initial,
    this.clients = const [],
    this.errorMessage,
    this.currentClient,
  });

  final VendorStatus status;
  final List<Client> clients;
  final Client? currentClient;
  final String? errorMessage;

  VendorState copyWith({
    VendorStatus? status,
    List<Client>? clients,
    String? Function()? errorMessage,
    Client? Function()? currentClient,
  }) {
    return VendorState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      currentClient: currentClient != null ? currentClient() : this.currentClient,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clients,
        errorMessage,
        currentClient,
      ];
}

extension VendorStateX on VendorState {
  bool get isLoading => status == VendorStatus.loading;
  bool get isLoaded => status == VendorStatus.loaded;
  bool get isError => status == VendorStatus.error;
}
