# Actions de navigation

## Vue d'ensemble

Les actions de navigation permettent d'exécuter des opérations complexes depuis les composants UI, comme naviguer vers une page, appeler une API, ou déclencher des actions personnalisées.

## Structure des actions

### Format général

```json
{
  "action": {
    "type": "string",
    "action": "string",
    "params": {
      "key": "value"
    },
    "onSuccess": {
      "type": "string",
      "action": "string"
    },
    "onError": {
      "type": "string",
      "action": "string"
    }
  }
}
```

## Types d'actions

### navigate

Navigation vers une autre page.

**Paramètres :**
- `route` (string, requis) : Nom de la page cible
- `params` (object, optionnel) : Paramètres à passer

**Exemple :**
```json
{
  "component": "button",
  "props": {
    "text": "Voir profil",
    "action": {
      "type": "navigate",
      "action": "navigate",
      "params": {
        "route": "profile",
        "userId": 123
      }
    }
  }
}
```

### api_get

Appel API GET.

**Paramètres :**
- `url` (string, requis) : URL de l'API
- `headers` (object, optionnel) : Headers HTTP
- `queryParams` (object, optionnel) : Paramètres de requête

**Callbacks :**
- `onSuccess` : Action exécutée en cas de succès
- `onError` : Action exécutée en cas d'erreur

**Exemple :**
```json
{
  "component": "button",
  "props": {
    "text": "Charger données",
    "action": {
      "type": "api_get",
      "action": "api_get",
      "params": {
        "url": "https://api.example.com/data",
        "queryParams": {
          "limit": 10
        }
      },
      "onSuccess": {
        "type": "navigate",
        "action": "navigate",
        "params": {
          "route": "results"
        }
      }
    }
  }
}
```

### api_post

Appel API POST.

**Paramètres :**
- `url` (string, requis) : URL de l'API
- `body` (object, requis) : Corps de la requête
- `headers` (object, optionnel) : Headers HTTP

**Exemple :**
```json
{
  "component": "button",
  "props": {
    "text": "Envoyer",
    "action": {
      "type": "api_post",
      "action": "api_post",
      "params": {
        "url": "https://api.example.com/submit",
        "body": {
          "name": "John",
          "email": "john@example.com"
        }
      }
    }
  }
}
```

### custom

Action personnalisée définie dans le code.

**Paramètres :**
- `actionId` (string, requis) : Identifiant de l'action
- `params` (object, optionnel) : Paramètres personnalisés

**Exemple :**
```json
{
  "component": "button",
  "props": {
    "text": "Action spéciale",
    "action": {
      "type": "custom",
      "action": "custom",
      "params": {
        "actionId": "show_dialog",
        "title": "Confirmation",
        "message": "Êtes-vous sûr ?"
      }
    }
  }
}
```

## Gestion des callbacks

### onSuccess

Action exécutée quand l'action principale réussit.

**Exemple :**
```json
{
  "action": {
    "type": "api_get",
    "action": "api_get",
    "params": {
      "url": "https://api.example.com/user"
    },
    "onSuccess": {
      "type": "navigate",
      "action": "navigate",
      "params": {
        "route": "user_details"
      }
    }
  }
}
```

### onError

Action exécutée en cas d'erreur.

**Exemple :**
```json
{
  "action": {
    "type": "api_post",
    "action": "api_post",
    "params": {
      "url": "https://api.example.com/save",
      "body": {"data": "value"}
    },
    "onError": {
      "type": "custom",
      "action": "custom",
      "params": {
        "actionId": "show_error",
        "message": "Erreur de sauvegarde"
      }
    }
  }
}
```

## Chaînage d'actions

### Actions séquentielles

```json
{
  "action": {
    "type": "custom",
    "action": "custom",
    "params": {
      "actionId": "validate_form"
    },
    "onSuccess": {
      "type": "api_post",
      "action": "api_post",
      "params": {
        "url": "https://api.example.com/submit"
      },
      "onSuccess": {
        "type": "navigate",
        "action": "navigate",
        "params": {
          "route": "success"
        }
      }
    }
  }
}
```

## Validation des actions

### Règles de validation

1. **Type requis** : Chaque action doit avoir un `type`
2. **Action requise** : Chaque action doit avoir une `action`
3. **Paramètres** : Selon le type d'action
4. **Callbacks** : `onSuccess` et `onError` doivent être des actions valides

