import 'package:flutter/material.dart';
import '../core/interfaces.dart';

/// Composer for layout components
class LayoutComposer implements Composer<Widget> {
  @override
  Widget compose(BuildContext context, Map<String, dynamic> config) {
    final type = config['type'] as String?;
    switch (type) {
      case 'column':
        final children = config['children'] as List<dynamic>? ?? [];
        return Column(
          children: children
              .map((child) => compose(context, child as Map<String, dynamic>))
              .toList(),
        );
      case 'row':
        final children = config['children'] as List<dynamic>? ?? [];
        return Row(
          children: children
              .map((child) => compose(context, child as Map<String, dynamic>))
              .toList(),
        );
      default:
        return const SizedBox();
    }
  }
}
