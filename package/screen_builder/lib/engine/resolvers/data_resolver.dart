import 'token_resolver.dart';
import '../validators/security_validator.dart';

/// Resolver for data and props
class DataResolver {
  /// Resolves a value, handling tokens, bindings, defaults, etc.
  static dynamic resolve(dynamic value) {
    if (value is String) {
      // Check for token references like "token:color.primary"
      if (value.startsWith('token:')) {
        final parts = value.split(':');
        if (parts.length == 3) {
          final type = parts[1];
          final key = parts[2];
          switch (type) {
            case 'color':
              return TokenResolver.resolveColor(key);
            case 'spacing':
              return TokenResolver.resolveSpacing(key);
            case 'radius':
              return TokenResolver.resolveRadius(key);
            case 'textStyle':
              return TokenResolver.resolveTextStyle(key);
          }
        }
      }
      // Security check for potential scripts
      if (!SecurityValidator.validate(value)) {
        return null; // Or sanitized value
      }
      // TODO: Handle bindings like "{{user.name}}"
      // TODO: Handle defaults
    }
    return value;
  }

  /// Resolves all props in a component map
  static Map<String, dynamic> resolveProps(Map<String, dynamic> props) {
    final resolved = <String, dynamic>{};
    props.forEach((key, value) {
      resolved[key] = resolve(value);
    });
    return resolved;
  }
}
