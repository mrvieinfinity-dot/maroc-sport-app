# Résolution de problèmes courants

## Vue d'ensemble

Ce guide couvre les problèmes les plus fréquents rencontrés avec le système de navigation et leurs solutions.

## Problèmes de chargement

### "Page not found" lors de la navigation

**Symptômes :**
- Erreur "Unable to load page: [route]"
- Page blanche affichée
- Exception dans la console

**Causes possibles :**
1. Fichier JSON manquant
2. Chemin incorrect dans `navigation.json`
3. Erreur de syntaxe dans le fichier JSON

**Solutions :**

1. **Vérifier l'existence du fichier :**
   ```bash
   ls assets/pages/
   ```

2. **Valider la syntaxe JSON :**
   ```dart
   // Dans le code
   try {
     final jsonData = jsonDecode(fileContent);
     debugPrint('JSON is valid');
   } catch (e) {
     debugPrint('JSON error: $e');
   }
   ```

3. **Vérifier les chemins :**
   ```dart
   // Dans ScreenConfig
   navigationFile: 'assets/pages/navigation.json',
   jsonPath: 'assets/pages/',
   ```

### Chargement lent des pages

**Symptômes :**
- Délai perceptible lors de la navigation
- Interface figée pendant le chargement

**Solutions :**

1. **Activer le cache :**
   ```dart
   class PageCache {
     static final Map<String, PageModel> _cache = {};

     static PageModel? get(String route) => _cache[route];

     static void put(String route, PageModel page) {
       _cache[route] = page;
     }
   }
   ```

2. **Lazy loading :**
   ```dart
   // Charger les pages à la demande
   Future<PageModel> loadPage(String route) async {
     if (PageCache.get(route) != null) {
       return PageCache.get(route)!;
     }

     final page = await _loadPageFromAssets(route);
     PageCache.put(route, page);
     return page;
   }
   ```

3. **Préchargement :**
   ```dart
   // Précharger les pages principales
   Future<void> preloadPages() async {
     final mainPages = ['home', 'profile', 'settings'];
     await Future.wait(mainPages.map(loadPage));
   }
   ```

## Problèmes d'affichage

### Composants non affichés

**Symptômes :**
- Certains éléments manquent dans l'interface
- Layout incorrect

**Causes possibles :**
1. Builder manquant pour un composant
2. Erreur dans la définition JSON
3. Problème de rendu

**Solutions :**

1. **Vérifier l'enregistrement des builders :**
   ```dart
   // Dans ComponentRegistry
   void registerDefaults() {
     register('text', TextBuilder());
     register('button', ButtonBuilder());
     register('column', ColumnBuilder());
     // etc.
   }
   ```

2. **Debugger le rendu :**
   ```dart
   // Ajouter des logs
   @override
   Widget build(BuildContext context, ComponentSpec spec) {
     debugPrint('Building component: ${spec.type}');
     return _buildWidget(spec);
   }
   ```

3. **Valider la structure JSON :**
   ```dart
   bool validateComponentJson(Map<String, dynamic> json) {
     return json.containsKey('component') &&
            json.containsKey('props');
   }
   ```

### BottomNavigationBar non visible

**Symptômes :**
- Barre de navigation absente
- Navigation impossible

**Causes possibles :**
1. Erreur dans `navigation.json`
2. Problème de chargement
3. Erreur de rendu

**Solutions :**

1. **Vérifier `navigation.json` :**
   ```json
   {
     "items": [
       {
         "label": "Home",
         "icon": "home",
         "page": "home"
       }
     ]
   }
   ```

2. **Debugger le chargement :**
   ```dart
   // Dans ScreenBuilderPage
   @override
   void initState() {
     super.initState();
     _loadNavigationAndHomePage().catchError((error) {
       debugPrint('Navigation loading error: $error');
     });
   }
   ```

3. **Vérifier le rendu :**
   ```dart
   // Dans build()
   if (_navigation == null) {
     return Center(child: CircularProgressIndicator());
   }
   ```

## Problèmes d'actions

### Actions non exécutées

**Symptômes :**
- Boutons ne répondent pas
- Actions ignorées

**Causes possibles :**
1. ActionHandle non enregistré
2. Erreur dans la définition de l'action
3. Problème de contexte

**Solutions :**

1. **Vérifier l'enregistrement :**
   ```dart
   // Dans ActionHandle
   void registerDefaults() {
     _executors['navigate'] = NavigateExecutor();
     _executors['api_get'] = ApiGetExecutor();
   }
   ```

