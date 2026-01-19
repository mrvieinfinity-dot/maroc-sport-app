# Outils de debug pour la navigation

## Vue d'ensemble

Le système de navigation fournit plusieurs outils de debug pour faciliter le développement et la résolution de problèmes.

## Logging intégré

### Niveaux de log

```dart
enum LogLevel {
  debug,
  info,
  warning,
  error,
}
```

### Configuration du logging

```dart
class NavigationLogger {
  static LogLevel _level = LogLevel.info;

  static void setLevel(LogLevel level) {
    _level = level;
  }

  static void log(LogLevel level, String message, [dynamic data]) {
    if (level.index >= _level.index) {
      final timestamp = DateTime.now().toIso8601String();
      debugPrint('[$timestamp] NAVIGATION ${level.name.toUpperCase()}: $message');

      if (data != null) {
        debugPrint('  Data: $data');
      }
    }
  }
}
```

### Utilisation

```dart
// Configuration
NavigationLogger.setLevel(LogLevel.debug);

// Logs
NavigationLogger.log(LogLevel.info, 'Navigation started', {'route': 'home'});
NavigationLogger.log(LogLevel.error, 'Navigation failed', error);
```

## Navigation Debugger

### Classe principale

```dart
class NavigationDebugger {
  static bool _enabled = false;

  static void enable() {
    _enabled = true;
    debugPrint('Navigation Debugger enabled');
  }

  static void disable() {
    _enabled = false;
    debugPrint('Navigation Debugger disabled');
  }

  static void logNavigation(String from, String to, Map<String, dynamic>? params) {
    if (!_enabled) return;

    debugPrint('🔍 NAVIGATION: $from → $to');
    if (params != null && params.isNotEmpty) {
      debugPrint('   Params: $params');
    }
  }

  static void logAction(String action, Map<String, dynamic> context) {
    if (!_enabled) return;

    debugPrint('🎯 ACTION: $action');
    debugPrint('   Context: $context');
  }

  static void logError(String error, [StackTrace? stackTrace]) {
    if (!_enabled) return;

    debugPrint('❌ ERROR: $error');
    if (stackTrace != null) {
      debugPrint('   Stack: $stackTrace');
    }
  }
}
```

### Activation automatique en développement

```dart
void main() {
  if (kDebugMode) {
    NavigationDebugger.enable();
  }

  runApp(MyApp());
}
```

## Inspecteur de navigation

### NavigationInspector

Outil pour inspecter l'état de navigation en temps réel.

```dart
class NavigationInspector {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => NavigationInspectorWidget(),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
```

### Widget d'inspection

```dart
class NavigationInspectorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final navState = ref.watch(navigationStateProvider);

        return Positioned(
          top: 50,
          right: 10,
          child: Container(
            width: 300,
            padding: EdgeInsets.all(8),
            color: Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Navigation Inspector', style: TextStyle(color: Colors.white)),
                Text('Current: ${navState.currentRoute}', style: TextStyle(color: Colors.white)),
                Text('History: ${navState.routeHistory}', style: TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () => NavigationInspector.hide(),
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

## Simulateur de navigation

### NavigationSimulator

Outil pour simuler des navigations sans interaction utilisateur.

```dart
class NavigationSimulator {
  final NavigationHandle _handle;

  NavigationSimulator(this._handle);

  Future<void> simulateNavigation(String route, Map<String, dynamic>? params) async {
    debugPrint('🎭 Simulating navigation to: $route');

    try {
      await _handle.execute({
        'action': 'navigate',
        'params': {
          'route': route,
          'params': params,
        },
      });

      debugPrint('✅ Simulation successful');
    } catch (e) {
      debugPrint('❌ Simulation failed: $e');
    }
  }

  Future<void> simulateBack() async {
    debugPrint('🎭 Simulating back navigation');

    await _handle.execute({
      'action': 'goBack',
      'params': {},
    });
  }

  Future<void> simulateScenario(List<NavigationStep> steps) async {
    for (final step in steps) {
      await Future.delayed(step.delay);

      if (step.type == 'navigate') {
        await simulateNavigation(step.route!, step.params);
      } else if (step.type == 'back') {
        await simulateBack();
      }
    }
  }
}
```

### NavigationStep

```dart
class NavigationStep {
  final String type; // 'navigate' or 'back'
  final String? route;
  final Map<String, dynamic>? params;
  final Duration delay;

  NavigationStep({
    required this.type,
    this.route,
    this.params,
    this.delay = Duration.zero,
  });
}
```

## Profileur de performance

### NavigationProfiler

Outil pour mesurer les performances de navigation.

```dart
class NavigationProfiler {
  static final Map<String, List<Duration>> _timings = {};
  static bool _enabled = false;

  static void enable() {
    _enabled = true;
  }

  static void disable() {
    _enabled = false;
  }

  static Future<T> profile<T>(String operation, Future<T> Function() action) async {
    if (!_enabled) return action();

    final stopwatch = Stopwatch()..start();

    try {
      final result = await action();
      stopwatch.stop();

      _recordTiming(operation, stopwatch.elapsed);

      debugPrint('⏱️ $operation took ${stopwatch.elapsedMilliseconds}ms');

      return result;
    } catch (e) {
      stopwatch.stop();
      debugPrint('⏱️ $operation failed after ${stopwatch.elapsedMilliseconds}ms');
      rethrow;
    }
  }

