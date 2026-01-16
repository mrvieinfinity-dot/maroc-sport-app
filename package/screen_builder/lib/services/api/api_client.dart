import 'package:http/http.dart' as http;
import '../../models/api_request.dart';

/// HTTP client wrapper
class ApiClient {
  final http.Client _client = http.Client();

  Future<http.Response> send(ApiRequest request) async {
    final uri = Uri.parse(request.url);
    switch (request.method.toUpperCase()) {
      case 'GET':
        return _client.get(uri, headers: request.headers);
      case 'POST':
        return _client.post(uri, headers: request.headers, body: request.body);
      case 'PUT':
        return _client.put(uri, headers: request.headers, body: request.body);
      case 'DELETE':
        return _client.delete(uri, headers: request.headers);
      default:
        throw UnsupportedError('Method ${request.method} not supported');
    }
  }
}
