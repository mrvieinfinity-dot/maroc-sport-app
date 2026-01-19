# Stratégies de navigation

## Vue d'ensemble

Les stratégies de navigation permettent de changer le comportement de navigation sans modifier le code existant. Elles suivent le pattern Strategy pour une flexibilité maximale.

## Interface NavigationStrategy

### Définition

```dart
abstract class NavigationStrategy {
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params);
  Future<void> goBack(BuildContext context);
  Future<bool> canNavigate(String route);
  void dispose();
}
```

### Responsabilités

- **Navigation** : Effectuer les transitions entre pages
- **Validation** : Vérifier la possibilité de navigation
- **Gestion d'état** : Maintenir l'état de navigation
- **Nettoyage** : Libérer les ressources

## Stratégies intégrées

### DefaultNavigationStrategy

#### Description

Stratégie par défaut utilisant Navigator 1.0 de Flutter.

#### Implémentation

```dart
class DefaultNavigationStrategy implements NavigationStrategy {
  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    await Navigator.of(context).pushNamed(
      route,
      arguments: params,
    );
  }

  @override
  Future<void> goBack(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Future<bool> canNavigate(String route) async {
    // Vérifier si la route est définie dans les routes de l'app
    return true; // Implémentation simplifiée
  }

  @override
  void dispose() {
    // Rien à nettoyer
  }
}
```

#### Avantages

- **Simple** : Facile à comprendre et utiliser
- **Standard** : Utilise l'API Flutter standard
- **Robuste** : Bien testé et stable

#### Limitations

- **État limité** : Pas de gestion d'état complexe
- **Transitions fixes** : Animations par défaut uniquement

### GoRouterStrategy

#### Description

Stratégie utilisant le package go_router pour une navigation déclarative.

#### Dépendances

```yaml
dependencies:
  go_router: ^10.0.0
```

#### Implémentation

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
    // Vérifier si la route existe dans la configuration GoRouter
    final routes = _router.routerDelegate.currentConfiguration.routes;
    return routes.any((r) => r.name == route);
  }

  @override
  void dispose() {
    // GoRouter gère son propre nettoyage
  }
}
```

#### Configuration GoRouter

```dart
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomePage(params: state.extra as Map?),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => ProfilePage(params: state.extra as Map?),
    ),
  ],
);
```

#### Avantages

- **URL-based** : Navigation basée sur les URLs
- **Deep linking** : Support des liens profonds
- **Web-friendly** : Optimisé pour le web
- **Flexible** : Routes imbriquées et guards

### CupertinoNavigationStrategy

#### Description

Stratégie pour les applications iOS utilisant CupertinoPageRoute.

#### Implémentation

```dart
class CupertinoNavigationStrategy implements NavigationStrategy {
  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => _buildPage(route, params),
        settings: RouteSettings(name: route, arguments: params),
      ),
    );
  }

  @override
  Future<void> goBack(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Future<bool> canNavigate(String route) async {
    return true; // Validation externe nécessaire
  }

  Widget _buildPage(String route, Map<String, dynamic>? params) {
    switch (route) {
      case 'home':
        return HomePage(params: params);
      case 'profile':
        return ProfilePage(params: params);
      default:
        return UnknownPage(route: route);
    }
  }
}
```

#### Avantages

- **Native iOS** : Respecte les guidelines iOS
- **Transitions fluides** : Animations natives
- **Accessibilité** : Support iOS intégré

## Stratégies personnalisées

### ModalNavigationStrategy

#### Description

Stratégie pour afficher des pages en modal.

#### Cas d'usage

- Dialogues
- Formulaires
- Menus

#### Implémentation

```dart
class ModalNavigationStrategy implements NavigationStrategy {
  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: _buildModalContent(route, params),
      ),
    );
  }

  @override
  Future<void> goBack(BuildContext context) async {
    Navigator.of(context).pop();
  }

  @override
  Future<bool> canNavigate(String route) async {
    // Vérifier si la route est une modal valide
    return _modalRoutes.contains(route);
  }

  Widget _buildModalContent(String route, Map<String, dynamic>? params) {
    switch (route) {
      case 'login':
        return LoginModal(params: params);
      case 'settings':
        return SettingsModal(params: params);
      default:
        return UnknownModal(route: route);
    }
  }
}
```

### TabNavigationStrategy

#### Description

Stratégie pour la navigation par onglets.

#### Implémentation

```dart
class TabNavigationStrategy implements NavigationStrategy {
  final TabController _tabController;

