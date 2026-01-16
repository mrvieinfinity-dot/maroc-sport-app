import 'package:flutter/material.dart';
import '../../registry/component_registry.dart';

/// Builds a Container component from props
Widget buildContainer(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildContainer: props=$props');
  return Container(
    width: props['width']?.toDouble(),
    height: props['height']?.toDouble(),
    padding: _parseEdgeInsets(props['padding']),
    margin: _parseEdgeInsets(props['margin']),
    decoration: BoxDecoration(
      color: props['color'] != null ? Color(int.parse(props['color'])) : null,
      borderRadius: props['borderRadius'] != null
          ? BorderRadius.circular(props['borderRadius'].toDouble())
          : null,
    ),
    child: props['child'] != null ? _buildChild(context, props['child']) : null,
  );
}

EdgeInsets? _parseEdgeInsets(dynamic value) {
  if (value is double) {
    return EdgeInsets.all(value);
  }
  // TODO: Parse more complex insets
  return null;
}

// TODO: Implement recursive building
Widget _buildChild(BuildContext context, dynamic child) {
  if (child is Map<String, dynamic>) {
    final type = child['type'] as String? ?? child['component'] as String?;
    if (type != null) {
      final builder = ComponentRegistry().get(type);
      if (builder != null) {
        return builder(context, child);
      }
    }
  }
  return Container();
}
