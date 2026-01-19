# Gestion d'état de la navigation

## Vue d'ensemble

La gestion d'état dans le système de navigation assure la cohérence des données et de l'interface utilisateur pendant les transitions entre pages.

## Types d'état

### État de navigation

Informations sur la position actuelle dans l'application.

```dart
class NavigationState {
  final String currentRoute;
  final Map<String, dynamic> currentParams;
  final List<String> routeHistory;
  final int historyIndex;

  NavigationState({
    required this.currentRoute,
    this.currentParams = const {},
    this.routeHistory = const [],
    this.historyIndex = -1,
  });
}
```

### État des pages

Données spécifiques à chaque page.

```dart
class PageState {
  final String route;
  final Map<String, dynamic> data;
  final bool isLoading;
  final String? error;

  PageState({
    required this.route,
    this.data = const {},
    this.isLoading = false,
    this.error,
  });
}
```

### État global

État partagé entre toutes les pages.

```dart
class AppState {
  final NavigationState navigation;
  final Map<String, PageState> pageStates;
  final UserState user;
  final ThemeState theme;

  AppState({
    required this.navigation,
    this.pageStates = const {},
    required this.user,
    required this.theme,
  });
}
```

## Gestionnaires d'état

### NavigationStateManager

Classe responsable de la gestion de l'état de navigation.

```dart
class NavigationStateManager extends ChangeNotifier {
  NavigationState _state = NavigationState(currentRoute: 'home');

  NavigationState get state => _state;

  void navigate(String route, Map<String, dynamic>? params) {
    final newHistory = List<String>.from(_state.routeHistory);
    if (_state.currentRoute.isNotEmpty) {
      newHistory.add(_state.currentRoute);
    }

    _state = NavigationState(
      currentRoute: route,
      currentParams: params ?? {},
      routeHistory: newHistory,
      historyIndex: newHistory.length,
    );

    notifyListeners();
  }

  void goBack() {
    if (_state.historyIndex > 0) {
      final previousRoute = _state.routeHistory[_state.historyIndex - 1];

      _state = _state.copyWith(
        currentRoute: previousRoute,
        historyIndex: _state.historyIndex - 1,
      );

      notifyListeners();
    }
  }

  bool canGoBack() => _state.historyIndex > 0;
}
```

### PageStateManager

Gestion de l'état par page.

```dart
class PageStateManager {
  final Map<String, PageState> _pageStates = {};

  PageState getPageState(String route) {
    return _pageStates.putIfAbsent(route, () => PageState(route: route));
  }

  void updatePageState(String route, PageState newState) {
    _pageStates[route] = newState;
  }

  void setPageLoading(String route, bool loading) {
    final currentState = getPageState(route);
    updatePageState(route, currentState.copyWith(isLoading: loading));
  }

  void setPageError(String route, String error) {
    final currentState = getPageState(route);
    updatePageState(route, currentState.copyWith(error: error, isLoading: false));
  }

  void setPageData(String route, Map<String, dynamic> data) {
    final currentState = getPageState(route);
    updatePageState(route, currentState.copyWith(data: data, isLoading: false, error: null));
  }
}
```

## Persistence d'état

### SharedPreferences

Sauvegarde de l'état de navigation.

```dart
class NavigationPersistence {
  static const String _currentRouteKey = 'nav_current_route';
  static const String _historyKey = 'nav_history';

  Future<void> saveState(NavigationState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentRouteKey, state.currentRoute);
    await prefs.setStringList(_historyKey, state.routeHistory);
  }

  Future<NavigationState?> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final currentRoute = prefs.getString(_currentRouteKey);
    final history = prefs.getStringList(_historyKey);

    if (currentRoute == null) return null;

    return NavigationState(
      currentRoute: currentRoute,
      routeHistory: history ?? [],
      historyIndex: (history?.length ?? 0) - 1,
    );
  }
}
```

### Hydratation au démarrage

```dart
class AppBootstrapper {
  Future<AppState> initializeApp() async {
    // Charger l'état sauvegardé
    final savedNavState = await NavigationPersistence().loadState();
    final navState = savedNavState ?? NavigationState(currentRoute: 'home');

    // Créer l'état initial
    return AppState(
      navigation: navState,
      user: await _loadUserState(),
      theme: _loadThemeState(),
    );
  }
}
```

## StateNotifier avec Riverpod

### Définition des providers

```dart
final navigationStateProvider = StateNotifierProvider<NavigationStateNotifier, NavigationState>((ref) {
  return NavigationStateNotifier();
});

final pageStateProvider = StateNotifierProvider.family<PageStateNotifier, PageState, String>((ref, route) {
  return PageStateNotifier(route);
});
```

### NavigationStateNotifier

```dart
class NavigationStateNotifier extends StateNotifier<NavigationState> {
  NavigationStateNotifier() : super(NavigationState(currentRoute: 'home'));

  void navigate(String route, Map<String, dynamic>? params) {
    final newHistory = List<String>.from(state.routeHistory);
    if (state.currentRoute.isNotEmpty) {
      newHistory.add(state.currentRoute);
    }

    state = NavigationState(
      currentRoute: route,
      currentParams: params ?? {},
      routeHistory: newHistory,
      historyIndex: newHistory.length,
    );
  }

  void goBack() {
    if (state.historyIndex > 0) {
      final previousRoute = state.routeHistory[state.historyIndex - 1];
      state = state.copyWith(
        currentRoute: previousRoute,
        historyIndex: state.historyIndex - 1,
      );
    }
  }
}
```

