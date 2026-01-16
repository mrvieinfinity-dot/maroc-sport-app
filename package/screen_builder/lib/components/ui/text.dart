import 'package:flutter/material.dart';
import '../../engine/resolvers/token_resolver.dart';

/// Builds a Text component from props
Widget buildText(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildText: props=$props');
  return Text(
    props['text'] ?? '',
    style: TextStyle(
      fontSize: props['fontSize']?.toDouble() ?? 14.0,
      color: TokenResolver.resolveColor(props['color']) ?? Colors.black,
    ),
  );
}
