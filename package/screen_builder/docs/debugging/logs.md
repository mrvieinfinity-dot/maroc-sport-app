# Logs et traces de navigation

## Vue d'ensemble

Le système de navigation génère des logs détaillés pour faciliter le debugging et la surveillance des performances.

## Types de logs

### Logs de navigation

Tracent les changements de page et les actions utilisateur.

```dart
class NavigationLogger {
  static void logNavigation(String from, String to, Map<String, dynamic>? params) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] NAVIGATION: $from → $to');

    if (params != null && params.isNotEmpty) {
      debugPrint('  Parameters: $params');
    }
  }

  static void logBackNavigation(String from) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] NAVIGATION: ← $from');
  }
}
```

### Logs d'actions

Tracent l'exécution des actions.

```dart
class ActionLogger {
  static void logActionStart(String actionType, Map<String, dynamic> context) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] ACTION START: $actionType');
    debugPrint('  Context: $context');
  }

  static void logActionSuccess(String actionType, Duration duration) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] ACTION SUCCESS: $actionType (${duration.inMilliseconds}ms)');
  }

  static void logActionError(String actionType, dynamic error, Duration duration) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] ACTION ERROR: $actionType (${duration.inMilliseconds}ms)');
    debugPrint('  Error: $error');
  }
}
```

### Logs de performance

Mesurent les temps d'exécution.

```dart
class PerformanceLogger {
  static void logPageLoad(String route, Duration duration) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] PERFORMANCE: Page load $route - ${duration.inMilliseconds}ms');
  }

  static void logComponentRender(String componentType, Duration duration) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] PERFORMANCE: Render $componentType - ${duration.inMilliseconds}ms');
  }
}
```

### Logs d'erreurs

Tracent les exceptions et erreurs.

```dart
class ErrorLogger {
  static void logNavigationError(String route, dynamic error, StackTrace? stackTrace) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] NAVIGATION ERROR: $route');
    debugPrint('  Error: $error');

    if (stackTrace != null) {
      debugPrint('  Stack trace: $stackTrace');
    }
  }

  static void logComponentError(String componentType, dynamic error) {
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] COMPONENT ERROR: $componentType - $error');
  }
}
```

## Configuration des logs

### Niveaux de log

```dart
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  none,
}
```

### Configuration globale

```dart
class LogConfig {
  static LogLevel level = LogLevel.info;
  static bool includeTimestamp = true;
  static bool includeStackTrace = false;
  static String? logFilePath;

  static void configure({
    LogLevel? level,
    bool? includeTimestamp,
    bool? includeStackTrace,
    String? logFilePath,
  }) {
    if (level != null) LogConfig.level = level;
    if (includeTimestamp != null) LogConfig.includeTimestamp = includeTimestamp;
    if (includeStackTrace != null) LogConfig.includeStackTrace = includeStackTrace;
    if (logFilePath != null) LogConfig.logFilePath = logFilePath;
  }
}
```

### Filtrage des logs

```dart
class LogFilter {
  static bool shouldLog(LogLevel messageLevel) {
    return messageLevel.index >= LogConfig.level.index;
  }

  static bool shouldLogCategory(String category) {
    // Filtres par catégorie
    const enabledCategories = ['navigation', 'action'];
    return enabledCategories.contains(category.toLowerCase());
  }
}
```

## Format des logs

### Format standard

```
[2024-01-19T10:30:45.123Z] NAVIGATION: home → profile
  Parameters: {userId: 123}
```

### Format JSON

```dart
class JsonFormatter {
  static String format(LogLevel level, String category, String message, Map<String, dynamic>? data) {
    final logEntry = {
      'timestamp': DateTime.now().toIso8601String(),
      'level': level.name,
      'category': category,
      'message': message,
      'data': data,
    };

    return jsonEncode(logEntry);
  }
}
```

### Format compact

```
10:30:45 NAV: home→profile (userId=123)
```

## Stockage des logs

### Mémoire

```dart
class InMemoryLogStorage {
  static const int _maxLogs = 1000;
  static final List<LogEntry> _logs = [];

  static void add(LogEntry entry) {
    _logs.add(entry);
    if (_logs.length > _maxLogs) {
      _logs.removeAt(0);
    }
  }

  static List<LogEntry> getRecentLogs(int count) {
    return _logs.reversed.take(count).toList();
  }

  static void clear() {
    _logs.clear();
  }
}
```

### Fichier

```dart
class FileLogStorage {
  static const String _logFileName = 'navigation_logs.txt';

  static Future<void> writeLog(String logLine) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_logFileName');

    await file.writeAsString('$logLine\n', mode: FileMode.append);
  }

  static Future<List<String>> readLogs() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_logFileName');

    if (await file.exists()) {
      return await file.readAsLines();
    }

    return [];
  }
}
```

### Base de données

```dart
class DatabaseLogStorage {
  static Future<void> insertLog(LogEntry entry) async {
    final db = await openDatabase('logs.db');
    await db.insert('logs', entry.toMap());
  }

  static Future<List<LogEntry>> getLogs({
    int? limit,
    LogLevel? level,
    String? category,
  }) async {
    final db = await openDatabase('logs.db');
    final where = <String>[];
    final whereArgs = <dynamic>[];

    if (level != null) {
      where.add('level = ?');
      whereArgs.add(level.name);
    }

    if (category != null) {
      where.add('category = ?');
      whereArgs.add(category);
    }

    final result = await db.query(
      'logs',
      where: where.isNotEmpty ? where.join(' AND ') : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      limit: limit,
      orderBy: 'timestamp DESC',
    );

    return result.map((map) => LogEntry.fromMap(map)).toList();
  }
}
```

