import 'package:flutter/material.dart';
import '../../engine/actions/action_engine.dart';
import '../../engine/resolvers/token_resolver.dart';

/// Builds a Button component from props
Widget buildButton(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildButton: props=$props');
  final onTap = props['onTap'];
  final action = props['action'];
  return ElevatedButton(
    onPressed: () {
      if (onTap != null) {
        ActionEngine().execute(context, onTap, props);
      } else if (action != null) {
        ActionEngine().execute(context, action, props);
      }
    },
    child: Text(props['text'] ?? 'Button'),
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
        TokenResolver.resolveColor(props['color']) ?? Colors.blue,
      ),
    ),
  );
}
