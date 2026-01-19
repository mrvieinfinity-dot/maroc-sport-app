# NavigationHandle - Implémentation détaillée

## Vue d'ensemble

`NavigationHandle` est la classe centrale du système de navigation, responsable de l'orchestration des transitions entre pages et de la gestion des stratégies de navigation.

## Architecture

### Pattern Handle

`NavigationHandle` implémente le pattern Handle pour fournir une interface unifiée :

```dart
abstract class Handle {
  void registerDefaults();
  Future<void> execute(Map<String, dynamic> context);
  bool validateContext(Map<String, dynamic> context);
  void dispose();
}
```

### Composition

```dart
class NavigationHandle extends Handle {
  NavigationStrategy _strategy;
  final Map<String, NavigationValidator> _validators = {};
  final List<NavigationMiddleware> _middlewares = [];
  final NavigationHistory _history = NavigationHistory();
}
```

## Initialisation

### Enregistrement des stratégies

```dart
@override
void registerDefaults() {
  // Stratégie par défaut
  setStrategy(DefaultNavigationStrategy());

  // Validateurs
  _validators['route'] = RouteValidator();
  _validators['params'] = ParamsValidator();

  // Middlewares
  _middlewares.add(LoggingMiddleware());
  _middlewares.add(AuthMiddleware());
}
```

### Configuration

```dart
void configure({
  NavigationStrategy? strategy,
  List<NavigationMiddleware>? middlewares,
  Map<String, NavigationValidator>? validators,
}) {
  if (strategy != null) setStrategy(strategy);
  if (middlewares != null) _middlewares.addAll(middlewares);
  if (validators != null) _validators.addAll(validators);
}
```

## Exécution des actions

### Pipeline d'exécution

```dart
@override
Future<void> execute(Map<String, dynamic> context) async {
  try {
    // 1. Validation du contexte
    if (!validateContext(context)) {
      throw NavigationError('Invalid context');
    }

    // 2. Application des middlewares
    for (final middleware in _middlewares) {
      context = await middleware.process(context);
    }

    // 3. Exécution de l'action
    final action = context['action'] as String;
    switch (action) {
      case 'navigate':
        await _executeNavigate(context);
        break;
      case 'goBack':
        await _executeGoBack(context);
        break;
      default:
        throw NavigationError('Unknown action: $action');
    }

    // 4. Mise à jour de l'historique
    _history.addEntry(context);

    // 5. Publication d'événements
    EventHandle().publish('navigation_completed', context);

  } catch (e) {
    EventHandle().publish('navigation_failed', {'error': e, 'context': context});
    rethrow;
  }
}
```

### Action navigate

```dart
Future<void> _executeNavigate(Map<String, dynamic> context) async {
  final route = context['params']['route'] as String;
  final params = context['params']['params'] as Map<String, dynamic>?;

  // Validation de la route
  if (!await _strategy.canNavigate(route)) {
    throw NavigationError('Cannot navigate to route: $route');
  }

  // Navigation
  await _strategy.navigate(context['buildContext'], route, params);
}
```

### Action goBack

```dart
Future<void> _executeGoBack(Map<String, dynamic> context) async {
  await _strategy.goBack(context['buildContext']);
}
```

## Validation

### Interface de validation

```dart
abstract class NavigationValidator {
  Future<bool> validate(String key, dynamic value);
}
```

### Validateurs intégrés

#### RouteValidator

```dart
class RouteValidator extends NavigationValidator {
  final Set<String> _validRoutes;

  RouteValidator(this._validRoutes);

  @override
  Future<bool> validate(String key, dynamic value) async {
    if (key != 'route') return true;
    return _validRoutes.contains(value as String);
  }
}
```

#### ParamsValidator

```dart
class ParamsValidator extends NavigationValidator {
  @override
  Future<bool> validate(String key, dynamic value) async {
    if (key != 'params') return true;

    final params = value as Map<String, dynamic>?;
    if (params == null) return true;

    // Validation des types
    for (final entry in params.entries) {
      if (!_isValidParamType(entry.value)) {
        return false;
      }
    }

    return true;
  }

  bool _isValidParamType(dynamic value) {
    return value is String ||
           value is int ||
           value is double ||
           value is bool ||
           value is Map<String, dynamic> ||
           value is List;
  }
}
```

## Middlewares

### Interface middleware

```dart
abstract class NavigationMiddleware {
  Future<Map<String, dynamic>> process(Map<String, dynamic> context);
}
```

### Middlewares intégrés

#### LoggingMiddleware

```dart
class LoggingMiddleware extends NavigationMiddleware {
  @override
  Future<Map<String, dynamic>> process(Map<String, dynamic> context) async {
    debugPrint('Navigation: ${context['action']} - ${DateTime.now()}');
    return context;
  }
}
```

#### AuthMiddleware

```dart
class AuthMiddleware extends NavigationMiddleware {
  @override
  Future<Map<String, dynamic>> process(Map<String, dynamic> context) async {
    final route = context['params']['route'] as String?;

    if (_requiresAuth(route)) {
      final isAuthenticated = await _checkAuthStatus();
      if (!isAuthenticated) {
        // Redirection vers login
        return {
          ...context,
          'action': 'navigate',
          'params': {'route': 'login'},
        };
      }
    }

    return context;
  }
}
```

