import '../core/logger.dart';
import '../core/interfaces.dart';

/// Registry for component builders
class ComponentRegistry {
  static final ComponentRegistry _instance = ComponentRegistry._internal();

  factory ComponentRegistry() => _instance;

  ComponentRegistry._internal();

  final Map<String, ComponentBuilder> _builders = {};

  /// Registers a component builder for a given type
  void register(String type, ComponentBuilder builder) {
    _builders[type] = builder;
  }

  /// Retrieves a component builder for a given type
  ComponentBuilder? get(String type) {
    final b = _builders[type];
    if (b == null) {
      SBLogger.warn('ComponentRegistry: no builder registered for "$type"');
    } else {
      SBLogger.info('ComponentRegistry: returning builder for "$type"');
    }
    return b;
  }
}
