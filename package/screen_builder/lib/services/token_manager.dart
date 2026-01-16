/// Manager for tokens (auth, etc.)
class TokenManager {
  static String? _authToken;

  static void setAuthToken(String token) {
    _authToken = token;
  }

  static String? get authToken => _authToken;

  static void clearAuthToken() {
    _authToken = null;
  }
}
