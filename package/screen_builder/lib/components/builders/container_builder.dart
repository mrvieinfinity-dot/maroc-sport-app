import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../props/component_specs.dart';

/// Builder for Container components
/// Returns a ComponentSpecData instead of directly building a Widget
class ContainerBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    final colorKey = props['color'] as String?;
    final padding = _parseEdgeInsets(props['padding']);
    final margin = _parseEdgeInsets(props['margin']);
    final children = (props['children'] as List<dynamic>?)
        ?.map((child) {
          if (child is ComponentSpec) return child;
          return null;
        })
        .whereType<ComponentSpec>()
        .toList();

    return ComponentSpecData(
      type: 'container',
      props: {
        'colorKey': colorKey,
        'padding': padding,
        'margin': margin,
        ...props,
      },
      children: children,
    );
  }

  EdgeInsets? _parseEdgeInsets(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) {
      return EdgeInsets.fromLTRB(
        (value['left'] ?? 0.0).toDouble(),
        (value['top'] ?? 0.0).toDouble(),
        (value['right'] ?? 0.0).toDouble(),
        (value['bottom'] ?? 0.0).toDouble(),
      );
    }
    if (value is double) {
      return EdgeInsets.all(value);
    }
    return null;
  }
}
