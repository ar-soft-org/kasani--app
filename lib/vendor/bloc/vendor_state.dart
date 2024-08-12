part of 'vendor_bloc.dart';

enum VendorStatus { initial, loading, loaded, error }

class VendorState extends Equatable {
  const VendorState({
    this.status = VendorStatus.initial,
    this.clients = const [],
    this.errorMessage,
  });

  final VendorStatus status;
  final List<Client> clients;
  final String? errorMessage;

  VendorState copyWith({
    VendorStatus? status,
    List<Client>? clients,
    String? Function()? errorMessage,
  }) {
    return VendorState(
      status: status ?? this.status,
      clients: clients ?? this.clients,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        clients,
        errorMessage,
      ];
}

extension VendorStateX on VendorState {
  bool get isLoading => status == VendorStatus.loading;
  bool get isLoaded => status == VendorStatus.loaded;
  bool get isError => status == VendorStatus.error;
}
