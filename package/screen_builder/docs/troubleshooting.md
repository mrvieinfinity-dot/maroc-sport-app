# Dépannage de la navigation

## Vue d'ensemble

Ce guide couvre les problèmes courants de navigation et leurs solutions.

## Problèmes courants

### "Page not found but page exists"

**Symptômes** :
- Erreur "Page not found" malgré l'existence du fichier JSON
- Navigation qui échoue silencieusement
- Logs indiquant une route non trouvée

**Causes possibles** :
1. **Chemin incorrect** : Le fichier JSON n'est pas au bon endroit
2. **Nom de route incorrect** : Incohérence entre navigation.json et nom du fichier
3. **Cache obsolète** : Le cache contient des données périmées
4. **Permissions** : Accès refusé au fichier

**Solutions** :

```dart
// 1. Vérifier le chemin du fichier
Future<bool> validatePagePath(String route) async {
  final filePath = 'assets/pages/$route.json';
  final file = File(filePath);
  final exists = await file.exists();

  if (!exists) {
    debugPrint('Page file not found: $filePath');
    return false;
  }

  return true;
}

// 2. Valider la configuration de navigation
void validateNavigationConfig() {
  final navConfig = NavigationConfig.current;

  for (final item in navConfig.items) {
    final route = item.route;
    final exists = validatePagePath(route);

    if (!exists) {
      debugPrint('Navigation item references non-existent page: $route');
    }
  }
}

// 3. Vider le cache
void clearNavigationCache() {
  NavigationCache.instance.clear();
  debugPrint('Navigation cache cleared');
}

// 4. Recharger la configuration
Future<void> reloadNavigation() async {
  await NavigationConfig.reload();
  await NavigationCache.instance.clear();
  debugPrint('Navigation reloaded');
}
```

### Navigation qui ne répond pas

**Symptômes** :
- Les boutons de navigation ne fonctionnent pas
- Les gestes de retour ne marchent pas
- L'application semble figée

**Causes possibles** :
1. **Blocage de l'UI** : Opération synchrone longue
2. **Erreur dans le builder** : Exception non gérée
3. **État corrompu** : État de navigation incohérent

**Solutions** :

```dart
// 1. Vérifier les opérations bloquantes
void checkBlockingOperations() {
  // Utiliser des timers pour détecter les blocages
  Timer.periodic(Duration(seconds: 1), (timer) {
    debugPrint('UI is responsive at ${DateTime.now()}');
  });
}

// 2. Wrapper les builders avec gestion d'erreur
Widget safeBuilder(BuildContext context, Map<String, dynamic> spec) {
  try {
    return SpecsRenderer.buildComponent(spec);
  } catch (e, stackTrace) {
    ErrorLogger.logComponentError('builder', e);

    return ErrorWidget.builder(
      FlutterErrorDetails(
        exception: e,
        stack: stackTrace,
        library: 'screen_builder',
      ),
    );
  }
}

// 3. Reset de l'état de navigation
void resetNavigationState() {
  NavigationHandle.instance.reset();
  NavigationHistory.clear();
  debugPrint('Navigation state reset');
}
```

### Performances lentes

**Symptômes** :
- Chargement lent des pages
- Lags lors de la navigation
- Consommation élevée de CPU/mémoire

**Causes possibles** :
1. **Parsing JSON inefficace** : Re-parsing à chaque navigation
2. **Builders non optimisés** : Reconstruction inutile
3. **Cache manquant** : Pas de mise en cache des composants

**Solutions** :

```dart
// 1. Optimiser le parsing JSON
class OptimizedJsonParser {
  static final Map<String, dynamic> _cache = {};

  static Future<Map<String, dynamic>> parseCached(String path) async {
    if (_cache.containsKey(path)) {
      return _cache[path]!;
    }

    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString);
    _cache[path] = data;

    return data;
  }
}

// 2. Utiliser des builders const quand possible
class ConstBuilder extends StatelessWidget {
  const ConstBuilder({Key? key, required this.spec}) : super(key: key);

  final Map<String, dynamic> spec;

  @override
  Widget build(BuildContext context) {
    // Retourner des widgets const quand les données sont statiques
    if (spec['type'] == 'text' && spec['data'] is String) {
      return Text(spec['data']);
    }

    return SpecsRenderer.buildComponent(spec);
  }
}

// 3. Implémenter la mise en cache des composants
class ComponentCache {
  static final Map<String, Widget> _cache = {};

  static Widget getCached(String key, Widget Function() builder) {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final widget = builder();
    _cache[key] = widget;
    return widget;
  }

  static void clear() {
    _cache.clear();
  }
}
```

### Erreurs d'actions

**Symptômes** :
- Actions qui échouent silencieusement
- Exceptions non gérées
- Comportement inattendu après une action

**Causes possibles** :
1. **Paramètres manquants** : Action appelée sans paramètres requis
2. **Type incorrect** : Paramètres de mauvais type
3. **Dépendances manquantes** : Services non initialisés

**Solutions** :