2. **Valider la syntaxe de l'action :**
   ```json
   {
     "component": "button",
     "props": {
       "text": "Click me",
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

3. **Debugger l'exécution :**
   ```dart
   @override
   Future<void> execute(Map<String, dynamic> context) async {
     debugPrint('Executing action: ${context['action']}');
     // ... logique d'exécution
   }
   ```

### Erreurs d'API

**Symptômes :**
- Échecs d'appels API
- Données non chargées

**Solutions :**

1. **Vérifier la configuration réseau :**
   ```dart
   class ApiService {
     final String baseUrl;
     final Map<String, String> defaultHeaders;

     ApiService({
       required this.baseUrl,
       this.defaultHeaders = const {},
     });
   }
   ```

2. **Gestion d'erreurs :**
   ```dart
   Future<dynamic> apiCall(String endpoint) async {
     try {
       final response = await http.get(Uri.parse('$baseUrl$endpoint'));
       if (response.statusCode == 200) {
         return jsonDecode(response.body);
       } else {
         throw ApiException('HTTP ${response.statusCode}');
       }
     } catch (e) {
       debugPrint('API Error: $e');
       throw e;
     }
   }
   ```

## Problèmes de performance

### Mémoire pleine

**Symptômes :**
- Application lente
- Crash mémoire

**Solutions :**

1. **Limiter le cache :**
   ```dart
   class PageCache {
     static const int _maxCacheSize = 10;
     static final Map<String, PageModel> _cache = {};

     static void put(String route, PageModel page) {
       if (_cache.length >= _maxCacheSize) {
         // Supprimer l'entrée la plus ancienne
         final oldestKey = _cache.keys.first;
         _cache.remove(oldestKey);
       }
       _cache[route] = page;
     }
   }
   ```

2. **Nettoyage périodique :**
   ```dart
   Timer.periodic(Duration(minutes: 5), (timer) {
     PageCache.cleanup();
   });
   ```

### Rendu lent

**Solutions :**

1. **Optimiser les builders :**
   ```dart
   class OptimizedTextBuilder extends ComponentBuilder {
     @override
     Widget buildSpec(Map<String, dynamic> json) {
       final text = json['props']['text'];
       final style = _parseStyle(json['props']['style']);

       return Text(
         text,
         style: style,
         key: ValueKey(text), // Clé stable
       );
     }
   }
   ```

2. **Utiliser const quand possible :**
   ```dart
   const Text(
     'Static text',
     style: TextStyle(fontSize: 16),
   );
   ```

## Problèmes d'état

### État perdu lors de la navigation

**Solutions :**

1. **Persister l'état :**
   ```dart
   class StatePersistence {
     static Future<void> saveState(AppState state) async {
       final prefs = await SharedPreferences.getInstance();
       final stateJson = jsonEncode(state.toJson());
       await prefs.setString('app_state', stateJson);
     }

     static Future<AppState?> loadState() async {
       final prefs = await SharedPreferences.getInstance();
       final stateJson = prefs.getString('app_state');
       if (stateJson != null) {
         return AppState.fromJson(jsonDecode(stateJson));
       }
       return null;
     }
   }
   ```

2. **État global :**
   ```dart
   final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
     return AppStateNotifier();
   });
   ```

### Incohérences d'état

**Solutions :**

1. **Validation d'état :**
   ```dart
   bool isValidState(AppState state) {
     // Vérifications de cohérence
     return state.navigation.currentRoute.isNotEmpty &&
            state.pageStates.length >= 0;
   }
   ```

2. **Récupération d'erreur :**
   ```dart
   AppState recoverState(AppState invalidState) {
     return AppState(
       navigation: NavigationState(currentRoute: 'home'),
       pageStates: {},
       user: UserState.empty(),
     );
   }
   ```

## Problèmes spécifiques à la plateforme

### Problèmes Windows

**Symptôme :** Erreur RawKeyDownEvent

**Solution :**
- Mettre à jour Flutter
- Éviter les touches spéciales pendant le développement

### Problèmes Web

**Symptôme :** Navigation ne fonctionne pas

**Solution :**
- Utiliser GoRouter pour le web
- Configurer les routes correctement

### Problèmes iOS

**Symptôme :** Animations saccadées

**Solution :**
- Utiliser CupertinoNavigationStrategy
- Optimiser les transitions

## Outils de diagnostic

### Script de diagnostic

```dart
class NavigationDiagnostic {
  static Future<Map<String, dynamic>> runDiagnostics() async {
    return {
      'navigation_file_exists': await _checkNavigationFile(),
      'pages_exist': await _checkPagesExist(),
      'builders_registered': _checkBuildersRegistered(),
      'cache_size': PageCache.size(),
      'memory_usage': await _getMemoryUsage(),
    };
  }

  static Future<bool> _checkNavigationFile() async {
    try {
      await rootBundle.loadString('assets/pages/navigation.json');
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

### Logs détaillés

```dart
void enableVerboseLogging() {
  debugPrint = (message, {wrapWidth}) {
    final timestamp = DateTime.now().toIso8601String();
    print('[$timestamp] $message');
  };
}
```

## Prévention

### Tests automatisés

```dart
void main() {
  group('Navigation Tests', () {
    test('should load navigation config', () async {
      final config = await loadNavigationConfig();
      expect(config, isNotNull);
      expect(config['items'], isNotEmpty);
    });

    test('should navigate to valid routes', () async {
      final handle = NavigationHandle();
      await handle.registerDefaults();

      await handle.execute({
        'action': 'navigate',
        'params': {'route': 'home'},
      });

      // Vérifications
    });
  });
}
```

### Validation continue

```dart
class ContinuousValidator {
  static void validateOnBuild() {
    // Valider la configuration à chaque build
    if (!validateNavigationConfig()) {
      throw Exception('Invalid navigation configuration');
    }
  }
}
```

### Monitoring

```dart
class NavigationMonitor {
  static void startMonitoring() {
    // Surveiller les erreurs de navigation
    FlutterError.onError = (details) {
      if (details.exception.toString().contains('navigation')) {
        reportError(details);
      }
    };
  }
}
```

Ces solutions couvrent la plupart des problèmes courants. Pour des cas spécifiques, consulter les logs détaillés et utiliser les outils de debug.