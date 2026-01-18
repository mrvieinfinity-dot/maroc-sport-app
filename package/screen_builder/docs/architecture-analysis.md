# Architecture Analysis - Screen Builder

## Introduction

Le projet Screen Builder est un package Flutter modulaire conçu pour construire des écrans dynamiquement à partir de fichiers JSON. Il utilise un système de registre de composants pour permettre l'extensibilité, avec une séparation des préoccupations entre UI, logique métier, navigation, et services.

### Architecture actuelle
- **Style** : Feature-first avec un registre central (ComponentRegistry) pour les composants UI.
- **Pas exactement Clean Architecture** : Il y a une couche engine pour la logique, mais les modèles sont simples, et il y a un couplage fort avec Flutter (widgets directement dans les builders).
- **Forces** :
  - Modulaire : Facile d'ajouter de nouveaux composants via le registre.
  - Dynamique : Construction à partir de JSON permet des changements sans recompilation.
  - Séparation : Dossiers distincts pour components, engine, navigation, etc.
- **Faiblesses** :
  - Couplage fort : Les builders retournent directement des Widgets Flutter, difficile à tester sans Flutter.
  - Hard-coding : Certains resolvers utilisent des tokens hard-codés.
  - Navigation limitée : Pas de nested navigation complexe, seulement bottom nav.
  - DI basique : Container simple, pas d'injection automatique.

## Liste détaillée des dossiers

### components/
**Rôle** : Contient les builders de composants UI, organisés en sous-dossiers custom, layout, ui.

- **Fichiers clés** :
  - ui/button.dart : ButtonBuilder, classe implémentant ComponentBuilder pour créer des ElevatedButton.
  - ui/text.dart : TextBuilder pour afficher du texte.
  - layout/screen.dart : ScreenBuilder pour Scaffold.
  - custom/card.dart : CardBuilder pour cartes personnalisées.

- **Fonctions/classes principales** :
  - ButtonBuilder.build() : Construit un bouton avec action via ActionEngine.
  - TextBuilder.build() : Construit un Text widget.

- **Utilisation** : Appelées par PageEngine.buildComponent() quand le type correspond. Dépend de ResolverManager pour résoudre les props.

### composers/
**Rôle** : Compositeurs pour assembler les pages ou composants.

- **Fichiers clés** :
  - page_composer.dart : PageComposer pour composer des pages.

- **Fonctions/classes** :
  - PageComposer.compose() : Assemble une page à partir de composants.

- **Utilisation** : Enregistré dans DI container, utilisé dans bootstrap.

### config/
**Rôle** : Configuration globale.

- **Fichiers clés** :
  - screen_config.dart : ScreenConfig classe pour config (homePage, navigationFile, etc.).

- **Utilisation** : Passé à initScreenBuilder, stocké globalement.

### constants/
**Rôle** : Constantes comme couleurs, styles.

- **Fichiers clés** :
  - colors.dart : Couleurs définies.
  - design_system/ : Thèmes light/dark.

### core/
**Rôle** : Interfaces et utilitaires core.

- **Fichiers clés** :
  - interfaces.dart : ComponentBuilder, etc.
  - builders/builders.dart : Builders génériques.
  - utils/utils.dart : Utilitaires.

- **Fonctions/classes** :
  - ComponentBuilder.build() : Interface pour builders.

### di/
**Rôle** : Dependency Injection.

- **Fichiers clés** :
  - container.dart : DIContainer pour enregistrer/récupérer services.

- **Utilisation** : Utilisé dans bootstrap pour enregistrer ApiService, EventBus, etc.

### engine/
**Rôle** : Moteur pour actions, événements, resolvers.

- **Sous-dossiers** :
  - actions/ : ActionEngine pour exécuter actions.
  - events/ : EventBus, EventHandler.
  - resolvers/ : DataResolver, TokenResolver.

- **Fichiers clés** :
  - page_engine.dart : PageEngine.buildPage(), buildComponent().

- **Utilisation** : PageEngine appelé dans ScreenBuilderPage._loadPage().

### models/
**Rôle** : Modèles de données.

- **Fichiers clés** :
  - page_model.dart : PageModel(id, components).
  - action_model.dart : ActionModel.
  - api_request.dart, api_response.dart : Pour API.

### modules/
**Rôle** : Modules spécifiques (vide ou partiel).

### navigation/
**Rôle** : Gestion de la navigation.

- **Fichiers clés** :
  - navigation_service.dart : NavigationService.navigate().
  - route_registry.dart : RouteRegistry pour enregistrer routes.
  - json_page_navigator.dart : Navigation basée JSON.

- **Utilisation** : Utilisé dans ScreenBuilderPage pour bottom nav.

### registry/
**Rôle** : Registre des composants.

- **Fichiers clés** :
  - component_registry.dart : ComponentRegistry singleton.
  - default_components.dart : registerDefaultComponents().

- **Utilisation** : Central pour récupérer builders par type.

### services/
**Rôle** : Services comme API.

- **Fichiers clés** :
  - api/api_service.dart : ApiService.get(), post().
  - token_manager.dart : Gestion tokens.

- **Utilisation** : ApiService utilisé dans actions probablement.

## Points critiques
- **Couplages forts** : Builders directement liés à Flutter Widgets.
- **Navigation** : Seulement bottom nav, pas de nested.
- **Hard-coding** : Tokens dans resolvers, URLs dans config.
- **Testabilité** : Difficile sans mocks pour Flutter.

## Suggestions préliminaires pour refonte composable
- Introduire une couche d'abstraction pour les UI (ex. ViewModels).
- Améliorer DI avec injection automatique.
- Séparer logique de présentation.
- Ajouter support pour navigation nested.</content>
<parameter name="filePath">c:\Users\pc\Downloads\maroc_sport_copie-main\package\screen_builder\docs\architecture-analysis.md