# Documentation Screen Builder Navigation

## Vue d'ensemble

Cette documentation fournit un guide complet pour comprendre et utiliser le système de navigation Screen Builder, un framework Flutter permettant de construire des interfaces utilisateur de manière déclarative via des fichiers JSON.

## Architecture du système

Le système Screen Builder repose sur une architecture modulaire composée de plusieurs couches :

- **Configuration** : Fichiers JSON définissant la structure des pages et la navigation
- **Parsing** : Conversion des spécifications JSON en widgets Flutter
- **Navigation** : Gestion des transitions et de l'historique
- **Actions** : Exécution d'opérations (navigation, API, état)
- **État** : Gestion des données et de l'état de l'application

## Démarrage rapide

### Installation

```yaml
dependencies:
  screen_builder:
    path: packages/screen_builder
```

### Configuration minimale

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:screen_builder/screen_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScreenConfig(
        navigationPath: 'assets/pages/navigation.json',
        child: ScreenBuilderPage(),
      ),
    );
  }
}
```

```json
// assets/pages/navigation.json
{
  "navigation": {
    "type": "bottom",
    "items": [
      {
        "label": "Accueil",
        "icon": "home",
        "page": "home"
      }
    ]
  }
}
```

### Structure automatique (Nouvelle approche recommandée)

Plus besoin de définir explicitement `component: "screen"` ! Le système détecte automatiquement la structure :

```json
// assets/pages/home.json - Structure automatique !
{
  "title": "Bienvenue",
  "appBar": {
    "component": "appbar",
    "props": {
      "title": "Bienvenue",
      "backgroundColor": "#000000"
    }
  },
  "children": [
    {
      "component": "column",
      "children": [
        { "component": "text", "props": { "text": "Hello from sample page" } },
        { "component": "container", "props": { "height": 16.0 } },
        {
          "component": "text",
          "props": { "text": "Items: Item 1, Item 2, Item 3" }
        }
      ]
    }
  ]
}
```

### Structure explicite (Legacy)

Pour un contrôle total ou des cas complexes :

```json
// assets/pages/home.json - Structure explicite
{
  "component": "screen",
  "props": {
    "title": "Sample Page",
    "appBar": {
      "title": "Bienvenue",
      "backgroundColor": "#000000"
    }
  },
  "children": [...]
}
```

## Structure de la documentation

### 📋 [Sommaire](SUMMARY.md)
Aperçu général du système et de ses composants principaux.

### 🏗️ Architecture
- **[Concepts fondamentaux](architecture/concepts.md)** : Principes de base et architecture
- **[Composants système](components.md)** : Vue d'ensemble des composants
- **[Flux de données](data-flow.md)** : Comment les données circulent

### ⚙️ Configuration
- **[Navigation JSON](configuration/navigation-json.md)** : Structure du fichier navigation.json
- **[Structure des pages](page-structure.md)** : Format des pages JSON

### 🎯 Fonctionnalités
- **[Actions de navigation](navigation-actions.md)** : Système d'actions et événements
- **[Gestion d'état](state-management.md)** : Patterns de gestion d'état
- **[Stratégies](strategies.md)** : Différentes stratégies de navigation

### 🔧 Implémentation
- **[NavigationHandle](implementation/navigation-handle.md)** : Classe principale de navigation

### 🐛 Debugging
- **[Outils de debug](debugging/tools.md)** : Utilitaires de développement
- **[Logs et traces](debugging/logs.md)** : Système de logging

### 🚨 Dépannage
- **[Guide de dépannage](troubleshooting.md)** : Résolution des problèmes courants

### 💡 [Exemples](examples.md)
Exemples pratiques d'utilisation avancée.

## Concepts clés

## Concepts clés

### Structure automatique intelligente

Au lieu d'écrire du code complexe, décrivez simplement votre contenu :

**Avant (Structure explicite) :**
```json
{
  "component": "screen",
  "props": {
    "appBar": {
      "component": "appbar",
      "props": { "title": "Mon App" }
    }
  },
  "children": [...]
}
```

**Après (Structure automatique) :**
```json
{
  "title": "Mon App",
  "children": [...]
}
```

Le système génère automatiquement la structure screen appropriée !

### Actions système

Les interactions utilisateur déclenchent des actions :

```json
{
  "component": "elevated_button",
  "onPressed": {
    "action": "navigate",
    "params": {"route": "profile"}
  }
}
```

### Composants extensibles

Le système utilise un registre de builders pour transformer les spécifications JSON en widgets :

```dart
// Enregistrement d'un builder personnalisé
ComponentRegistry.register('my_component', (spec) {
  return MyCustomWidget(
    title: spec['title'],
    onTap: spec['onTap'],
  );
});
```
  "onPressed": {
    "action": "navigate",
    "params": {"route": "profile"}
  }
}
```

### Composants extensibles

Le système utilise un registre de builders pour transformer les spécifications JSON en widgets :

```dart
// Enregistrement d'un builder personnalisé
ComponentRegistry.register('my_component', (spec) {
  return MyCustomWidget(
    title: spec['title'],
    onTap: spec['onTap'],
  );
});
```

## Avantages

### 🚀 Développement rapide
- Interfaces construites sans code Dart
- Modification à chaud des écrans
- Réutilisation de composants

### 🔧 Maintenance facile
- Séparation claire entre logique et présentation
- Configuration centralisée
- Tests automatisés simplifiés

### 📱 Flexibilité
- Support de toutes les plateformes Flutter
- Intégration facile avec des services externes
- Personnalisation avancée possible

### 🐛 Debugging puissant
- Logs détaillés
- Outils de validation
- Mode debug intégré

## Support et contribution

### Signaler un bug
Utilisez les outils de debugging pour collecter des informations, puis créez une issue avec :
- Description du problème
- Logs pertinents
- Configuration utilisée
- Étapes de reproduction

### Contribuer
1. Fork le projet
2. Créez une branche pour votre fonctionnalité
3. Ajoutez des tests
4. Soumettez une pull request

### Ressources
- [Guide de migration](migration.md) (à venir)
- [API Reference](api.md) (à venir)
- [Cookbook](cookbook.md) (à venir)

---

*Cette documentation est maintenue avec le projet Screen Builder. Dernière mise à jour : ${new Date().toISOString().split('T')[0]}*