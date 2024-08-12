import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/domain/repository/client/models/client_request.dart';

class FetchClientException implements Exception {
  final String message;

  FetchClientException(this.message);
}

abstract class ClientApi {
  Future<List<Client>> fetchClients(ClientRequest data);
}