```dart
// 1. Validation des paramètres d'action
bool validateActionParams(String actionType, Map<String, dynamic> params) {
  switch (actionType) {
    case 'navigate':
      return params.containsKey('route') && params['route'] is String;
    case 'api_get':
      return params.containsKey('url') && params['url'] is String;
    case 'set_state':
      return params.containsKey('key') && params.containsKey('value');
    default:
      return false;
  }
}

// 2. Gestion d'erreur robuste
Future<void> executeActionSafely(Map<String, dynamic> actionSpec) async {
  try {
    final actionType = actionSpec['action'] as String;
    final params = actionSpec['params'] as Map<String, dynamic>? ?? {};

    if (!validateActionParams(actionType, params)) {
      throw ArgumentError('Invalid parameters for action: $actionType');
    }

    await NavigationHandle.instance.execute(actionSpec);
  } catch (e, stackTrace) {
    ErrorLogger.logActionError(actionType, e, stackTrace);

    // Fallback: afficher un message d'erreur
    showErrorDialog('Action failed: $e');
  }
}

// 3. Vérifier les dépendances
void validateDependencies() {
  final requiredServices = [
    NavigationHandle.instance,
    ComponentRegistry.instance,
    SpecsRenderer.instance,
  ];

  for (final service in requiredServices) {
    if (service == null) {
      throw StateError('Required service not initialized: ${service.runtimeType}');
    }
  }
}
```

### Problèmes de layout

**Symptômes** :
- Composants mal positionnés
- Overflow ou underflow
- Responsive qui ne fonctionne pas

**Causes possibles** :
1. **Spécifications incorrectes** : JSON mal formé
2. **Builders défaillants** : Logique d'affichage erronée
3. **Constraints manquantes** : Pas de gestion des contraintes

**Solutions** :

```dart
// 1. Valider les spécifications JSON
bool validateComponentSpec(Map<String, dynamic> spec) {
  final requiredFields = ['type'];

  for (final field in requiredFields) {
    if (!spec.containsKey(field)) {
      debugPrint('Missing required field: $field');
      return false;
    }
  }

  // Validation spécifique par type
  switch (spec['type']) {
    case 'column':
      return spec.containsKey('children');
    case 'text':
      return spec.containsKey('data');
    default:
      return true;
  }
}

// 2. Wrapper avec gestion des erreurs de layout
Widget layoutSafeBuilder(Map<String, dynamic> spec) {
  return LayoutBuilder(
    builder: (context, constraints) {
      try {
        return SpecsRenderer.buildComponent(spec);
      } catch (e) {
        return Container(
          color: Colors.red.withOpacity(0.1),
          child: Text('Layout error: $e'),
        );
      }
    },
  );
}

// 3. Debugging du layout
class LayoutDebugger {
  static Widget debugWrapper(Widget child, String componentType) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: Colors.yellow.withOpacity(0.8),
            padding: EdgeInsets.all(2),
            child: Text(
              componentType,
              style: TextStyle(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}
```

## Outils de diagnostic

### Navigation Debugger

```dart
class NavigationDebugger {
  static void startDebugSession() {
    // Activer les logs détaillés
    LogConfig.configure(level: LogLevel.verbose);

    // Surveiller les changements d'état
    NavigationHandle.instance.addListener(() {
      debugPrint('Navigation state changed: ${NavigationHandle.instance.currentRoute}');
    });

    // Vérifier la pile de navigation
    Timer.periodic(Duration(seconds: 5), (timer) {
      debugPrint('Navigation stack: ${NavigationHistory.stack}');
    });
  }

  static void stopDebugSession() {
    LogConfig.configure(level: LogLevel.info);
  }
}
```

### Profiler de performance

```dart
class NavigationProfiler {
  static final Map<String, List<Duration>> _timings = {};

  static void startProfiling(String operation) {
    _timings[operation] = [];
  }

  static void recordTiming(String operation, Duration duration) {
    _timings[operation]?.add(duration);
  }

  static void printReport() {
    debugPrint('=== Navigation Performance Report ===');
    _timings.forEach((operation, timings) {
      final avg = timings.reduce((a, b) => a + b) ~/ timings.length;
      final max = timings.reduce((a, b) => a > b ? a : b);
      final min = timings.reduce((a, b) => a < b ? a : b);

      debugPrint('$operation: avg=${avg.inMilliseconds}ms, min=${min.inMilliseconds}ms, max=${max.inMilliseconds}ms');
    });
  }
}
```

### Validateur de configuration

