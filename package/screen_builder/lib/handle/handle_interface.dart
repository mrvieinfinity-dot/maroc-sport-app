// lib/handle/handle_interface.dart
import 'action_handle.dart';
import 'event_handle.dart';
import 'navigation_handle.dart';

/// Interface commune pour tous les gestionnaires (handlers)
/// Fournit une API uniforme pour actions, événements et navigation

abstract class Handle {
  /// Enregistre les gestionnaires par défaut
  void registerDefaults();

  /// Exécute une opération avec le contexte fourni
  Future<void> execute(Map<String, dynamic> context);

  /// Valide le contexte avant exécution
  bool validateContext(Map<String, dynamic> context);

  /// Nettoie les ressources
  void dispose();
}

/// Types d'handlers disponibles
enum HandleType {
  action,
  event,
  navigation,
}

/// Factory pour créer des handlers
class HandleFactory {
  static Handle create(HandleType type) {
    switch (type) {
      case HandleType.action:
        return ActionHandle();
      case HandleType.event:
        return EventHandle();
      case HandleType.navigation:
        return NavigationHandle();
    }
  }
}
