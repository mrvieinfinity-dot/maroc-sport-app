/// Validator for security concerns
class SecurityValidator {
  /// Validates data for security
  static bool validate(dynamic data) {
    if (data is String) {
      // Check for potentially dangerous scripts or URLs
      if (data.contains('<script') || data.contains('javascript:')) {
        return false;
      }
      // TODO: Validate URLs against allowlist if needed
    }
    return true;
  }

  /// Validates a URL
  static bool validateUrl(String url) {
    // Basic URL validation
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }
}
