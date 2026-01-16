/// Model for an API request
class ApiRequest {
  final String method;
  final String url;
  final Map<String, String>? headers;
  final dynamic body;

  ApiRequest(
      {required this.method, required this.url, this.headers, this.body});
}
