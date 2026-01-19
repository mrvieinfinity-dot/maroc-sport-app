import 'package:flutter/material.dart';
import 'logger.dart';
import '../components/props/component_specs.dart';

/// Interface for building UI component specifications from props
/// Builders now return data-only ComponentSpec instead of Widgets
/// Specs are built without context since they are pure data
abstract class ComponentBuilder {
  /// Builds a component specification from the given props
  ComponentSpec buildSpec(Map<String, dynamic> props);
}

/// Helper to wrap legacy function-based builders into the new interface
class FunctionComponentBuilder implements ComponentBuilder {
  final ComponentSpec Function(Map<String, dynamic>) _fn;
  FunctionComponentBuilder(this._fn);

  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    return _fn(props);
  }
}

/// Interface for resolving tokens or values
abstract class Resolver<T> {
  /// Resolves a value from a key
  T? resolve(String? key);
}

/// Registry for component builders
// ComponentRegistry is implemented in `registry/component_registry.dart`.
// Keep core interfaces minimal and import the registry where needed.

/// Manager for resolvers
class ResolverManager {
  static final ResolverManager _instance = ResolverManager._internal();
  factory ResolverManager() => _instance;
  ResolverManager._internal();

  final Map<Type, Resolver> _resolvers = {};

  /// Registers a resolver for a type
  void register<T>(Resolver<T> resolver) {
    _resolvers[T] = resolver;
  }

  /// Gets a resolver for a type
  Resolver<T>? get<T>() {
    return _resolvers[T] as Resolver<T>?;
  }

  /// Resolves a value using the appropriate resolver
  T? resolve<T>(String? key) {
    final resolver = get<T>();
    if (resolver == null) {
      SBLogger.error(
          'No resolver registered for type <$T> when resolving key: $key');
      throw FlutterError('No resolver registered for type <$T>');
    }
    try {
      final result = resolver.resolve(key);
      SBLogger.info('Resolver<$T> resolved key="$key" -> $result');
      return result;
    } catch (e, st) {
      SBLogger.error('Resolver<$T> threw for key: $key', e, st);
      rethrow;
    }
  }
}

/// Interface for composers that assemble complex structures
abstract class Composer<T> {
  /// Composes a T from the given configuration
  T compose(BuildContext context, Map<String, dynamic> config);
}
