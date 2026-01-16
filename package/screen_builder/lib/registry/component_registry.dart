import 'package:flutter/material.dart';

/// Registry for component builders
class ComponentRegistry {
  static final ComponentRegistry _instance = ComponentRegistry._internal();

  factory ComponentRegistry() => _instance;

  ComponentRegistry._internal();

  final Map<String, Widget Function(BuildContext, Map<String, dynamic>)>
      _builders = {};

  /// Registers a component builder for a given type
  void register(String type,
      Widget Function(BuildContext, Map<String, dynamic>) builder) {
    _builders[type] = builder;
  }

  /// Retrieves a component builder for a given type
  Widget Function(BuildContext, Map<String, dynamic>)? get(String type) {
    return _builders[type];
  }
}
