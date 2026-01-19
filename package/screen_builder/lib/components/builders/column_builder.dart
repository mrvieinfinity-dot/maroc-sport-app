import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../props/component_specs.dart';

/// Builder for Column layout components
/// Returns a ComponentSpecData instead of directly building a Widget
class ColumnBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    final mainAxisAlignment =
        _parseMainAxisAlignment(props['mainAxisAlignment']);
    final crossAxisAlignment =
        _parseCrossAxisAlignment(props['crossAxisAlignment']);
    final spacing = (props['spacing'] ?? 0.0).toDouble();
    final children = (props['children'] as List<dynamic>?)
        ?.map((child) {
          if (child is ComponentSpec) return child;
          return null;
        })
        .whereType<ComponentSpec>()
        .toList();

    return ComponentSpecData(
      type: 'column',
      props: {
        ...props,
        'mainAxisAlignment': mainAxisAlignment,
        'crossAxisAlignment': crossAxisAlignment,
        'spacing': spacing,
      },
      children: children,
    );
  }

  MainAxisAlignment _parseMainAxisAlignment(dynamic value) {
    if (value == null) return MainAxisAlignment.start;
    switch (value.toString().toLowerCase()) {
      case 'start':
        return MainAxisAlignment.start;
      case 'end':
        return MainAxisAlignment.end;
      case 'center':
        return MainAxisAlignment.center;
      case 'spacebetween':
        return MainAxisAlignment.spaceBetween;
      case 'spacearound':
        return MainAxisAlignment.spaceAround;
      case 'spaceevenly':
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  CrossAxisAlignment _parseCrossAxisAlignment(dynamic value) {
    if (value == null) return CrossAxisAlignment.center;
    switch (value.toString().toLowerCase()) {
      case 'start':
        return CrossAxisAlignment.start;
      case 'end':
        return CrossAxisAlignment.end;
      case 'center':
        return CrossAxisAlignment.center;
      case 'stretch':
        return CrossAxisAlignment.stretch;
      case 'baseline':
        return CrossAxisAlignment.baseline;
      default:
        return CrossAxisAlignment.center;
    }
  }
}