  static void _recordTiming(String operation, Duration duration) {
    _timings.putIfAbsent(operation, () => []).add(duration);
  }

  static Map<String, Duration> getAverageTimings() {
    return _timings.map((key, value) {
      final avg = value.reduce((a, b) => a + b) ~/ value.length;
      return MapEntry(key, avg);
    });
  }

  static void clearTimings() {
    _timings.clear();
  }
}
```

### Utilisation

```dart
// Profiler une navigation
await NavigationProfiler.profile('navigate_to_profile', () async {
  await navigationHandle.execute({
    'action': 'navigate',
    'params': {'route': 'profile'},
  });
});
```

## Validateur de configuration

### ConfigurationValidator

Outil pour valider la configuration de navigation.

```dart
class ConfigurationValidator {
  static List<String> validateNavigationConfig(Map<String, dynamic> config) {
    final errors = <String>[];

    // Valider la structure
    if (!config.containsKey('items')) {
      errors.add('Missing "items" key in navigation config');
    }

    final items = config['items'];
    if (items is! List) {
      errors.add('"items" must be a list');
    } else {
      for (int i = 0; i < items.length; i++) {
        final itemErrors = _validateNavigationItem(items[i], i);
        errors.addAll(itemErrors);
      }
    }

    return errors;
  }

  static List<String> _validateNavigationItem(dynamic item, int index) {
    final errors = <String>[];
    final prefix = 'Item $index: ';

    if (item is! Map) {
      errors.add('${prefix}must be an object');
      return errors;
    }

    if (!item.containsKey('label')) {
      errors.add('${prefix}missing "label"');
    }

    if (!item.containsKey('icon')) {
      errors.add('${prefix}missing "icon"');
    }

    if (!item.containsKey('page')) {
      errors.add('${prefix}missing "page"');
    } else {
      final page = item['page'];
      if (page is String && !page.endsWith('.json')) {
        errors.add('${prefix}page should end with .json');
      }
    }

    return errors;
  }
}
```

## Outil de test automatique

### NavigationTester

Outil pour tester automatiquement les navigations.

```dart
class NavigationTester {
  final WidgetTester _tester;
  final NavigationHandle _handle;

  NavigationTester(this._tester, this._handle);

  Future<void> testNavigationFlow(List<String> routes) async {
    for (final route in routes) {
      debugPrint('🧪 Testing navigation to: $route');

      await _handle.execute({
        'action': 'navigate',
        'params': {'route': route},
      });

      await _tester.pumpAndSettle();

      // Vérifier que la page est affichée
      expect(find.byType(ScreenBuilderPage), findsOneWidget);

      debugPrint('✅ Navigation to $route successful');
    }
  }

  Future<void> testBackNavigation(int steps) async {
    for (int i = 0; i < steps; i++) {
      debugPrint('🧪 Testing back navigation step ${i + 1}');

      await _handle.execute({
        'action': 'goBack',
        'params': {},
      });

      await _tester.pumpAndSettle();

      debugPrint('✅ Back navigation step ${i + 1} successful');
    }
  }
}
```

## Intégration dans l'app

### Configuration globale

```dart
void configureDebugTools() {
  if (kDebugMode) {
    NavigationDebugger.enable();
    NavigationProfiler.enable();

    // Ajouter un bouton de debug
    debugToolsButton = FloatingActionButton(
      onPressed: () => NavigationInspector.show(context),
      child: Icon(Icons.bug_report),
    );
  }
}
```

### Raccourcis clavier

```dart
class DebugKeyboardShortcuts {
  static void setup(BuildContext context) {
    ServicesBinding.instance.keyboard.addHandler((event) {
      if (event is KeyDownEvent) {
        // Ctrl+Shift+D pour activer/désactiver le debugger
        if (event.logicalKey == LogicalKeyboardKey.keyD &&
            HardwareKeyboard.instance.isControlPressed &&
            HardwareKeyboard.instance.isShiftPressed) {
          NavigationDebugger.isEnabled
              ? NavigationDebugger.disable()
              : NavigationDebugger.enable();
          return true;
        }

        // Ctrl+Shift+I pour l'inspecteur
        if (event.logicalKey == LogicalKeyboardKey.keyI &&
            HardwareKeyboard.instance.isControlPressed &&
            HardwareKeyboard.instance.isShiftPressed) {
          NavigationInspector.show(context);
          return true;
        }
      }

      return false;
    });
  }
}
```

## Export de données de debug

### DebugDataExporter

```dart
class DebugDataExporter {
  static Future<String> exportDebugData() async {
    final data = {
      'navigation_state': navigationState.toJson(),
      'page_states': pageStates.map((k, v) => MapEntry(k, v.toJson())),
      'performance_timings': NavigationProfiler.getAverageTimings(),
      'logs': _getRecentLogs(),
    };

    return jsonEncode(data);
  }

  static Future<void> saveDebugData(String path) async {
    final data = await exportDebugData();
    final file = File(path);
    await file.writeAsString(data);
  }
}
```

Ces outils permettent de diagnostiquer rapidement les problèmes de navigation et d'optimiser les performances.