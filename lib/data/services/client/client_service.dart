import 'package:dio/dio.dart';
import 'package:kasanipedido/api/kasani.api/kasani_endpoints.dart';
import 'package:kasanipedido/domain/repository/client/client_api.dart';
import 'package:kasanipedido/domain/repository/client/models/client.dart';
import 'package:kasanipedido/domain/repository/client/models/client_request.dart';

class ClientService {
  ClientService({required Dio dio}) : _dio = dio;
  final Dio _dio;

  Future<List<Client>> fetchClients(ClientRequest data) async {
    const path = KasaniEndpoints.clients;

    try {
      final response = await _dio.post(
        path,
        data: data.toJson(),
      );

      return List<Client>.from(response.data.map((x) => Client.fromJson(x)));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw FetchClientException(
          e.response?.data['mensaje'] ?? 'An error occurred',
        );
      }

      throw FetchClientException('Something went wrong');
    }
  }
}
