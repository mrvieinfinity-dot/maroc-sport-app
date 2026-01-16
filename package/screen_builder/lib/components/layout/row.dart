import 'package:flutter/material.dart';
import '../../registry/component_registry.dart';

/// Builds a Row component from props
Widget buildRow(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildRow: props=$props');
  final children = props['children'];
  List<Widget> childWidgets = [];
  if (children is List<Widget>) {
    childWidgets = children;
  } else if (children is List<dynamic>) {
    childWidgets =
        children.map((child) => _buildChild(context, child)).toList();
  }
  return Row(
    mainAxisAlignment: _parseMainAxisAlignment(props['mainAxisAlignment']),
    crossAxisAlignment: _parseCrossAxisAlignment(props['crossAxisAlignment']),
    children: childWidgets,
  );
}

MainAxisAlignment _parseMainAxisAlignment(String? value) {
  switch (value) {
    case 'start':
      return MainAxisAlignment.start;
    case 'end':
      return MainAxisAlignment.end;
    case 'center':
      return MainAxisAlignment.center;
    case 'spaceBetween':
      return MainAxisAlignment.spaceBetween;
    case 'spaceAround':
      return MainAxisAlignment.spaceAround;
    case 'spaceEvenly':
      return MainAxisAlignment.spaceEvenly;
    default:
      return MainAxisAlignment.start;
  }
}

CrossAxisAlignment _parseCrossAxisAlignment(String? value) {
  switch (value) {
    case 'start':
      return CrossAxisAlignment.start;
    case 'end':
      return CrossAxisAlignment.end;
    case 'center':
      return CrossAxisAlignment.center;
    case 'stretch':
      return CrossAxisAlignment.stretch;
    default:
      return CrossAxisAlignment.center;
  }
}

// TODO: Implement recursive building
Widget _buildChild(BuildContext context, dynamic child) {
  if (child is Widget) {
    return child;
  }
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
