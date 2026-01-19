// lib/handle/event_handle.dart
import 'handle_interface.dart';

/// Gestionnaire centralisé des événements
/// Encapsule EventBus pour une communication asynchrone uniforme
class EventHandle implements Handle {
  final Map<String, List<EventHandler>> _subscribers = {};

  @override
  void registerDefaults() {
    // Événements par défaut
    subscribe('api_success', _handleApiSuccess);
    subscribe('api_error', _handleApiError);
    subscribe('navigation_success', _handleNavigationSuccess);
    subscribe('component_error', _handleComponentError);
  }

  @override
  Future<void> execute(Map<String, dynamic> context) async {
    final eventType = context['eventType'] as String?;
    final payload = context['payload'];

    if (eventType != null) {
      publish(eventType, payload);
    }
  }

  @override
  bool validateContext(Map<String, dynamic> context) {
    return context.containsKey('eventType') && context['eventType'] is String;
  }

  @override
  void dispose() {
    _subscribers.clear();
  }

  /// S'abonne à un événement
  void subscribe(String eventType, EventHandler handler) {
    _subscribers.putIfAbsent(eventType, () => []).add(handler);
  }

  /// Se désabonne d'un événement
  void unsubscribe(String eventType, EventHandler handler) {
    _subscribers[eventType]?.remove(handler);
  }

  /// Publie un événement à tous les abonnés
  void publish(String eventType, dynamic payload) {
    if (_subscribers.containsKey(eventType)) {
      for (final handler in _subscribers[eventType]!) {
        try {
          handler(payload);
        } catch (e) {
          // Log l'erreur mais continue
          print('EventHandle: Error in handler for $eventType: $e');
        }
      }
    }
  }

  /// Gestionnaire d'événement par défaut pour succès API
  void _handleApiSuccess(dynamic payload) {
    print('EventHandle: API success - $payload');
    // Peut déclencher d'autres événements ou actions
  }

  /// Gestionnaire d'événement par défaut pour erreur API
  void _handleApiError(dynamic payload) {
    print('EventHandle: API error - $payload');
    // Peut afficher une notification d'erreur
  }

  /// Gestionnaire d'événement par défaut pour navigation réussie
  void _handleNavigationSuccess(dynamic payload) {
    print('EventHandle: Navigation success - $payload');
  }

  /// Gestionnaire d'événement par défaut pour erreur de composant
  void _handleComponentError(dynamic payload) {
    print('EventHandle: Component error - $payload');
    // Peut logger ou afficher une erreur
  }
}

/// Type pour les gestionnaires d'événements
typedef EventHandler = void Function(dynamic payload);
