# Structure des pages JSON

## Vue d'ensemble

Chaque page de l'application est définie dans un fichier JSON séparé dans le dossier `assets/pages/`. Ces fichiers décrivent la structure UI de manière déclarative.

## Structure de base

### Schéma général

```json
{
  "component": "screen",
  "props": {
    "title": "string",
    "appBar": {
      "title": "string",
      "backgroundColor": "string"
    }
  },
  "children": [
    // Composants enfants
  ]
}
```

## Composants principaux

### screen

Conteneur principal de la page.

**Propriétés :**
- `title` (string) : Titre de la page
- `appBar` (object) : Configuration de l'AppBar

**Exemple :**
```json
{
  "component": "screen",
  "props": {
    "title": "Accueil",
    "appBar": {
      "title": "Bienvenue",
      "backgroundColor": "#000000"
    }
  },
  "children": [...]
}
```

### column

Layout vertical.

**Propriétés :**
- `mainAxisAlignment` (string) : Alignement principal (start, center, end, spaceBetween, spaceAround, spaceEvenly)
- `crossAxisAlignment` (string) : Alignement transversal (start, center, end, stretch)
- `spacing` (number) : Espacement entre enfants

**Exemple :**
```json
{
  "component": "column",
  "props": {
    "mainAxisAlignment": "center",
    "crossAxisAlignment": "center",
    "spacing": 16.0
  },
  "children": [...]
}
```

### row

Layout horizontal.

**Propriétés :** Similaires à `column`

### text

Affichage de texte.

**Propriétés :**
- `text` (string) : Texte à afficher
- `style` (object) : Style du texte
- `textAlign` (string) : Alignement (left, center, right, justify)

**Exemple :**
```json
{
  "component": "text",
  "props": {
    "text": "Hello World",
    "style": {
      "fontSize": 24,
      "fontWeight": "bold",
      "color": "#FF0000"
    },
    "textAlign": "center"
  }
}
```

### container

Conteneur générique.

**Propriétés :**
- `width` (number) : Largeur
- `height` (number) : Hauteur
- `color` (string) : Couleur de fond
- `padding` (object) : Padding interne
- `margin` (object) : Marge externe

**Exemple :**
```json
{
  "component": "container",
  "props": {
    "height": 100,
    "color": "#F0F0F0",
    "padding": {
      "all": 16
    }
  },
  "children": [...]
}
```

### button

Bouton interactif.

**Propriétés :**
- `text` (string) : Texte du bouton
- `action` (object) : Action à exécuter
- `style` (object) : Style du bouton

**Exemple :**
```json
{
  "component": "button",
  "props": {
    "text": "Voir détails",
    "action": {
      "type": "navigate",
      "action": "navigate",
      "params": {
        "route": "details"
      }
    }
  }
}
```

## Actions

### navigate

Navigation vers une autre page.

**Paramètres :**
- `route` (string) : Nom de la page cible
- `params` (object, optionnel) : Paramètres à passer

**Exemple :**
```json
{
  "action": {
    "type": "navigate",
    "action": "navigate",
    "params": {
      "route": "profile",
      "userId": 123
    }
  }
}
```

### api_get

Appel API GET.

**Paramètres :**
- `url` (string) : URL de l'API
- `onSuccess` (object) : Action en cas de succès
- `onError` (object) : Action en cas d'erreur

### custom

Action personnalisée.

**Paramètres :**
- `actionId` (string) : Identifiant de l'action
- `params` (object) : Paramètres personnalisés

## Styles et thèmes

### Couleurs

Utiliser des noms de couleurs définis ou des codes hex :

```json
{
  "color": "#FF0000",
  "color": "primary",
  "color": "Colors.red"
}
```

### Espacement

Utiliser des valeurs numériques ou des tokens :

```json
{
  "padding": 16,
  "padding": "small",
  "padding": {
    "all": 16
  },
  "padding": {
    "horizontal": 16,
    "vertical": 8
  }
}
```

### Text styles

```json
{
  "style": {
    "fontSize": 18,
    "fontWeight": "bold",
    "color": "#333333",
    "letterSpacing": 0.5
  }
}
```

## Exemples complets

### Page d'accueil simple

```json
{
  "component": "screen",
  "props": {
    "title": "Accueil",
    "appBar": {
      "title": "Bienvenue"
    }
  },
  "children": [
    {
      "component": "column",
      "props": {
        "mainAxisAlignment": "center",
        "crossAxisAlignment": "center"
      },
      "children": [
        {
          "component": "text",
          "props": {
            "text": "Hello World",
            "style": {
              "fontSize": 24,
              "fontWeight": "bold"
            }
          }
        },
        {
          "component": "container",
          "props": {
            "height": 16
          }
        },
        {
          "component": "button",
          "props": {
            "text": "Continuer",
            "action": {
              "type": "navigate",
              "action": "navigate",
              "params": {
                "route": "menu"
              }
            }
          }
        }
      ]
    }
  ]
}
```

### Page avec liste

```json
{
  "component": "screen",
  "props": {
    "title": "Liste",
    "appBar": {
      "title": "Mes éléments"
    }
  },
  "children": [
    {
      "component": "list",
      "props": {
        "scrollDirection": "vertical"
      },
      "children": [
        {
          "component": "card",
          "props": {
            "elevation": 4
          },
          "children": [
            {
              "component": "text",
              "props": {
                "text": "Élément 1"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

## Validation

### Règles de validation

1. **Composant racine** : Doit être de type "screen"
2. **Structure** : Chaque composant doit avoir "component" et "props"
3. **Enfants** : "children" doit être un tableau si présent
4. **Actions** : Les actions doivent avoir "type" et "action"
5. **Types** : Tous les champs doivent avoir les types corrects

### Outil de validation

```dart
bool validatePageStructure(Map<String, dynamic> json) {
  // Validation récursive
  return _validateComponent(json);
}

bool _validateComponent(Map<String, dynamic> component) {
  if (!component.containsKey('component')) return false;

  final type = component['component'];
  if (type != 'screen' && !component.containsKey('props')) return false;

  final children = component['children'];
  if (children != null) {
    if (children is! List) return false;
    for (final child in children) {
      if (!_validateComponent(child)) return false;
    }
  }

  return true;
}
```

## Bonnes pratiques

### Organisation

- Un fichier par page logique
- Noms descriptifs (home.json, profile.json)
- Grouper les pages liées

### Performance

- Éviter les arbres trop profonds
- Utiliser des conteneurs pour grouper
- Lazy loading pour les listes longues

### Maintenabilité

- Commentaires dans le JSON
- Constantes pour les couleurs/réutilisables
- Validation automatique

## Debugging

### Logs de construction

```dart
// Activer les logs détaillés
debugPrint('Building component: ${component['component']}');
```

### Validation à l'exécution

```dart
// Vérifier la structure avant rendu
assert(validatePageStructure(pageJson), 'Invalid page structure');
```

### Outil de prévisualisation

Utiliser l'outil de prévisualisation intégré pour voir les pages sans exécuter l'app.

## Extension

### Ajouter un nouveau composant

1. Créer le builder dans `lib/components/builders/`
2. Enregistrer dans `ComponentRegistry`
3. Documenter dans ce guide

### Actions personnalisées

1. Implémenter dans `ActionHandle`
2. Documenter les paramètres
3. Tester thoroughly