  TabNavigationStrategy(this._tabController);

  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    final tabIndex = _getTabIndex(route);
    _tabController.animateTo(tabIndex);
  }

  @override
  Future<void> goBack(BuildContext context) async {
    // Pas de retour en arrière dans les onglets
  }

  @override
  Future<bool> canNavigate(String route) async {
    return _getTabIndex(route) != -1;
  }

  int _getTabIndex(String route) {
    switch (route) {
      case 'home': return 0;
      case 'search': return 1;
      case 'profile': return 2;
      default: return -1;
    }
  }
}
```

## Changement de stratégie à l'exécution

### Via NavigationHandle

```dart
final navHandle = DIContainer().get<NavigationHandle>('navigation');

// Changer de stratégie
navHandle.setStrategy(GoRouterStrategy(router));

// Navigation avec la nouvelle stratégie
await navHandle.execute({
  'action': 'navigate',
  'params': {'route': 'home'},
});
```

### Configuration conditionnelle

```dart
NavigationStrategy _selectStrategy() {
  if (Platform.isIOS) {
    return CupertinoNavigationStrategy();
  } else if (kIsWeb) {
    return GoRouterStrategy(router);
  } else {
    return DefaultNavigationStrategy();
  }
}
```

## Tests des stratégies

### Tests unitaires

```dart
void main() {
  group('DefaultNavigationStrategy', () {
    late DefaultNavigationStrategy strategy;

    setUp(() {
      strategy = DefaultNavigationStrategy();
    });

    test('should navigate to route', () async {
      final context = MockBuildContext();

      await strategy.navigate(context, 'home', null);

      // Vérifier que Navigator.pushNamed a été appelé
      verify(mockNavigator.pushNamed('home')).called(1);
    });

    test('should go back', () async {
      final context = MockBuildContext();

      await strategy.goBack(context);

      verify(mockNavigator.pop()).called(1);
    });
  });
}
```

### Tests d'intégration

```dart
void main() {
  group('Navigation Strategy Integration', () {
    testWidgets('GoRouterStrategy should navigate', (tester) async {
      final router = GoRouter(routes: [
        GoRoute(path: '/home', name: 'home', builder: (context, state) => HomePage()),
      ]);

      final strategy = GoRouterStrategy(router);

      await tester.pumpWidget(MaterialApp.router(router: router));

      await strategy.navigate(tester.element(find.byType(MaterialApp)), 'home', null);

      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
```

## Performance et optimisation

### Cache des stratégies

```dart
class StrategyCache {
  final Map<String, NavigationStrategy> _cache = {};

  NavigationStrategy getOrCreate(String key, NavigationStrategy Function() factory) {
    return _cache.putIfAbsent(key, factory);
  }

  void clear() {
    _cache.values.forEach((strategy) => strategy.dispose());
    _cache.clear();
  }
}
```

### Métriques de performance

```dart
class NavigationPerformanceMonitor {
  final Map<String, List<Duration>> _timings = {};

  void recordNavigation(String strategy, String route, Duration duration) {
    final key = '$strategy:$route';
    _timings.putIfAbsent(key, () => []).add(duration);
  }

  Map<String, Duration> getAverageTimings() {
    return _timings.map((key, value) {
      final avg = value.reduce((a, b) => a + b) ~/ value.length;
      return MapEntry(key, avg);
    });
  }
}
```

## Bonnes pratiques

### Choix de stratégie

- **DefaultNavigationStrategy** : Pour les apps simples
- **GoRouterStrategy** : Pour les apps web ou complexes
- **CupertinoNavigationStrategy** : Pour les apps iOS natives
- **Stratégies personnalisées** : Pour les besoins spécifiques

### Gestion d'erreurs

```dart
class SafeNavigationStrategy implements NavigationStrategy {
  final NavigationStrategy _delegate;

  SafeNavigationStrategy(this._delegate);

  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    try {
      await _delegate.navigate(context, route, params);
    } catch (e) {
      debugPrint('Navigation error: $e');
      // Fallback vers page d'erreur
      await _delegate.navigate(context, 'error', {'error': e.toString()});
    }
  }
}
```

### Logging

```dart
class LoggingNavigationStrategy implements NavigationStrategy {
  final NavigationStrategy _delegate;

  LoggingNavigationStrategy(this._delegate);

  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    debugPrint('Navigating to: $route with params: $params');
    await _delegate.navigate(context, route, params);
    debugPrint('Navigation completed');
  }
}
```

## Extension

### Créer une nouvelle stratégie

1. Implémenter `NavigationStrategy`
2. Ajouter les tests
3. Documenter l'usage
4. Enregistrer dans le système

### Exemple : DrawerNavigationStrategy

```dart
class DrawerNavigationStrategy implements NavigationStrategy {
  final GlobalKey<ScaffoldState> _scaffoldKey;

  DrawerNavigationStrategy(this._scaffoldKey);

  @override
  Future<void> navigate(BuildContext context, String route, Map<String, dynamic>? params) async {
    // Ouvrir le drawer avec le contenu approprié
    _scaffoldKey.currentState?.openDrawer();
    // Mettre à jour le contenu du drawer
  }
}
```