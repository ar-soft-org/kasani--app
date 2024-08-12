import 'package:kasanipedido/data/services/client/client_service.dart';
import 'package:kasanipedido/domain/repository/client/client_api.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/domain/repository/client/models/client_request.dart';

class ClientApiImpl implements ClientApi {
  ClientApiImpl({
    required ClientService service,
  }) : _service = service;
  final ClientService _service;

  @override
  Future<List<Client>> fetchClients(ClientRequest data) {
    return _service.fetchClients(data);
  }
}
