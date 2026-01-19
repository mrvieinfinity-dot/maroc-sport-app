// lib/engine/utils/resolver_util.dart
import '../../services/token_manager.dart';

/// Utilitaires pour la résolution de tokens et données
/// Centralise la logique de résolution utilisée par l'engine
class ResolverUtil {
  static final TokenManager _tokenManager = TokenManager();

  /// Résout une couleur depuis un token ou valeur directe
  static dynamic resolveColor(dynamic colorValue) {
    if (colorValue is String) {
      // Pour l'instant, seulement parsing hex basique
      if (colorValue.startsWith('#')) {
        return _parseHexColor(colorValue);
      }
    }
    return colorValue;
  }

  /// Résout un espacement depuis un token ou valeur directe
  static double? resolveSpacing(dynamic spacingValue) {
    if (spacingValue is String) {
      // Essayer de parser comme nombre
      return double.tryParse(spacingValue);
    } else if (spacingValue is num) {
      return spacingValue.toDouble();
    }
    return null;
  }

  /// Résout un style de texte depuis un token
  static dynamic resolveTextStyle(dynamic styleValue) {
    // Pour l'instant, retourner la valeur brute
    return styleValue;
  }

  /// Résout une valeur depuis les tokens ou retourne la valeur brute
  static dynamic resolveToken(String key) {
    // Seulement le token d'authentification pour l'instant
    if (key == 'authToken') {
      return TokenManager.authToken;
    }
    return null;
  }

  /// Résout toutes les propriétés d'un composant
  static Map<String, dynamic> resolveComponentProps(
      Map<String, dynamic> props) {
    final resolved = Map<String, dynamic>.from(props);

    // Résoudre les couleurs
    if (resolved.containsKey('color')) {
      resolved['color'] = resolveColor(resolved['color']);
    }
    if (resolved.containsKey('backgroundColor')) {
      resolved['backgroundColor'] = resolveColor(resolved['backgroundColor']);
    }

    // Résoudre les espacements
    if (resolved.containsKey('padding')) {
      resolved['padding'] = resolveSpacing(resolved['padding']);
    }
    if (resolved.containsKey('margin')) {
      resolved['margin'] = resolveSpacing(resolved['margin']);
    }
    if (resolved.containsKey('height')) {
      resolved['height'] = resolveSpacing(resolved['height']);
    }
    if (resolved.containsKey('width')) {
      resolved['width'] = resolveSpacing(resolved['width']);
    }

    // Résoudre les styles de texte
    if (resolved.containsKey('style')) {
      resolved['style'] = resolveTextStyle(resolved['style']);
    }

    return resolved;
  }

  /// Parse une couleur hexadécimale
  static int? _parseHexColor(String hex) {
    try {
      final hexColor = hex.replaceAll('#', '');
      if (hexColor.length == 6) {
        return int.parse('FF$hexColor', radix: 16);
      } else if (hexColor.length == 8) {
        return int.parse(hexColor, radix: 16);
      }
    } catch (e) {
      print('ResolverUtil: Error parsing hex color: $hex');
    }
    return null;
  }

  /// Résout une valeur booléenne depuis string
  static bool? resolveBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }

  /// Résout un entier depuis string ou nombre
  static int? resolveInt(dynamic value) {
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  /// Résout un double depuis string ou nombre
  static double? resolveDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}
