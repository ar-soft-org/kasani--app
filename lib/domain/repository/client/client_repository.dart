import 'package:kasanipedido/domain/repository/client/client_api.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/domain/repository/client/models/client_request.dart';

class ClientRepository {
  ClientRepository({required ClientApi clientApi}) : _clientApi = clientApi;
  final ClientApi _clientApi;

  Future<List<Client>> fetchClients({required ClientRequest data}) =>
      _clientApi.fetchClients(data);
}
