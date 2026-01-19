import '../interfaces.dart';

/// Simple resolver for tokens
class SimpleResolver implements Resolver<dynamic> {
  final Map<String, dynamic> tokens;

  SimpleResolver(this.tokens);

  @override
  dynamic resolve(String? key) {
    if (key != null && key.startsWith('@')) {
      final actualKey = key.substring(1);
      return tokens[actualKey];
    }
    return key;
  }
}
