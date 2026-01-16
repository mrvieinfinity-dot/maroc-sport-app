import 'package:flutter/material.dart';
import '../../engine/resolvers/token_resolver.dart';

/// Builds an AppBar component from props
Widget buildAppBar(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildAppBar: props=$props');
  return AppBar(
    title: Text(props['title'] ?? ''),
    backgroundColor: TokenResolver.resolveColor(props['backgroundColor']),
    elevation: props['elevation']?.toDouble() ?? 4.0,
  );
}
