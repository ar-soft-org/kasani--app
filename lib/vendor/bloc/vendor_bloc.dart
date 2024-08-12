import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kasanipedido/domain/repository/client/client_api.dart';
import 'package:kasanipedido/domain/repository/client/client_repository.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/domain/repository/client/models/client_request.dart';
import 'package:kasanipedido/models/vendor/vendor_model.dart';

part 'vendor_event.dart';
part 'vendor_state.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  VendorBloc({
    required ClientRepository clientRepository,
  })  : _clientRepository = clientRepository,
        super(const VendorState()) {
    on<LoadClientsEvent>(_onLoadClientsEvent);
    on<SelectClientEvent>(_onSelectClientEvent);
  }

  final ClientRepository _clientRepository;

  _onLoadClientsEvent(
    LoadClientsEvent event,
    Emitter<VendorState> emit,
  ) async {
    try {
      emit(state.copyWith(status: VendorStatus.loading));

      final vendor = event.vendor;
      final list = await _clientRepository.fetchClients(
          data: ClientRequest(
        conexion: vendor.conexion,
        idEmpleado: vendor.idEmpleado,
        idEmpresa: vendor.idEmpresa,
        idSucursal: vendor.idSucursal,
        idUsuario: vendor.idUsuario,
      ));

      emit(state.copyWith(
        status: VendorStatus.loaded,
        clients: list,
      ));
    } on FetchClientException catch (e) {
      emit(state.copyWith(
        status: VendorStatus.error,
        errorMessage: () => e.message,
      ));

      emit(state.copyWith(
        errorMessage: () => null,
      ));
    }
  }

  _onSelectClientEvent(
    SelectClientEvent event,
    Emitter<VendorState> emit,
  ) {
    emit(state.copyWith(
      currentClient: () => null,
    ));
    emit(state.copyWith(
      currentClient: () => event.client,
    ));
  }
}