## Analyse des logs

### Outil d'analyse

```dart
class LogAnalyzer {
  static Map<String, int> analyzeLogFrequency(List<LogEntry> logs) {
    final frequency = <String, int>{};

    for (final log in logs) {
      final key = '${log.category}:${log.level}';
      frequency[key] = (frequency[key] ?? 0) + 1;
    }

    return frequency;
  }

  static Map<String, Duration> analyzePerformance(List<LogEntry> logs) {
    final performanceLogs = logs.where((log) => log.category == 'performance');
    final timings = <String, List<Duration>>{};

    for (final log in performanceLogs) {
      final operation = log.data?['operation'] as String?;
      final duration = log.data?['duration'] as Duration?;

      if (operation != null && duration != null) {
        timings.putIfAbsent(operation, () => []).add(duration);
      }
    }

    return timings.map((key, value) {
      final avg = value.reduce((a, b) => a + b) ~/ value.length;
      return MapEntry(key, avg);
    });
  }

  static List<LogEntry> findErrors(List<LogEntry> logs) {
    return logs.where((log) => log.level == LogLevel.error).toList();
  }
}
```

### Rapports

```dart
class LogReporter {
  static String generateReport(List<LogEntry> logs) {
    final buffer = StringBuffer();

    buffer.writeln('=== Navigation Log Report ===');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Total logs: ${logs.length}');
    buffer.writeln();

    // Fréquences
    final frequency = LogAnalyzer.analyzeLogFrequency(logs);
    buffer.writeln('Log frequencies:');
    frequency.forEach((key, count) {
      buffer.writeln('  $key: $count');
    });
    buffer.writeln();

    // Erreurs
    final errors = LogAnalyzer.findErrors(logs);
    buffer.writeln('Errors (${errors.length}):');
    for (final error in errors.take(10)) {
      buffer.writeln('  ${error.timestamp}: ${error.message}');
    }
    buffer.writeln();

    // Performance
    final performance = LogAnalyzer.analyzePerformance(logs);
    buffer.writeln('Average performance:');
    performance.forEach((operation, avg) {
      buffer.writeln('  $operation: ${avg.inMilliseconds}ms');
    });

    return buffer.toString();
  }
}
```

## Intégration avec des services externes

### Sentry

```dart
class SentryLogIntegration {
  static void setup() {
    // Capturer les erreurs automatiquement
    FlutterError.onError = (details) {
      Sentry.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    };
  }

  static void logToSentry(LogEntry entry) {
    if (entry.level == LogLevel.error) {
      Sentry.captureMessage(
        entry.message,
        level: SentryLevel.error,
        extra: entry.data,
      );
    }
  }
}
```

### Firebase Crashlytics

```dart
class CrashlyticsLogIntegration {
  static void logToCrashlytics(LogEntry entry) {
    if (entry.level == LogLevel.error) {
      FirebaseCrashlytics.instance.recordError(
        entry.message,
        entry.stackTrace,
        reason: entry.category,
      );
    }
  }
}
```

### ELK Stack

```dart
class ElkLogIntegration {
  static Future<void> sendToElk(LogEntry entry) async {
    final logData = {
      'timestamp': entry.timestamp.toIso8601String(),
      'level': entry.level.name,
      'category': entry.category,
      'message': entry.message,
      'data': entry.data,
    };

    await http.post(
      Uri.parse('http://elk-server:9200/logs/_doc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(logData),
    );
  }
}
```

## Bonnes pratiques

### Niveaux appropriés

- **Verbose** : Détails internes, debugging
- **Debug** : Informations de développement
- **Info** : Événements importants
- **Warning** : Problèmes non critiques
- **Error** : Erreurs nécessitant attention

### Contenu des logs

- **Concis** : Messages clairs et directs
- **Contextuel** : Inclure les données pertinentes
- **Structuré** : Format cohérent

### Performance

- **Async** : Écriture non-bloquante
- **Batch** : Grouper les logs
- **Rotation** : Gestion de la taille des fichiers

### Sécurité

- **Filtrage** : Ne pas logger les données sensibles
- **Chiffrement** : Logs sensibles chiffrés
- **Accès** : Contrôle des permissions

## Exemples d'utilisation

### Debug d'une navigation

```dart
// Activer les logs détaillés
LogConfig.configure(level: LogLevel.debug);

// Effectuer une navigation
await navigationHandle.execute({
  'action': 'navigate',
  'params': {'route': 'profile'},
});

// Examiner les logs
final logs = InMemoryLogStorage.getRecentLogs(10);
logs.forEach((log) => debugPrint(log.toString()));
```

### Analyse de performance

```dart
// Collecter des métriques
final logs = await DatabaseLogStorage.getLogs(category: 'performance');
final report = LogReporter.generateReport(logs);
debugPrint(report);
```

### Monitoring en production

```dart
// Configuration pour la production
LogConfig.configure(
  level: LogLevel.warning,
  logFilePath: 'logs/navigation.log',
);

// Intégration avec Sentry
SentryLogIntegration.setup();

// Logger les erreurs automatiquement
ErrorLogger.onError = (error, stackTrace) {
  SentryLogIntegration.logToSentry(LogEntry(
    level: LogLevel.error,
    category: 'navigation',
    message: error.toString(),
    stackTrace: stackTrace,
  ));
};
```

Ces logs permettent de comprendre le comportement du système de navigation et de diagnostiquer les problèmes efficacement.