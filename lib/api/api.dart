import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api {
  static Map<String, String> generalHeaders() {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
  }

  static Map<String, String> authHeaders(String token) {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  static dynamic decode(String response) => jsonDecode(response);

  static String encode(Map<String, dynamic>? response) => jsonEncode(response);

  // GET
  static Future<dynamic> get(
    String path, {
    Map<String, String>? headers,
  }) async {
    Uri uri = Uri.parse(path);
    final response = await http.get(uri, headers: headers);
    return decode(response.body);
  }

  // POST
  static Future<dynamic> post(
    String path, {
    Map<String, dynamic>? data = const {},
    Map<String, String>? headers,
  }) async {
    String body = encode(data);
    Map<String, String> headersSent = headers ?? generalHeaders();

    Uri uri = Uri.parse(path);
    final response = await http.post(
      uri,
      headers: headersSent,
      body: body,
    );
    return decode(response.body);
  }
}
