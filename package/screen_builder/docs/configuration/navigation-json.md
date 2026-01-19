# Configuration du fichier navigation.json

## Vue d'ensemble

Le fichier `navigation.json` définit la structure de navigation de l'application, notamment les éléments de la BottomNavigationBar et leurs propriétés.

## Emplacement

Par défaut : `assets/pages/navigation.json`

Peut être configuré via `ScreenConfig.navigationFile`.

## Structure JSON

### Schéma complet

```json
{
  "items": [
    {
      "label": "string",
      "icon": "string",
      "page": "string",
      "badge": "string?",
      "enabled": "boolean?",
      "params": "object?"
    }
  ],
  "options": {
    "backgroundColor": "string?",
    "selectedItemColor": "string?",
    "unselectedItemColor": "string?",
    "showSelectedLabels": "boolean?",
    "showUnselectedLabels": "boolean?",
    "type": "string?"
  }
}
```

## Propriétés des éléments

### label (requis)

Texte affiché sous l'icône.

```json
{
  "label": "Accueil",
  "icon": "home",
  "page": "home"
}
```

### icon (requis)

Nom de l'icône Material Design.

**Icônes communes :**
- `home` - Icons.home
- `person` - Icons.person
- `settings` - Icons.settings
- `search` - Icons.search
- `favorite` - Icons.favorite

### page (requis)

Nom du fichier JSON de la page (sans extension).

```json
{
  "label": "Profil",
  "icon": "person",
  "page": "profile"
}
```

Correspond à `assets/pages/profile.json`.

### badge (optionnel)

Texte du badge affiché sur l'icône.

```json
{
  "label": "Messages",
  "icon": "message",
  "page": "messages",
  "badge": "3"
}
```

### enabled (optionnel)

Détermine si l'élément est cliquable. Défaut : `true`.

```json
{
  "label": "Premium",
  "icon": "star",
  "page": "premium",
  "enabled": false
}
```

### params (optionnel)

Paramètres passés à la page lors de la navigation.

```json
{
  "label": "Détails",
  "icon": "info",
  "page": "details",
  "params": {
    "id": 123,
    "category": "sports"
  }
}
```

## Options globales

### backgroundColor

Couleur de fond de la barre de navigation.

```json
{
  "options": {
    "backgroundColor": "#FFFFFF"
  }
}
```

### selectedItemColor

Couleur des éléments sélectionnés.

```json
{
  "options": {
    "selectedItemColor": "#FF0000"
  }
}
```

### unselectedItemColor

Couleur des éléments non sélectionnés.

```json
{
  "options": {
    "unselectedItemColor": "#666666"
  }
}
```

### showSelectedLabels

Afficher les labels des éléments sélectionnés. Défaut : `true`.

```json
{
  "options": {
    "showSelectedLabels": true
  }
}
```

### showUnselectedLabels

Afficher les labels des éléments non sélectionnés. Défaut : `true`.

```json
{
  "options": {
    "showUnselectedLabels": false
  }
}
```

### type

Type de BottomNavigationBar. Valeurs : `"fixed"` ou `"shifting"`. Défaut : `"fixed"`.

```json
{
  "options": {
    "type": "shifting"
  }
}
```

## Exemples complets

### Navigation simple

```json
{
  "items": [
    {
      "label": "Home",
      "icon": "home",
      "page": "home"
    },
    {
      "label": "Profile",
      "icon": "person",
      "page": "profile"
    }
  ]
}
```

### Navigation avec options

```json
{
  "items": [
    {
      "label": "Home",
      "icon": "home",
      "page": "home"
    },
    {
      "label": "Search",
      "icon": "search",
      "page": "search"
    },
    {
      "label": "Profile",
      "icon": "person",
      "page": "profile"
    }
  ],
  "options": {
    "backgroundColor": "#FFFFFF",
    "selectedItemColor": "#FF0000",
    "unselectedItemColor": "#666666",
    "showSelectedLabels": true,
    "showUnselectedLabels": false
  }
}
```

### Navigation avec badges et paramètres

```json
{
  "items": [
    {
      "label": "Home",
      "icon": "home",
      "page": "home"
    },
    {
      "label": "Messages",
      "icon": "message",
      "page": "messages",
      "badge": "5"
    },
    {
      "label": "Profile",
      "icon": "person",
      "page": "profile",
      "params": {
        "userId": 123
      }
    }
  ]
}
```

## Validation

### Règles de validation

1. **Structure requise** : `items` doit être un tableau
2. **Éléments requis** : Chaque élément doit avoir `label`, `icon`, et `page`
3. **Types** : Tous les champs doivent avoir les types corrects
4. **Pages existantes** : Les fichiers `page.json` doivent exister
5. **Icônes valides** : Les icônes doivent être des noms Material Design valides

### Erreurs communes

#### Page manquante

```json
{
  "label": "Settings",
  "icon": "settings",
  "page": "settings"  // Erreur: settings.json n'existe pas
}
```

**Solution** : Créer le fichier `assets/pages/settings.json`

#### Icône invalide

```json
{
  "label": "Home",
  "icon": "maison",  // Erreur: icône inconnue
  "page": "home"
}
```

**Solution** : Utiliser un nom d'icône valide comme `"home"`

#### Structure invalide

```json
{
  "items": {
    "home": {  // Erreur: doit être un tableau
      "label": "Home",
      "icon": "home",
      "page": "home"
    }
  }
}
```

**Solution** : Utiliser un tableau pour `items`

## Bonnes pratiques

### Organisation

- Grouper les éléments logiquement
- Utiliser des noms descriptifs pour les pages
- Maintenir la cohérence des icônes

### Performance

- Limiter à 5 éléments maximum pour une bonne UX
- Utiliser des icônes légères
- Éviter les badges trop longs

### Accessibilité

- Labels clairs et concis
- Icônes reconnaissables
- Contraste suffisant pour les couleurs

## Debugging

### Vérification du chargement

```dart
// Dans ScreenBuilderPage
print('Navigation loaded: $_navigation');
```

### Validation des pages

```dart
// Vérifier l'existence des fichiers
final pageFile = File('assets/pages/${item.page}.json');
if (!await pageFile.exists()) {
  print('Page file missing: ${item.page}.json');
}
```

### Logs de navigation

```dart
// Activer les logs détaillés
debugPrint('Navigating to: ${item.page}');
```

## Migration

### Depuis une navigation codée en dur

1. Créer `navigation.json`
2. Déplacer la logique dans les fichiers JSON
3. Tester chaque élément
4. Supprimer l'ancien code

### Mise à jour de structure

Pour ajouter de nouveaux champs sans casser la compatibilité :

```json
{
  "items": [
    {
      "label": "Home",
      "icon": "home",
      "page": "home",
      "newField": "value"  // Nouveau champ optionnel
    }
  ]
}
```