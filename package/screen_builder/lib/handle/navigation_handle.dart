// lib/handle/navigation_handle.dart
import 'handle_interface.dart';
import 'event_handle.dart';
import '../engine/utils/builder_util.dart';

/// Gestionnaire centralisé de la navigation
/// Gère la navigation JSON-driven et les transitions de pages
class NavigationHandle implements Handle {
  final Map<String, NavigationStrategy> _strategies = {};
  NavigationStrategy? _currentStrategy;

  NavigationHandle() {
    _registerDefaultStrategies();
  }

  @override
  void registerDefaults() {
    // Stratégies par défaut déjà enregistrées dans le constructeur
  }

  @override
  Future<void> execute(Map<String, dynamic> context) async {
    final action = context['action'] as String?;
    final route = context['route'] as String?;
    final arguments = context['arguments'];

    switch (action) {
      case 'navigate':
        if (route != null) {
          await navigateTo(route, arguments: arguments);
        }
        break;
      case 'navigate_back':
        await navigateBack();
        break;
      case 'replace':
        if (route != null) {
          await replace(route, arguments: arguments);
        }
        break;
      case 'set_strategy':
        final strategyName = context['strategy'] as String?;
        if (strategyName != null) {
          setStrategy(strategyName);
        }
        break;
    }
  }

  @override
  bool validateContext(Map<String, dynamic> context) {
    final action = context['action'] as String?;
    return action != null &&
        ['navigate', 'navigate_back', 'replace', 'set_strategy']
            .contains(action);
  }

  @override
  void dispose() {
    _strategies.clear();
    _currentStrategy = null;
  }

  /// Navigation vers une page
  Future<void> navigateTo(String route, {dynamic arguments}) async {
    if (_currentStrategy != null) {
      await _currentStrategy!.navigateTo(route, arguments: arguments);

      // Publier événement de navigation réussie
      final eventHandle = HandleFactory.create(HandleType.event) as EventHandle;
      eventHandle.publish('navigation_success', {
        'route': route,
        'arguments': arguments,
      });
    }
  }

  /// Retour à la page précédente
  Future<void> navigateBack() async {
    if (_currentStrategy != null) {
      await _currentStrategy!.navigateBack();
    }
  }

  /// Remplacement de la page courante
  Future<void> replace(String route, {dynamic arguments}) async {
    if (_currentStrategy != null) {
      await _currentStrategy!.replace(route, arguments: arguments);
    }
  }

  /// Définit la stratégie de navigation
  void setStrategy(String strategyName) {
    if (_strategies.containsKey(strategyName)) {
      _currentStrategy = _strategies[strategyName];
    }
  }

  /// Enregistre une nouvelle stratégie
  void registerStrategy(String name, NavigationStrategy strategy) {
    _strategies[name] = strategy;
    // Si pas de stratégie courante, utiliser celle-ci
    _currentStrategy ??= strategy;
  }

  /// Obtient la liste des stratégies disponibles
  List<String> getAvailableStrategies() {
    return _strategies.keys.toList();
  }

  void _registerDefaultStrategies() {
    // Stratégie Navigator (par défaut)
    registerStrategy('navigator', NavigatorStrategy());

    // Stratégie GoRouter (optionnelle)
    // registerStrategy('go_router', GoRouterStrategy());

    // Utiliser Navigator par défaut
    setStrategy('navigator');
  }
}

/// Interface pour les stratégies de navigation
abstract class NavigationStrategy {
  Future<void> navigateTo(String route, {dynamic arguments});
  Future<void> navigateBack();
  Future<void> replace(String route, {dynamic arguments});
}

/// Implémentation Navigator par défaut
class NavigatorStrategy implements NavigationStrategy {
  @override
  Future<void> navigateTo(String route, {dynamic arguments}) async {
    // Utilise BuilderUtil pour construire la page depuis JSON
    final pageSpec = await BuilderUtil.buildPageFromRoute(route, arguments);
    if (pageSpec != null) {
      // Ici on utiliserait le navigator Flutter
      print('NavigatorStrategy: Navigating to $route with args: $arguments');
    }
  }

  @override
  Future<void> navigateBack() async {
    print('NavigatorStrategy: Navigating back');
  }

  @override
  Future<void> replace(String route, {dynamic arguments}) async {
    print('NavigatorStrategy: Replacing with $route');
  }
}
