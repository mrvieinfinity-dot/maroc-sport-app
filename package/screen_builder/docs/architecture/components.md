# Composants du système de navigation

## Vue d'ensemble

Le système de navigation est composé de plusieurs composants interconnectés qui travaillent ensemble pour fournir une navigation fluide et flexible.

## NavigationHandle

### Description

Classe centrale qui gère toute la logique de navigation.

### Propriétés

```dart
class NavigationHandle extends Handle {
  NavigationStrategy _strategy;
  Map<String, dynamic> _currentParams;
  List<String> _navigationHistory;
}
```

### Méthodes principales

#### execute(Map<String, dynamic> context)

Exécute une action de navigation.

**Paramètres :**
- `context` : Map contenant les informations de navigation

**Exemple :**
```dart
await navigationHandle.execute({
  'action': 'navigate',
  'route': 'profile',
  'params': {'userId': 123}
});
```

#### setStrategy(NavigationStrategy strategy)

Change la stratégie de navigation utilisée.

**Paramètres :**
- `strategy` : Nouvelle stratégie à utiliser

#### validateRoute(String route)

Valide qu'une route existe et est accessible.

**Retour :** `bool` - true si la route est valide

### Événements

Le NavigationHandle publie les événements suivants via EventHandle :

- `navigation_started` : Avant le début de la navigation
- `navigation_completed` : Après navigation réussie
- `navigation_failed` : En cas d'erreur

## NavigationStrategy

### Description

Interface abstraite définissant le comportement de navigation.

### Implémentations

#### DefaultNavigationStrategy

Stratégie par défaut utilisant Navigator 1.0.

```dart
class DefaultNavigationStrategy implements NavigationStrategy {
  @override
  void navigate(BuildContext context, String route, Map<String, dynamic>? params) {
    Navigator.of(context).pushNamed(route, arguments: params);
  }
}
```

#### GoRouterStrategy

Stratégie utilisant le package go_router.

```dart
class GoRouterStrategy implements NavigationStrategy {
  final GoRouter _router;

  @override
  void navigate(BuildContext context, String route, Map<String, dynamic>? params) {
    _router.go(route, extra: params);
  }
}
```

## ScreenBuilderPage

### Description

Widget principal qui affiche les pages et la navigation.

### Cycle de vie

1. **initState** : Charge navigation.json et homePage
2. **build** : Construit Scaffold avec BottomNavigationBar
3. **dispose** : Nettoie les ressources

### Structure

```dart
class ScreenBuilderPage extends StatefulWidget {
  final ScreenConfig config;

  @override
  State<ScreenBuilderPage> createState() => _ScreenBuilderPageState();
}
```

### État interne

```dart
class _ScreenBuilderPageState extends State<ScreenBuilderPage> {
  Map<String, dynamic>? _navigation;
  Widget? _currentBody;
  int _currentIndex = 0;
}
```

## ComponentRegistry

### Description

Registre global des builders de composants.

### Fonctionnement

- **Enregistrement** : Composants enregistrés au démarrage
- **Résolution** : Recherche du builder approprié
- **Cache** : Builders mis en cache pour performance

### Exemple d'enregistrement

```dart
ComponentRegistry().register('text', TextBuilder());
ComponentRegistry().register('button', ButtonBuilder());
```

## PageEngine

### Description

Moteur responsable du rendu des pages JSON.

### Méthodes principales

#### buildPage(BuildContext context, PageModel page)

Construit un widget à partir d'un modèle de page.

#### buildComponentSpec(Map<String, dynamic> component)

Construit récursivement les composants enfants.

### Gestion d'erreurs

En cas de composant inconnu :
- Log d'erreur
- Rendu d'un widget d'erreur
- Continuation du rendu des autres composants

## SpecsRenderer

### Description

Renderer spécialisé pour les ComponentSpec.

### Méthodes

#### render(BuildContext context, ComponentSpec spec)

Rend un ComponentSpec en widget Flutter.

#### _renderColumn, _renderRow, etc.

Méthodes privées pour chaque type de composant.

### Optimisations

- **Key optimization** : Utilisation de clés appropriées
- **Const widgets** : Widgets constants quand possible
- **Lazy building** : Construction à la demande

## DIContainer

### Description

Conteneur d'injection de dépendances.

### Utilisation

```dart
final navHandle = DIContainer().get<NavigationHandle>('navigation');
```

### Avantages

- **Découplage** : Classes indépendantes
- **Testabilité** : Injection de mocks facile
- **Flexibilité** : Changement d'implémentation sans modification

## EventHandle

### Description

Bus d'événements pour la communication inter-composants.

### Méthodes

#### subscribe(String event, Function callback)

S'abonne à un événement.

#### publish(String event, dynamic data)

Publie un événement.

### Exemple

```dart
// Abonnement
eventHandle.subscribe('navigation_changed', (data) {
  print('Navigation vers: ${data['route']}');
});

// Publication
eventHandle.publish('navigation_changed', {'route': 'home'});
```

## Gestion des erreurs

### NavigationError

Classe d'erreur spécialisée pour les problèmes de navigation.

```dart
class NavigationError extends Error {
  final String route;
  final String reason;

  NavigationError(this.route, this.reason);
}
```

### Gestion globale

Toutes les erreurs sont capturées et loggées :

```dart
try {
  await navigationHandle.execute(context);
} catch (e) {
  debugPrint('Navigation error: $e');
  // Fallback vers page d'accueil
}
```

## Tests

### Unit tests

Chaque composant a ses propres tests unitaires.

### Integration tests

Tests de bout en bout pour les scénarios de navigation complets.

### Mocking

Utilisation de mocks pour isoler les dépendances externes.