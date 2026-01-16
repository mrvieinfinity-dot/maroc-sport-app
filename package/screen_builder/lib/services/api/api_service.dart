import 'api_client.dart';
import '../../models/api_request.dart';
import '../../models/api_response.dart';

/// Service for API operations
class ApiService {
  final ApiClient _client = ApiClient();

  static ApiService? _instance;

  static void setInstance(ApiService service) {
    _instance = service;
  }

  static ApiService? get instance => _instance;

  Future<ApiResponse> get(String url, {Map<String, String>? headers}) async {
    final request = ApiRequest(method: 'GET', url: url, headers: headers);
    final response = await _client.send(request);
    return ApiResponse(
      statusCode: response.statusCode,
      data: response.body,
      headers: response.headers,
    );
  }

  Future<ApiResponse> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    final request =
        ApiRequest(method: 'POST', url: url, headers: headers, body: body);
    final response = await _client.send(request);
    return ApiResponse(
      statusCode: response.statusCode,
      data: response.body,
      headers: response.headers,
    );
  }

  // Add PUT, DELETE similarly
}
