# Screen Builder - Architecture Modulaire

## Vue d'ensemble

Le Screen Builder est conçu pour être un système modulaire où chaque composant est faiblement couplé et hautement cohésif. L'architecture favorise la réutilisabilité, la maintenabilité et l'extensibilité grâce à des packages autonomes et des interfaces explicites.

## Principes Architecturaux

### 1. Faible Couplage
- Chaque module minimise ses dépendances externes.
- Communication via interfaces explicites ou bus d'événements centralisé.
- Utilisation du pattern Singleton pour les services partagés (ComponentRegistry, ResolverManager, EventBus).

### 2. Haute Cohésion
- Chaque composant a une responsabilité claire et unique.
- Regrouper toutes les fonctions liées à son rôle (UI, logique, état) sans disperser les responsabilités.

### 3. Modificabilité Limitée
- Les modifications ou ajouts se limitent au module concerné.
- Pas de changements massifs dans le reste du système.

### 4. Réutilisabilité et Extensibilité
- Architecture orientée vers des packages autonomes.
- Possibilité d'ajouter de nouveaux composants sans modifier le cœur.

## Structure Modulaire

### Core Interfaces (`lib/core/interfaces.dart`)
- `ComponentBuilder`: Interface pour construire des widgets à partir de props.
- `Resolver<T>`: Interface générique pour résoudre des tokens ou valeurs.
- `ComponentRegistry`: Registre des constructeurs de composants.
- `ResolverManager`: Gestionnaire des résolveurs.

### 🆕 Handle System (`lib/handle/`)
- `Handle`: Interface commune pour tous les handles (ActionHandle, EventHandle, NavigationHandle)
- `ActionHandle`: Gestion centralisée des actions utilisateur (navigate, api_get, api_post, custom)
- `EventHandle`: Bus d'événements intégré avec pattern publish/subscribe
- `NavigationHandle`: Navigation flexible avec stratégies interchangeables

### 🆕 Utilitaires Centralisés (`lib/engine/utils/`)
- `ApiUtil`: Utilitaire partagé pour les opérations API
- `BuilderUtil`: Utilitaire partagé pour la construction de composants
- `ResolverUtil`: Utilitaire partagé pour la résolution de tokens
- `ValidatorUtil`: Utilitaire partagé pour la validation

### Composants (`lib/components/`)
- Séparés en UI et Layout.
- Chaque composant implémente `ComponentBuilder`.
- Responsabilités claires : rendu UI uniquement, logique déléguée aux handles.

### Moteurs (`lib/engine/`)
- `PageEngine`: Construction des pages à partir de JSON.
- `SpecsRenderer`: Rendu unique des ComponentSpec en widgets Flutter.
- `DataResolver`: Résolution des propriétés et tokens.
- `ActionEngine`: Exécution des actions (navigation, API, etc.).
- `EventBus`: Gestion des événements.

### Résolveurs (`lib/engine/resolvers/`)
- `ColorResolver`, `SpacingResolver`, etc. : Implémentent `Resolver<T>`.
- Séparation des préoccupations : chaque résolveur gère un type spécifique.

### Registre (`lib/registry/`)
- `ComponentRegistry`: Enregistrement des composants.
- `default_components.dart`: Enregistrement des composants par défaut.

### Bootstrap (`lib/bootstrap.dart`)
- Initialisation du système : enregistrement des résolveurs et composants.
- Configuration centralisée des handles et utilitaires.

## Flux de Données

1. **Chargement JSON** : PageEngine reçoit une structure JSON.
2. **Construction Composant** : Récupérer le builder depuis ComponentRegistry.
3. **Résolution Props** : ResolverUtil résout les tokens et valeurs.
4. **Validation** : ValidatorUtil vérifie l'intégrité des données.
5. **Rendu** : SpecsRenderer transforme ComponentSpec → Widget Flutter.
6. **Actions/Événements** : Actions exécutées via ActionHandle, événements via EventHandle.

## Extensibilité

- **Nouveaux Composants** : Implémenter `ComponentBuilder` et enregistrer dans ComponentRegistry.
- **Nouveaux Handles** : Étendre `Handle` et enregistrer dans DIContainer.
- **Nouveaux Utilitaires** : Ajouter des utilitaires dans `engine/utils/`.
- **Nouveaux Résolveurs** : Implémenter `Resolver<T>` et enregistrer dans ResolverManager.
- **Plugins** : Possibilité d'ajouter des packages externes pour étendre les fonctionnalités.

## Avantages

- **Maintenabilité** : Modifications isolées aux modules concernés.
- **Testabilité** : Interfaces permettent des mocks faciles, handles testables indépendamment.
- **Réutilisabilité** : Composants, handles et utilitaires réutilisables dans différents contextes.
- **Performance** : Lazy loading et singletons évitent les instanciations inutiles.
- **Centralisation** : Logique métier concentrée dans les handles pour une meilleure observabilité.

Cette architecture assure un système robuste, évolutif et facile à maintenir avec une séparation claire des responsabilités et une centralisation intelligente de la logique métier.