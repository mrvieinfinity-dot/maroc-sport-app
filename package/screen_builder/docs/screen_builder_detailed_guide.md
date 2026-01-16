# Screen Builder - Documentation Détaillée

## Vue d'ensemble

Screen Builder est un package Flutter permettant de construire des interfaces utilisateur dynamiques à partir de configurations JSON. Il offre une approche déclarative pour créer des écrans, facilitant la maintenance et les mises à jour sans recompilation.

## Architecture Générale

Le package suit une architecture modulaire avec séparation des responsabilités :

- **Configuration** : Gestion des paramètres globaux
- **Moteur de Page** : Construction des widgets à partir du JSON
- **Registre de Composants** : Gestion des constructeurs de composants
- **Résolveurs** : Conversion des tokens et données
- **Navigation** : Gestion de la navigation entre pages
- **Actions et Événements** : Gestion des interactions utilisateur

## Classes et Méthodes Principales

### ScreenBuilderConfig

Classe de configuration principale.

**Propriétés :**
- `env` (String) : Environnement ('local', 'staging', 'prod')
- `jsonPath` (String) : Chemin vers les fichiers JSON des pages
- `homePage` (String) : Nom de la page d'accueil
- `navigationFile` (String) : Chemin vers le fichier JSON de navigation
- `apiAdapter` (ApiService?) : Service API personnalisé
- `eventHandlers` (List<EventHandler>?) : Gestionnaires d'événements personnalisés

**Utilité :** Définit tous les paramètres nécessaires au fonctionnement du package.

### ScreenBuilderPage

Widget principal gérant l'affichage des pages.

**Méthodes principales :**
- `initState()` : Initialise la navigation et charge la page d'accueil
- `_loadNavigationAndHomePage()` : Charge la navigation et la page d'accueil
- `_loadPage(String pageName)` : Charge une page spécifique depuis le JSON
- `build(BuildContext context)` : Construit l'interface avec Scaffold, AppBar et BottomNavigationBar

**Utilité :** Point d'entrée de l'interface utilisateur, gère le cycle de vie des pages.

### PageEngine

Moteur responsable de la construction des pages.

**Méthodes principales :**
- `buildPage(PageModel page)` : Construit l'arbre des widgets pour une page
- `buildComponent(Map<String, dynamic> component)` : Construit un composant individuel

**Utilité :** Transforme les données JSON en widgets Flutter fonctionnels.

### ComponentRegistry

Registre singleton pour les constructeurs de composants.

**Méthodes principales :**
- `register(String type, Widget Function(BuildContext, Map<String, dynamic>) builder)` : Enregistre un nouveau constructeur
- `get(String type)` : Récupère un constructeur par type

**Utilité :** Permet l'extension du système avec des composants personnalisés.

### TokenResolver

Résout les tokens (couleurs, espacements, etc.) en valeurs Flutter.

**Méthodes principales :**
- `resolveColor(String? key)` : Convertit une clé de couleur en Color
- `resolveSpacing(String? key)` : Convertit une clé d'espacement en double

**Utilité :** Fournit un système de tokens pour la cohérence visuelle.

### DataResolver

Résout les propriétés des composants.

**Méthodes principales :**
- `resolveProps(Map<String, dynamic> component)` : Résout toutes les propriétés d'un composant

**Utilité :** Prépare les données avant construction des widgets.

### PropsValidator

Valide les propriétés des composants.

**Méthodes principales :**
- `validate(Map<String, dynamic> component)` : Vérifie la validité des propriétés

**Utilité :** Assure l'intégrité des données avant traitement.

### ActionEngine

Gère l'exécution des actions (navigation, API, etc.).

**Méthodes principales :**
- `execute(BuildContext context, dynamic action, Map<String, dynamic> props)` : Exécute une action
- `registerDefaults()` : Enregistre les actions par défaut

**Utilité :** Gère les interactions utilisateur et les effets de bord.

### EventBus

Système de publication/abonnement pour les événements.

**Méthodes principales :**
- `subscribe(String eventType, Function(Event) handler)` : S'abonne à un événement
- `publish(Event event)` : Publie un événement

**Utilité :** Découple les composants et permet la communication asynchrone.

### NavigationAdapter

Adaptateur pour la navigation personnalisée.

**Méthodes principales :**
- `navigate(String route)` : Effectue la navigation

**Utilité :** Abstrait le système de navigation pour l'intégration.

## Composants Disponibles

### Composants UI

#### AppBar (`buildAppBar`)
- **Props :** title, backgroundColor, elevation, centerTitle
- **Utilité :** Barre d'application supérieure

