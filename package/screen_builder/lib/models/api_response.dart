/// Model for an API response
class ApiResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String>? headers;

  ApiResponse({required this.statusCode, this.data, this.headers});
}