### Utilisation dans les widgets

```dart
class NavigationWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationStateProvider);

    return BottomNavigationBar(
      currentIndex: _getCurrentIndex(navState.currentRoute),
      onTap: (index) {
        final route = _getRouteFromIndex(index);
        ref.read(navigationStateProvider.notifier).navigate(route, null);
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
```

## Gestion des erreurs d'état

### Validation d'état

```dart
class StateValidator {
  static bool isValidNavigationState(NavigationState state) {
    // Vérifier la route actuelle
    if (state.currentRoute.isEmpty) return false;

    // Vérifier l'historique
    if (state.historyIndex < -1 || state.historyIndex >= state.routeHistory.length) {
      return false;
    }

    return true;
  }

  static NavigationState sanitizeState(NavigationState state) {
    if (isValidNavigationState(state)) return state;

    // Corriger l'état invalide
    return NavigationState(
      currentRoute: 'home',
      routeHistory: [],
      historyIndex: -1,
    );
  }
}
```

### Récupération d'erreur

```dart
class StateErrorRecovery {
  NavigationState recoverFromError(dynamic error, NavigationState currentState) {
    debugPrint('State error: $error');

    // Essayer de récupérer l'état précédent
    if (currentState.historyIndex > 0) {
      return currentState.copyWith(
        currentRoute: currentState.routeHistory[currentState.historyIndex - 1],
        historyIndex: currentState.historyIndex - 1,
      );
    }

    // Fallback vers l'accueil
    return NavigationState(currentRoute: 'home');
  }
}
```

## Optimisations de performance

### Memoization

```dart
class StateMemoizer {
  final Map<String, NavigationState> _memoizedStates = {};

  NavigationState getMemoizedState(String key, NavigationState Function() factory) {
    return _memoizedStates.putIfAbsent(key, factory);
  }

  void invalidate(String key) {
    _memoizedStates.remove(key);
  }

  void clear() {
    _memoizedStates.clear();
  }
}
```

### Lazy loading d'état

```dart
class LazyStateLoader {
  final Map<String, Future<PageState>> _loadingStates = {};

  Future<PageState> getPageState(String route) {
    return _loadingStates.putIfAbsent(route, () => _loadPageState(route));
  }

  Future<PageState> _loadPageState(String route) async {
    // Simulation de chargement
    await Future.delayed(Duration(milliseconds: 100));

    return PageState(route: route, data: {'loaded': true});
  }
}
```

## Tests d'état

### Tests unitaires

```dart
void main() {
  group('NavigationStateManager', () {
    late NavigationStateManager manager;

    setUp(() {
      manager = NavigationStateManager();
    });

    test('should navigate to new route', () {
      manager.navigate('profile', {'userId': 123});

      expect(manager.state.currentRoute, 'profile');
      expect(manager.state.currentParams['userId'], 123);
      expect(manager.state.routeHistory, ['home']);
    });

    test('should go back in history', () {
      manager.navigate('profile', null);
      manager.navigate('settings', null);

      manager.goBack();

      expect(manager.state.currentRoute, 'profile');
      expect(manager.state.historyIndex, 1);
    });
  });
}
```

### Tests d'intégration

```dart
void main() {
  group('State Integration', () {
    testWidgets('should persist navigation state', (tester) async {
      await tester.pumpWidget(MyApp());

      // Naviguer
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Redémarrer l'app
      await tester.restartAndRestore();

      // Vérifier que l'état est restauré
      expect(find.text('Profile Page'), findsOneWidget);
    });
  });
}
```

## Bonnes pratiques

### Immutabilité

Toujours créer de nouveaux objets d'état plutôt que de modifier les existants.

```dart
// Bien
state = state.copyWith(currentRoute: 'newRoute');

// Mal
state.currentRoute = 'newRoute';
```

### Séparation des préoccupations

- **NavigationState** : État de navigation uniquement
- **PageState** : Données de page
- **AppState** : État global

### Gestion des effets de bord

Utiliser des middlewares pour les effets de bord.

```dart
class PersistenceMiddleware extends NavigationMiddleware {
  @override
  Future<Map<String, dynamic>> process(Map<String, dynamic> context) async {
    // Sauvegarder après chaque navigation
    await NavigationPersistence().saveState(navigationState);

    return context;
  }
}
```

## Debugging

### Outil de debug d'état

```dart
class StateDebugger {
  static void printState(NavigationState state) {
    debugPrint('Current Route: ${state.currentRoute}');
    debugPrint('Params: ${state.currentParams}');
    debugPrint('History: ${state.routeHistory}');
    debugPrint('History Index: ${state.historyIndex}');
  }

  static void logStateChanges(NavigationState oldState, NavigationState newState) {
    if (oldState.currentRoute != newState.currentRoute) {
      debugPrint('Route changed: ${oldState.currentRoute} -> ${newState.currentRoute}');
    }
  }
}
```

### Validation en développement

```dart
class DevStateValidator {
  static void validateState(NavigationState state) {
    assert(state.currentRoute.isNotEmpty, 'Route cannot be empty');
    assert(state.historyIndex >= -1, 'Invalid history index');
  }
}
```