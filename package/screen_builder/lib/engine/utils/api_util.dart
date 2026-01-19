// lib/engine/utils/api_util.dart
import '../../services/api/api_service.dart';
import '../../handle/event_handle.dart';

/// Utilitaires pour les opérations API génériques
/// Fournit des fonctions réutilisables pour les appels API
class ApiUtil {
  static final ApiService _apiService = ApiService();
  static final EventHandle _eventHandle = EventHandle();

  /// Exécute un appel GET générique
  static Future<Map<String, dynamic>?> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _apiService.get(endpoint, headers: headers);

      // Publier événement de succès
      _eventHandle.publish('api_success', {
        'endpoint': endpoint,
        'method': 'GET',
        'response': response.data,
      });

      return response.data;
    } catch (e) {
      // Publier événement d'erreur
      _eventHandle.publish('api_error', {
        'endpoint': endpoint,
        'method': 'GET',
        'error': e.toString(),
      });

      rethrow;
    }
  }

  /// Exécute un appel POST générique
  static Future<Map<String, dynamic>?> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response =
          await _apiService.post(endpoint, headers: headers, body: body);

      _eventHandle.publish('api_success', {
        'endpoint': endpoint,
        'method': 'POST',
        'response': response.data,
      });

      return response.data;
    } catch (e) {
      _eventHandle.publish('api_error', {
        'endpoint': endpoint,
        'method': 'POST',
        'error': e.toString(),
      });

      rethrow;
    }
  }

  /// Valide les paramètres d'un appel API
  static bool validateApiParams(String endpoint, {String? method}) {
    if (endpoint.isEmpty) return false;

    final validMethods = ['GET', 'POST'];
    if (method != null && !validMethods.contains(method.toUpperCase())) {
      return false;
    }

    return true;
  }

  /// Crée des headers par défaut
  static Map<String, String> createDefaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  /// Fusionne des headers personnalisés avec les headers par défaut
  static Map<String, String> mergeHeaders(
      [Map<String, String>? customHeaders]) {
    final headers = createDefaultHeaders();
    if (customHeaders != null) {
      headers.addAll(customHeaders);
    }
    return headers;
  }

  /// Gère les erreurs API de manière standardisée
  static String formatApiError(dynamic error) {
    if (error is Map<String, dynamic>) {
      return error['message'] ?? error['error'] ?? 'Unknown API error';
    } else if (error is String) {
      return error;
    } else {
      return 'API error: ${error.toString()}';
    }
  }
}