#### Text (`buildText`)
- **Props :** text, style, color, textAlign, maxLines, overflow
- **Utilité :** Affichage de texte stylisé

#### Button (`buildButton`)
- **Props :** text, color, onTap, action
- **Utilité :** Bouton interactif avec actions

#### Image (`buildImage`)
- **Props :** src, width, height, fit, borderRadius
- **Utilité :** Affichage d'images

#### Popup (`buildPopup`)
- **Props :** (écoute les événements)
- **Utilité :** Affichage de notifications (SnackBars)

### Composants de Mise en Page

#### Screen (`buildScreen`)
- **Props :** title, children
- **Utilité :** Conteneur principal de page avec AppBar et corps

#### Column (`buildColumn`)
- **Props :** mainAxisAlignment, crossAxisAlignment, children
- **Utilité :** Disposition verticale des enfants

#### Row (`buildRow`)
- **Props :** mainAxisAlignment, crossAxisAlignment, children
- **Utilité :** Disposition horizontale des enfants

#### Container (`buildContainer`)
- **Props :** width, height, padding, margin, color, borderRadius, child
- **Utilité :** Conteneur avec décoration et contraintes

#### Spacer (`buildSpacer`)
- **Props :** height, width
- **Utilité :** Espace flexible entre composants

## Structure des Fichiers

### Fichiers de Configuration
- `bootstrap.dart` : Initialisation du système
- `screen_builder.dart` : Exports principaux

### Moteur
- `engine/page_engine.dart` : Construction des pages
- `engine/data_resolver.dart` : Résolution des données
- `engine/validators/props_validator.dart` : Validation des propriétés
- `engine/actions/action_engine.dart` : Gestion des actions
- `engine/events/event_bus.dart` : Système d'événements
- `engine/resolvers/token_resolver.dart` : Résolution des tokens

### Composants
- `components/ui/` : Composants d'interface (appbar, text, button, image, popup)
- `components/layout/` : Composants de mise en page (screen, column, row, container, spacer)

### Registre et Modèles
- `registry/component_registry.dart` : Registre des composants
- `registry/default_components.dart` : Enregistrement des composants par défaut
- `models/page_model.dart` : Modèle de données pour les pages

### Navigation et Services
- `navigation/navigation_adapter.dart` : Adaptateur de navigation
- `services/api/api_service.dart` : Service API abstrait

## Processus d'Initialisation

1. `initScreenBuilder()` configure le système
2. Enregistrement des composants par défaut via `registerDefaultComponents()`
3. Initialisation des moteurs (ActionEngine, EventBus)
4. Configuration des services (API, événements)

## Processus de Construction d'une Page

1. Chargement du JSON depuis les assets
2. Parsing en `PageModel`
3. `PageEngine.buildPage()` traite le composant racine
4. Récursivement, `buildComponent()` pour chaque enfant
5. Résolution des propriétés via `DataResolver`
6. Validation via `PropsValidator`
7. Construction du widget via le registre
8. Gestion spéciale pour `Screen` (extraction AppBar)

## Gestion des Tokens

Les tokens sont définis dans `_tokens` (Map<String, dynamic>).

- Couleurs : Clés comme "primary", "white" → valeurs hex
- Espacements : Clés comme "s", "m", "l" → valeurs numériques
- Styles : Pour le texte, etc.

## Système d'Actions

Actions supportées :
- `navigate:pageName` : Navigation vers une page
- `http:get/post` : Appels API
- `custom:actionName` : Actions personnalisées

## Gestion des Événements

Événements prédéfinis :
- `api_success` : Après succès d'API
- `api_error` : Après erreur d'API

## Extension du Système

### Ajouter un Composant Personnalisé

```dart
ComponentRegistry().register('my_component', (context, props) {
  return MyCustomWidget(props: props);
});
```

### Ajouter une Action Personnalisée

```dart
ActionEngine().register('my_action', (context, props) {
  // Logique personnalisée
});
```

### Ajouter un Résolveur de Token

Étendre `TokenResolver` avec de nouvelles méthodes.

## Debugging et Logs

Le système inclut des `debugPrint` dans les méthodes critiques pour tracer l'exécution.

## Limitations et Considérations

- Composants limités aux types enregistrés
- Validation basique des propriétés
- Pas de hot-reload pour les changements JSON
- Navigation limitée aux pages définies

## Exemple Complet

Voir `example/demo_app.dart` pour une implémentation complète.

Cette documentation couvre le fonctionnement détaillé de Screen Builder. Pour des détails spécifiques, consultez le code source commenté.