### Validation automatique

```dart
bool validateAction(Map<String, dynamic> action) {
  if (!action.containsKey('type') || !action.containsKey('action')) {
    return false;
  }

  final type = action['type'];
  switch (type) {
    case 'navigate':
      return action['params']?.containsKey('route') ?? false;
    case 'api_get':
    case 'api_post':
      return action['params']?.containsKey('url') ?? false;
    case 'custom':
      return action['params']?.containsKey('actionId') ?? false;
    default:
      return false;
  }
}
```

## Gestion d'erreurs

### Types d'erreurs

- **NetworkError** : Erreur réseau
- **ValidationError** : Données invalides
- **AuthError** : Erreur d'authentification
- **ServerError** : Erreur serveur

### Gestion globale

```dart
class ActionErrorHandler {
  void handleError(String actionType, dynamic error, Map<String, dynamic> context) {
    // Log error
    debugPrint('Action error: $actionType - $error');

    // Execute onError callback if present
    final onError = context['onError'];
    if (onError != null) {
      ActionHandle().execute(onError);
    }
  }
}
```

## Actions asynchrones

### Pattern pour les actions longues

```dart
class AsyncActionExecutor extends ActionExecutor {
  @override
  Future<void> execute(Map<String, dynamic> context) async {
    // Afficher un loader
    showLoadingDialog();

    try {
      // Exécuter l'action
      await performAsyncOperation(context);

      // Masquer le loader
      hideLoadingDialog();

      // Exécuter onSuccess
      final onSuccess = context['onSuccess'];
      if (onSuccess != null) {
        await ActionHandle().execute(onSuccess);
      }
    } catch (e) {
      // Masquer le loader
      hideLoadingDialog();

      // Gérer l'erreur
      ActionErrorHandler().handleError('async_action', e, context);
    }
  }
}
```

## Sécurité

### Validation des entrées

Toutes les entrées utilisateur sont validées :

```dart
bool validateActionParams(String actionType, Map<String, dynamic> params) {
  switch (actionType) {
    case 'navigate':
      return _validateRoute(params['route']);
    case 'api_get':
    case 'api_post':
      return _validateUrl(params['url']);
    default:
      return true;
  }
}
```

### Sanitisation

```dart
Map<String, dynamic> sanitizeParams(Map<String, dynamic> params) {
  return params.map((key, value) {
    if (value is String) {
      return MapEntry(key, _sanitizeString(value));
    }
    return MapEntry(key, value);
  });
}
```

## Performance

### Cache des résultats

```dart
class ActionResultCache {
  final Map<String, dynamic> _cache = {};
  final Duration _ttl = Duration(minutes: 5);

  dynamic get(String key) {
    final entry = _cache[key];
    if (entry != null && entry['expires'] > DateTime.now()) {
      return entry['data'];
    }
    return null;
  }

  void set(String key, dynamic data) {
    _cache[key] = {
      'data': data,
      'expires': DateTime.now().add(_ttl),
    };
  }
}
```

### Optimisations

- **Dédoublonnage** : Éviter les appels API identiques
- **Lazy loading** : Charger les données à la demande
- **Pagination** : Pour les listes longues

## Debugging

### Logs détaillés

```dart
class ActionLogger {
  void logAction(String type, Map<String, dynamic> context, Duration duration) {
    debugPrint('Action: $type');
    debugPrint('Params: ${context['params']}');
    debugPrint('Duration: $duration');
  }
}
```

### Outil de profiling

```dart
class ActionProfiler {
  final Map<String, List<Duration>> _timings = {};

  void recordTiming(String actionType, Duration duration) {
    _timings.putIfAbsent(actionType, () => []).add(duration);
  }

  Map<String, Duration> getAverageTimings() {
    return _timings.map((key, value) {
      final avg = value.reduce((a, b) => a + b) ~/ value.length;
      return MapEntry(key, avg);
    });
  }
}
```

## Extension

### Ajouter une nouvelle action

1. Créer une classe `ActionExecutor`
2. L'enregistrer dans `ActionHandle`
3. Documenter les paramètres
4. Ajouter des tests

### Exemple d'implémentation

```dart
class ShareActionExecutor extends ActionExecutor {
  @override
  Future<void> execute(Map<String, dynamic> context) async {
    final text = context['params']['text'];
    final url = context['params']['url'];

    await Share.share('$text\n$url');
  }
}
```