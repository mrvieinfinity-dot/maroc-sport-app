import '../interfaces.dart';

/// Utility to resolve props from config, handling defaults and resolvers
Map<String, dynamic> resolveProps(
  Map<String, dynamic> config,
  Map<String, dynamic> defaults,
  Resolver resolver,
) {
  final resolved = <String, dynamic>{};

  for (final key in config.keys) {
    final value = config[key];
    if (value is String && value.startsWith('@')) {
      resolved[key] = resolver.resolve(value.substring(1));
    } else {
      resolved[key] = value;
    }
  }

  // Apply defaults for missing keys
  for (final key in defaults.keys) {
    if (!resolved.containsKey(key)) {
      resolved[key] = defaults[key];
    }
  }

  return resolved;
}

/// Utility to merge configs
Map<String, dynamic> mergeConfigs(
  Map<String, dynamic> base,
  Map<String, dynamic> override,
) {
  return {...base, ...override};
}
