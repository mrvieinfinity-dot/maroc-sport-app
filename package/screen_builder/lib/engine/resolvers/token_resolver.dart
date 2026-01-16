import 'package:flutter/material.dart';

/// Resolver for design tokens
class TokenResolver {
  static final Map<String, dynamic> _tokens = {};

  /// Registers tokens
  static void registerTokens(Map<String, dynamic> tokens) {
    _tokens.addAll(tokens);
  }

  /// Resoute une couleur token
  static Color? resolveColor(String? key) {
    debugPrint('TokenResolver.resolveColor: key=$key');
    if (key == null) return null;
    final value = _tokens[key];
    debugPrint('TokenResolver.resolveColor: value=$value');
    if (value is String) {
      return Color(int.parse(value));
    }
    return null;
  }

  /// Resolves a spacing token
  static double? resolveSpacing(String? key) {
    if (key == null) return null;
    final value = _tokens[key];
    if (value is num) {
      return value.toDouble();
    }
    return null;
  }

  /// Resolves a radius token
  static double? resolveRadius(String? key) {
    if (key == null) return null;
    final value = _tokens[key];
    if (value is num) {
      return value.toDouble();
    }
    return null;
  }

  /// Resolves a text style token
  static TextStyle? resolveTextStyle(String? key) {
    if (key == null) return null;
    final value = _tokens[key];
    if (value is Map<String, dynamic>) {
      return TextStyle(
        fontSize: value['fontSize']?.toDouble(),
        fontWeight:
            value['fontWeight'] == 'bold' ? FontWeight.bold : FontWeight.normal,
        color: value['color'] != null ? Color(int.parse(value['color'])) : null,
      );
    }
    return null;
  }
}