```dart
class ConfigurationValidator {
  static Future<List<String>> validateConfiguration() async {
    final errors = <String>[];

    // Vérifier navigation.json
    try {
      final navData = await OptimizedJsonParser.parseCached('assets/pages/navigation.json');
      final navConfig = NavigationConfig.fromJson(navData);

      for (final item in navConfig.items) {
        final exists = await validatePagePath(item.route);
        if (!exists) {
          errors.add('Navigation item "${item.label}" references non-existent page: ${item.route}');
        }
      }
    } catch (e) {
      errors.add('Invalid navigation.json: $e');
    }

    // Vérifier les pages référencées
    final pageFiles = ['home.json', 'profile.json', 'settings.json'];
    for (final pageFile in pageFiles) {
      try {
        final pageData = await OptimizedJsonParser.parseCached('assets/pages/$pageFile');
        final validationErrors = validatePageStructure(pageData);
        errors.addAll(validationErrors.map((e) => '$pageFile: $e'));
      } catch (e) {
        errors.add('Invalid page file $pageFile: $e');
      }
    }

    return errors;
  }

  static List<String> validatePageStructure(Map<String, dynamic> pageData) {
    final errors = <String>[];

    if (!pageData.containsKey('screen')) {
      errors.add('Missing "screen" key');
    }

    // Validation récursive des composants
    void validateComponent(Map<String, dynamic> component, String path) {
      if (!validateComponentSpec(component)) {
        errors.add('Invalid component at $path');
      }

      if (component.containsKey('children')) {
        final children = component['children'] as List;
        for (int i = 0; i < children.length; i++) {
          validateComponent(children[i], '$path.children[$i]');
        }
      }
    }

    if (pageData.containsKey('screen')) {
      validateComponent(pageData['screen'], 'screen');
    }

    return errors;
  }
}
```

## Procédures de récupération

### Récupération d'urgence

```dart
class EmergencyRecovery {
  static Future<void> performEmergencyRecovery() async {
    debugPrint('Starting emergency recovery...');

    try {
      // 1. Vider tous les caches
      NavigationCache.instance.clear();
      ComponentCache.clear();

      // 2. Reset l'état de navigation
      NavigationHandle.instance.reset();
      NavigationHistory.clear();

      // 3. Recharger la configuration
      await NavigationConfig.reload();

      // 4. Valider la configuration
      final errors = await ConfigurationValidator.validateConfiguration();
      if (errors.isNotEmpty) {
        debugPrint('Configuration errors found:');
        errors.forEach(debugPrint);
      }

      debugPrint('Emergency recovery completed');
    } catch (e) {
      debugPrint('Emergency recovery failed: $e');
      // Fallback: redémarrer l'application
      Phoenix.rebirth(context);
    }
  }
}
```

### Mode de sécurité

```dart
class SafeMode {
  static bool _enabled = false;

  static bool get isEnabled => _enabled;

  static void enable() {
    _enabled = true;
    LogConfig.configure(level: LogLevel.verbose);

    // Désactiver les fonctionnalités risquées
    NavigationHandle.instance.disableAnimations();
    SpecsRenderer.disableComplexBuilders();
  }

  static void disable() {
    _enabled = false;
    LogConfig.configure(level: LogLevel.info);

    // Réactiver les fonctionnalités
    NavigationHandle.instance.enableAnimations();
    SpecsRenderer.enableComplexBuilders();
  }

  static Widget safePageBuilder(String route) {
    if (_enabled) {
      return SafeModePage(route: route);
    }

    return NormalPageBuilder(route: route);
  }
}
```

## Prévention des problèmes

### Tests automatisés

```dart
void main() {
  group('Navigation Tests', () {
    test('All navigation routes exist', () async {
      final errors = await ConfigurationValidator.validateConfiguration();
      expect(errors, isEmpty);
    });

    test('Navigation actions work', () async {
      final handle = NavigationHandle.instance;

      await handle.execute({'action': 'navigate', 'params': {'route': 'home'}});
      expect(handle.currentRoute, equals('home'));
    });

    test('Component builders handle errors', () {
      expect(() => SpecsRenderer.buildComponent({'invalid': 'spec'}),
             throwsA(isA<Exception>()));
    });
  });
}
```

### Monitoring continu

```dart
class NavigationMonitor {
  static void startMonitoring() {
    // Surveiller les erreurs
    FlutterError.onError = (details) {
      ErrorLogger.logFlutterError(details);
      SentryLogIntegration.logToSentry(details);
    };

    // Métriques de performance
    NavigationProfiler.startProfiling('page_load');
    NavigationProfiler.startProfiling('action_execution');

    // Alertes
    Timer.periodic(Duration(minutes: 5), (timer) {
      checkSystemHealth();
    });
  }

  static void checkSystemHealth() {
    final memoryUsage = ProcessInfo.currentRss;
    final navigationErrors = ErrorLogger.getRecentErrors().length;

    if (memoryUsage > 100 * 1024 * 1024) { // 100MB
      debugPrint('Warning: High memory usage');
    }

    if (navigationErrors > 10) {
      debugPrint('Warning: High error rate');
    }
  }
}
```

### Mises à jour de sécurité

```dart
class SafeUpdateManager {
  static Future<void> performSafeUpdate() async {
    // 1. Sauvegarder l'état actuel
    final backup = await createBackup();

    try {
      // 2. Appliquer la mise à jour
      await applyUpdate();

      // 3. Valider après mise à jour
      final errors = await ConfigurationValidator.validateConfiguration();

      if (errors.isNotEmpty) {
        // Rollback si erreurs
        await restoreBackup(backup);
        throw UpdateException('Update validation failed');
      }
    } catch (e) {
      // Rollback automatique
      await restoreBackup(backup);
      rethrow;
    }
  }
}
```

Ces procédures et outils permettent de diagnostiquer et résoudre efficacement les problèmes de navigation.