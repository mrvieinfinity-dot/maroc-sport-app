# Structure des pages JSON

## Vue d'ensemble

Les pages Screen Builder peuvent être définies de deux manières :

1. **Structure explicite** : Définition complète avec `component: "screen"`
2. **Structure automatique** : Le système détecte et génère automatiquement la structure screen

## Structure automatique (Recommandée)

Le système détecte automatiquement quand créer une structure screen basée sur les propriétés présentes :

### Propriétés de détection automatique

- `appBar` : Génère automatiquement une AppBar
- `body` : Définit le contenu principal
- `drawer` : Ajoute un tiroir latéral
- `floatingActionButton` : Bouton d'action flottant
- `bottomNavigationBar` : Barre de navigation inférieure
- `title` : Titre qui devient automatiquement une AppBar

### Exemple simple

```json
{
  "title": "Ma Page",
  "children": [
    {
      "component": "text",
      "props": { "text": "Contenu de la page" }
    }
  ]
}
```

Le système génère automatiquement :
```json
{
  "component": "screen",
  "props": {
    "appBar": {
      "component": "appbar",
      "props": { "title": "Ma Page" }
    }
  },
  "children": [
    {
      "component": "text",
      "props": { "text": "Contenu de la page" }
    }
  ]
}
```

### Exemple avec AppBar personnalisée

```json
{
  "appBar": {
    "component": "appbar",
    "props": {
      "title": "Titre personnalisé",
      "backgroundColor": "#2196F3"
    }
  },
  "children": [
    {
      "component": "column",
      "children": [
        { "component": "text", "props": { "text": "Hello World!" } }
      ]
    }
  ]
}
```

### Exemple avec body explicite

```json
{
  "appBar": {
    "component": "appbar",
    "props": { "title": "Dashboard" }
  },
  "body": {
    "component": "column",
    "children": [
      { "component": "text", "props": { "text": "Contenu principal" } }
    ]
  }
}
```

## Structure explicite (Legacy)

Pour les cas complexes ou pour un contrôle total :

```json
{
  "component": "screen",
  "props": {
    "appBar": {
      "component": "appbar",
      "props": { "title": "Titre" }
    },
    "drawer": {
      "component": "drawer",
      "props": { "items": [...] }
    }
  },
  "children": [
    {
      "component": "column",
      "children": [...]
    }
  ]
}
```

## Avantages de la structure automatique

### 🚀 **Simplicité**
- Moins de code JSON à écrire
- Structure plus intuitive
- Détection automatique des propriétés

### 🔧 **Maintenance**
- Moins d'erreurs de structure
- Code plus lisible
- Évolution plus facile

### 📱 **Flexibilité**
- Support des deux approches
- Migration progressive possible
- Rétrocompatibilité complète

## Migration depuis l'ancienne structure

### Avant (Structure explicite)
```json
{
  "component": "screen",
  "props": { "title": "..." },
  "children": [...]
}
```

### Après (Structure automatique)
```json
{
  "title": "...",
  "children": [...]
}
```

Le système reste entièrement rétrocompatible - les anciennes structures continueront de fonctionner.