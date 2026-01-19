// lib/handle/action_handle.dart
import 'handle_interface.dart';
import 'event_handle.dart';
import 'navigation_handle.dart';
import '../services/token_manager.dart';
import '../services/api/api_service.dart';

/// Gestionnaire centralisé des actions utilisateur
/// Gère navigate, api, custom et autres actions de manière uniforme
class ActionHandle implements Handle {
  final Map<String, ActionExecutor> _actions = {};
  final TokenManager _tokenManager;
  final ApiService _apiService;

  ActionHandle({
    TokenManager? tokenManager,
    ApiService? apiService,
  })  : _tokenManager = tokenManager ?? TokenManager(),
        _apiService = apiService ?? ApiService();

  @override
  void registerDefaults() {
    // Actions par défaut
    register('navigate', _executeNavigate);
    register('api_get', _executeApiGet);
    register('api_post', _executeApiPost);
    register('custom', _executeCustom);
    register('show_popup', _executeShowPopup);
    register('log', _executeLog);
  }

  @override
  Future<void> execute(Map<String, dynamic> context) async {
    final actionType = context['action'] as String?;
    final actionData = context['data'] ?? {};

    if (actionType != null && _actions.containsKey(actionType)) {
      await _actions[actionType]!(actionData);
    } else {
      print('ActionHandle: Unknown action type: $actionType');
    }
  }

  @override
  bool validateContext(Map<String, dynamic> context) {
    return context.containsKey('action') && context['action'] is String;
  }

  @override
  void dispose() {
    _actions.clear();
  }

  /// Enregistre une nouvelle action
  void register(String actionType, ActionExecutor executor) {
    _actions[actionType] = executor;
  }

  /// Supprime une action
  void unregister(String actionType) {
    _actions.remove(actionType);
  }

  /// Vérifie si une action est enregistrée
  bool hasAction(String actionType) {
    return _actions.containsKey(actionType);
  }

  // Actions par défaut

  Future<void> _executeNavigate(dynamic data) async {
    final route = data['route'] as String?;
    final arguments = data['arguments'];

    if (route != null) {
      // Déléguer à NavigationHandle
      final navHandle =
          HandleFactory.create(HandleType.navigation) as NavigationHandle;
      await navHandle.execute({
        'action': 'navigate',
        'route': route,
        'arguments': arguments,
      });
    }
  }

  Future<void> _executeApiGet(dynamic data) async {
    final endpoint = data['endpoint'] as String?;

    if (endpoint != null) {
      try {
        final response = await _apiService.get(endpoint);
        // Publier événement de succès
        final eventHandle =
            HandleFactory.create(HandleType.event) as EventHandle;
        eventHandle.publish('api_success', response.data);
      } catch (e) {
        // Publier événement d'erreur
        final eventHandle =
            HandleFactory.create(HandleType.event) as EventHandle;
        eventHandle.publish('api_error', e);
      }
    }
  }

  Future<void> _executeApiPost(dynamic data) async {
    final endpoint = data['endpoint'] as String?;
    final body = data['body'];

    if (endpoint != null) {
      try {
        final response = await _apiService.post(endpoint, body: body);
        final eventHandle =
            HandleFactory.create(HandleType.event) as EventHandle;
        eventHandle.publish('api_success', response.data);
      } catch (e) {
        final eventHandle =
            HandleFactory.create(HandleType.event) as EventHandle;
        eventHandle.publish('api_error', e);
      }
    }
  }

  Future<void> _executeCustom(dynamic data) async {
    final actionName = data['name'] as String?;
    final params = data['params'];

    if (actionName != null) {
      // Actions custom définies par l'utilisateur
      print(
          'ActionHandle: Executing custom action: $actionName with params: $params');
      // Ici on pourrait avoir un registre d'actions custom
    }
  }

  Future<void> _executeShowPopup(dynamic data) async {
    final message = data['message'] as String?;
    final type = data['type'] as String? ?? 'info';

    if (message != null) {
      print('ActionHandle: Showing $type popup: $message');
      // Ici on pourrait intégrer un système de notifications
    }
  }

  Future<void> _executeLog(dynamic data) async {
    final message = data['message'] as String?;
    final level = data['level'] as String? ?? 'info';

    if (message != null) {
      print('ActionHandle [$level]: $message');
    }
  }
}

/// Type pour les exécuteurs d'actions
typedef ActionExecutor = Future<void> Function(dynamic data);
