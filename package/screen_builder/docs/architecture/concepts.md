# Concepts fondamentaux de la navigation

## Vue d'ensemble

Le système de navigation du Screen Builder est basé sur une architecture modulaire qui sépare la logique de navigation de la présentation UI. Il utilise des fichiers JSON pour définir la structure de navigation et des stratégies interchangeables pour la gestion des transitions.

## Principes clés

### 1. Navigation déclarative

La navigation est définie de manière déclarative dans des fichiers JSON plutôt que dans le code Dart. Cela permet :

- **Séparation des préoccupations** : La logique métier est séparée de la présentation
- **Maintenance facile** : Modifications sans recompilation
- **Réutilisabilité** : Même structure de navigation pour différentes plateformes

### 2. Architecture basée sur les handles

Le système utilise un pattern Handle pour centraliser la gestion des interactions :

```dart
abstract class Handle {
  void registerDefaults();
  Future<void> execute(Map<String, dynamic> context);
  bool validateContext(Map<String, dynamic> context);
  void dispose();
}
```

### 3. Stratégies de navigation

Le système supporte différentes stratégies de navigation via le pattern Strategy :

```dart
abstract class NavigationStrategy {
  void navigate(BuildContext context, String route, Map<String, dynamic>? params);
  void goBack(BuildContext context);
  bool canNavigate(String route);
}
```

## Composants principaux

### NavigationHandle

Classe centrale qui orchestre la navigation :

- **Enregistrement des stratégies** : Support de différentes implémentations
- **Validation des routes** : Vérification de l'existence des pages
- **Gestion des paramètres** : Passage de données entre pages
- **Événements** : Publication d'événements de navigation

### ScreenBuilderPage

Widget principal qui rend les pages :

- **Chargement dynamique** : Pages chargées depuis assets/
- **Cache intelligent** : Réutilisation des pages déjà chargées
- **Gestion d'erreurs** : Fallback en cas de page manquante

### ComponentRegistry

Registre des composants UI :

- **Enregistrement automatique** : Composants enregistrés au démarrage
- **Builders spécialisés** : Chaque composant a son propre builder
- **Extensibilité** : Ajout facile de nouveaux composants

## Flux de navigation

### 1. Initialisation

```dart
await initScreenBuilder(
  config: ScreenConfig(
    homePage: 'home',
    navigationFile: 'assets/pages/navigation.json',
  ),
);
```

### 2. Chargement de la navigation

Le fichier `navigation.json` est chargé et analysé pour créer la BottomNavigationBar.

### 3. Navigation utilisateur

Lorsqu'un utilisateur tape sur un élément de navigation :

1. `NavigationHandle.execute()` est appelé
2. La stratégie appropriée est sélectionnée
3. La transition est effectuée
4. Les événements sont publiés

### 4. Actions dans les pages

Les boutons peuvent déclencher des actions de navigation :

```json
{
  "component": "button",
  "props": {
    "text": "Voir détails",
    "action": {
      "type": "navigate",
      "action": "navigate",
      "params": {"route": "details", "id": 123}
    }
  }
}
```

## Gestion d'état

### État local

Chaque page gère son propre état via les composants.

### État global

Le `NavigationHandle` maintient l'état de navigation global :

- Page actuelle
- Historique de navigation
- Paramètres actifs

### Persistance

L'état peut être persisté via SharedPreferences pour maintenir la navigation entre sessions.

## Sécurité et validation

### Validation des routes

Toutes les routes sont validées avant navigation :

- Existence du fichier JSON
- Structure valide
- Permissions utilisateur (si applicable)

### Gestion d'erreurs

En cas d'erreur de navigation :

- Page d'erreur générique
- Logs détaillés
- Fallback vers la page d'accueil

## Performance

### Optimisations

- **Lazy loading** : Pages chargées à la demande
- **Cache** : Composants réutilisés
- **Arbre de widgets optimisé** : Reconstruction minimale

### Métriques

Le système fournit des métriques de performance :

- Temps de chargement des pages
- Taille des assets
- Utilisation mémoire