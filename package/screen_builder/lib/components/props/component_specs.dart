import 'package:flutter/material.dart';

/// Base class for all component specifications
/// ComponentSpecs are data-only descriptions of UI components
/// They contain all the information needed to render a component
/// but no rendering logic
abstract class ComponentSpec {
  final String type;
  final Map<String, dynamic> props;
  final List<ComponentSpec>? children;

  const ComponentSpec({
    required this.type,
    required this.props,
    this.children,
  });

  @override
  String toString() =>
      '$type(props: $props, children: ${children?.length ?? 0})';
}

/// Generic component specification
/// All components use this single spec class with type-based properties
class ComponentSpecData extends ComponentSpec {
  const ComponentSpecData({
    required String type,
    Map<String, dynamic> props = const {},
    List<ComponentSpec>? children,
  }) : super(type: type, props: props, children: children);
}
