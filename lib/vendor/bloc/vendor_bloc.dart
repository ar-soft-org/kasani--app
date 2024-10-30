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
      print('LoadClientsEvent triggered'); // Log para indicar que el evento fue disparado
      emit(state.copyWith(status: VendorStatus.loading));
      print('Vendor status set to loading'); // Log del cambio de estado

      final vendor = event.vendor;
      print('Fetching clients for vendor: ${vendor.idUsuario}'); // Log con el ID del usuario del vendor
      
      // Fetch clients del repositorio
      final list = await _clientRepository.fetchClients(
          data: ClientRequest(
        conexion: vendor.conexion,
        idEmpleado: vendor.idEmpleado,
        idEmpresa: vendor.idEmpresa,
        idSucursal: vendor.idSucursal,
        idUsuario: vendor.idUsuario,
      ));

      print('Fetched clients list: $list'); // Log para mostrar los clientes recuperados

      emit(state.copyWith(
        status: VendorStatus.loaded,
        clients: list,
      ));
      print('Vendor status set to loaded with clients'); 

    } on FetchClientException catch (e) {
      print('Error fetching clients: ${e.message}');

      emit(state.copyWith(
        status: VendorStatus.error,
        errorMessage: () => e.message,
      ));
      
      // Reinicia el mensaje de error después de un tiempo
      emit(state.copyWith(
        errorMessage: () => null,
      ));
      print('Error message reset'); // Log indicando que el mensaje de error fue reiniciado
    }
  }

  _onSelectClientEvent(
    SelectClientEvent event,
    Emitter<VendorState> emit,
  ) {
    print('SelectClientEvent triggered'); // Log para indicar que el evento fue disparado
    emit(state.copyWith(currentClient: () => null));
    print('Current client cleared'); // Log para indicar que el cliente actual fue limpiado
    
    emit(state.copyWith(
      currentClient: () => event.client,
    ));
    print('Client selected: ${event.client}'); // Log con el cliente seleccionado
  }
}