## Historique de navigation

### NavigationHistory

```dart
class NavigationHistory {
  final List<NavigationEntry> _entries = [];
  static const int _maxHistorySize = 50;

  void addEntry(Map<String, dynamic> context) {
    final entry = NavigationEntry(
      action: context['action'],
      route: context['params']['route'],
      params: context['params']['params'],
      timestamp: DateTime.now(),
    );

    _entries.add(entry);

    // Limiter la taille
    if (_entries.length > _maxHistorySize) {
      _entries.removeAt(0);
    }
  }

  List<NavigationEntry> getRecentEntries(int count) {
    return _entries.reversed.take(count).toList();
  }

  bool canGoBack() => _entries.isNotEmpty;
}
```

### NavigationEntry

```dart
class NavigationEntry {
  final String action;
  final String? route;
  final Map<String, dynamic>? params;
  final DateTime timestamp;

  NavigationEntry({
    required this.action,
    this.route,
    this.params,
    required this.timestamp,
  });
}
```

## Stratégies de navigation

### DefaultNavigationStrategy

```dart
class DefaultNavigationStrategy implements NavigationStrategy {
  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    await Navigator.of(context).pushNamed(route, arguments: params);
  }

  @override
  Future<void> goBack(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Future<bool> canNavigate(String route) async {
    // Vérifier si la route est définie
    return true; // Implémentation simplifiée
  }
}
```

### GoRouterStrategy

```dart
class GoRouterStrategy implements NavigationStrategy {
  final GoRouter _router;

  GoRouterStrategy(this._router);

  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    _router.go(route, extra: params);
  }

  @override
  Future<void> goBack(BuildContext context) async {
    _router.pop();
  }

  @override
  Future<bool> canNavigate(String route) async {
    return _router.routeInformationParser != null;
  }
}
```

## Gestion d'erreurs

### NavigationError

```dart
class NavigationError extends Error {
  final String message;
  final String? route;
  final Map<String, dynamic>? context;

  NavigationError(this.message, {this.route, this.context});

  @override
  String toString() => 'NavigationError: $message';
}
```

### Gestion globale

```dart
class NavigationErrorHandler {
  void handleError(NavigationError error) {
    // Log détaillé
    debugPrint('Navigation Error: ${error.message}');
    if (error.route != null) {
      debugPrint('Route: ${error.route}');
    }

    // Rapport d'erreur
    _reportError(error);

    // Récupération
    _attemptRecovery(error);
  }

  void _reportError(NavigationError error) {
    // Envoyer à un service de monitoring
  }

  void _attemptRecovery(NavigationError error) {
    // Tenter de naviguer vers une page d'erreur
  }
}
```

## Performance

### Optimisations

- **Cache des routes** : Éviter les recalculs
- **Lazy loading** : Chargement à la demande
- **Pooling d'objets** : Réutilisation des instances

### Métriques

```dart
class NavigationMetrics {
  final Map<String, int> _navigationCounts = {};
  final Map<String, Duration> _averageTimes = {};

  void recordNavigation(String route, Duration time) {
    _navigationCounts[route] = (_navigationCounts[route] ?? 0) + 1;

    final current = _averageTimes[route] ?? Duration.zero;
    final count = _navigationCounts[route]!;
    _averageTimes[route] = current + (time - current) ~/ count;
  }
}
```

## Tests

### Tests unitaires

```dart
void main() {
  group('NavigationHandle', () {
    late NavigationHandle handle;

    setUp(() {
      handle = NavigationHandle();
      handle.registerDefaults();
    });

    test('should navigate to valid route', () async {
      final context = {
        'action': 'navigate',
        'params': {'route': 'home'},
      };

      await handle.execute(context);
      // Vérifications
    });

    test('should throw on invalid route', () async {
      final context = {
        'action': 'navigate',
        'params': {'route': 'invalid'},
      };

      expect(() => handle.execute(context), throwsA(isA<NavigationError>()));
    });
  });
}
```

### Tests d'intégration

```dart
void main() {
  group('Navigation Integration', () {
    testWidgets('should navigate between pages', (tester) async {
      await tester.pumpWidget(MyApp());

      // Simuler tap sur bouton de navigation
      await tester.tap(find.text('Go to Profile'));
      await tester.pumpAndSettle();

      // Vérifier navigation
      expect(find.text('Profile Page'), findsOneWidget);
    });
  });
}
```

## Extension

### Ajouter une nouvelle stratégie

1. Implémenter `NavigationStrategy`
2. L'enregistrer dans `NavigationHandle`
3. Tester l'intégration

### Ajouter un middleware

1. Implémenter `NavigationMiddleware`
2. L'ajouter à la liste des middlewares
3. Documenter le comportement

### Personnalisation avancée

```dart
class CustomNavigationHandle extends NavigationHandle {
  @override
  void registerDefaults() {
    super.registerDefaults();

    // Ajouter des validateurs personnalisés
    _validators['custom'] = CustomValidator();

    // Ajouter des middlewares personnalisés
    _middlewares.add(CustomMiddleware());
  }
}
```