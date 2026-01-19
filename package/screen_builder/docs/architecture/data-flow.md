# Flux de données de la navigation

## Vue d'ensemble

Le système de navigation gère un flux de données complexe depuis les fichiers JSON jusqu'aux widgets Flutter, en passant par plusieurs couches d'abstraction.

## Flux principal

### 1. Chargement initial

```
navigation.json → ScreenBuilderPage → _loadNavigationAndHomePage()
                                      ↓
                               _navigation (Map)
                                      ↓
                            BottomNavigationBar
```

### 2. Navigation utilisateur

```
Tap sur BottomNavigationBar → _onItemTapped() → NavigationHandle.execute()
                                                            ↓
                                                     stratégie.navigate()
                                                            ↓
                                                changement de page
```

### 3. Actions dans les pages

```
Button avec action → ActionHandle.execute() → NavigationHandle.execute()
                                      ↓
                               validation et navigation
```

## Structures de données

### Navigation JSON

```json
{
  "items": [
    {
      "label": "Home",
      "icon": "home",
      "page": "home"
    }
  ]
}
```

**Conversion en interne :**

```dart
class NavigationItem {
  final String label;
  final String icon;
  final String page;

  NavigationItem({
    required this.label,
    required this.icon,
    required this.page,
  });
}
```

### Page JSON

```json
{
  "component": "screen",
  "props": {"title": "Home"},
  "children": [...]
}
```

**Conversion :**

```dart
class PageModel {
  final String component;
  final Map<String, dynamic> props;
  final List<Map<String, dynamic>> children;

  PageModel({
    required this.component,
    required this.props,
    required this.children,
  });
}
```

### ComponentSpec

Structure interne pour les composants :

```dart
class ComponentSpec {
  final String type;
  final Map<String, dynamic> props;
  final List<ComponentSpec> children;

  ComponentSpec({
    required this.type,
    required this.props,
    this.children = const [],
  });
}
```

## Pipeline de transformation

### Étape 1: JSON → PageModel

```dart
PageModel pageModel = PageModel.fromJson(jsonData);
```

### Étape 2: PageModel → ComponentSpec

```dart
ComponentSpec rootSpec = PageEngine().buildComponentSpec(pageModel.components);
```

### Étape 3: ComponentSpec → Widget

```dart
Widget widget = SpecsRenderer().render(context, rootSpec);
```

## Gestion des paramètres

### Passage de paramètres

```json
{
  "action": {
    "type": "navigate",
    "params": {
      "route": "details",
      "id": 123,
      "filters": {"category": "sports"}
    }
  }
}
```

### Stockage interne

```dart
class NavigationContext {
  final String route;
  final Map<String, dynamic> params;
  final DateTime timestamp;

  NavigationContext({
    required this.route,
    this.params = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
```

### Accès dans les pages

Les paramètres sont accessibles via le BuildContext :

```dart
class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final id = args?['id'];

    return Text('Details for item $id');
  }
}
```

## Cache et optimisation

### Cache de pages

```dart
class PageCache {
  final Map<String, PageModel> _cache = {};

  PageModel? get(String key) => _cache[key];

  void put(String key, PageModel page) {
    _cache[key] = page;
  }
}
```

### Cache de composants

```dart
class ComponentCache {
  final Map<String, ComponentSpec> _cache = {};

  ComponentSpec? get(String key) => _cache[key];

  void put(String key, ComponentSpec spec) {
    _cache[key] = spec;
  }
}
```

## Gestion d'état

### État de navigation

```dart
class NavigationState {
  final int currentIndex;
  final List<String> history;
  final Map<String, dynamic> currentParams;

  NavigationState({
    this.currentIndex = 0,
    this.history = const [],
    this.currentParams = const {},
  });
}
```

### Mise à jour d'état

```dart
class NavigationStateNotifier extends ChangeNotifier {
  NavigationState _state = NavigationState();

  void updateIndex(int index) {
    _state = _state.copyWith(currentIndex: index);
    notifyListeners();
  }

  void addToHistory(String route) {
    final newHistory = List<String>.from(_state.history)..add(route);
    _state = _state.copyWith(history: newHistory);
    notifyListeners();
  }
}
```

## Flux d'événements

### Événements système

- `navigation_start` : Début de navigation
- `navigation_success` : Navigation réussie
- `navigation_error` : Erreur de navigation
- `page_load` : Page chargée
- `component_render` : Composant rendu

### Gestion des événements

```dart
class EventManager {
  final Map<String, List<Function>> _listeners = {};

  void addListener(String event, Function listener) {
    _listeners.putIfAbsent(event, () => []).add(listener);
  }

  void emit(String event, dynamic data) {
    final listeners = _listeners[event];
    if (listeners != null) {
      for (final listener in listeners) {
        listener(data);
      }
    }
  }
}
```

## Gestion d'erreurs

### Types d'erreurs

- **PageNotFoundError** : Page JSON manquante
- **InvalidJsonError** : JSON mal formé
- **ComponentNotFoundError** : Composant non enregistré
- **NavigationError** : Erreur de navigation

### Propagation d'erreurs

```dart
try {
  final page = await loadPage(route);
  final widget = buildPage(page);
  return widget;
} catch (e) {
  // Log error
  debugPrint('Error loading page $route: $e');

  // Return error page
  return ErrorPage(error: e);
}
```

## Métriques et monitoring

### Métriques collectées

- Temps de chargement des pages
- Taille des assets JSON
- Nombre d'erreurs
- Fréquence d'utilisation des routes

### Outil de monitoring

```dart
class NavigationMetrics {
  final Stopwatch _stopwatch = Stopwatch();

  void startPageLoad(String route) {
    _stopwatch.reset();
    _stopwatch.start();
  }

  void endPageLoad(String route) {
    _stopwatch.stop();
    final duration = _stopwatch.elapsedMilliseconds;

    // Send to analytics
    analytics.track('page_load', {
      'route': route,
      'duration_ms': duration,
    });
  }
}
```

## Sécurité

### Validation des données

Toutes les données JSON sont validées :

```dart
bool validatePageJson(Map<String, dynamic> json) {
  // Vérifier structure requise
  if (!json.containsKey('component')) return false;

  // Valider props
  final props = json['props'];
  if (props != null && props is! Map) return false;

  // Valider children
  final children = json['children'];
  if (children != null && children is! List) return false;

  return true;
}
```

### Sanitisation

Les données utilisateur sont sanitizées avant utilisation dans les composants.