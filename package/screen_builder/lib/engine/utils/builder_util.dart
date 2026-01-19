// lib/engine/utils/builder_util.dart
import '../../models/page_model.dart';
import '../../registry/component_registry.dart';
import '../../components/props/component_specs.dart';

/// Utilitaires génériques pour la construction de composants
/// Fournit des fonctions réutilisables pour les builders et handlers
class BuilderUtil {
  /// Construit une page depuis une route JSON
  static Future<ComponentSpec?> buildPageFromRoute(String route,
      [dynamic arguments]) async {
    try {
      // Charger le JSON de la page
      final pageJson = await _loadPageJson(route);
      if (pageJson == null) return null;

      // Construire le modèle de page depuis le JSON
      final pageModel = PageModel(
        id: pageJson['id'] ?? route,
        components:
            List<Map<String, dynamic>>.from(pageJson['components'] ?? []),
      );

      // Construire la spec de page depuis le premier composant
      if (pageModel.components.isNotEmpty) {
        return _buildComponentSpec(pageModel.components.first);
      }
      return null;
    } catch (e) {
      print('BuilderUtil: Error building page from route $route: $e');
      return null;
    }
  }

  /// Construit une spécification de composant depuis un modèle
  static ComponentSpec? _buildComponentSpec(
      Map<String, dynamic> componentJson) {
    final type = componentJson['type'] as String?;
    if (type == null) return null;

    final builder = ComponentRegistry().get(type);
    if (builder == null) {
      print('BuilderUtil: No builder found for component type: $type');
      return null;
    }

    return builder.buildSpec(componentJson);
  }

  /// Charge le JSON d'une page depuis les assets
  static Future<Map<String, dynamic>?> _loadPageJson(String route) async {
    // Simulation du chargement - en vrai utiliser rootBundle
    print('BuilderUtil: Loading page JSON for route: $route');
    // TODO: Implémenter le chargement réel depuis assets
    return null;
  }

  /// Valide une spécification de composant
  static bool validateComponentSpec(ComponentSpec spec) {
    // Validation de base
    if (spec.type.isEmpty) return false;

    // Validation spécifique selon le type en utilisant les propriétés
    switch (spec.type) {
      case 'text':
        final content = spec.props['content'] as String?;
        return content != null && content.isNotEmpty;
      case 'button':
        final text = spec.props['text'] as String?;
        return text != null && text.isNotEmpty;
      case 'container':
      case 'column':
      case 'row':
      case 'screen':
      case 'image':
      case 'card':
      case 'list':
      case 'spacer':
      case 'popup':
        return true; // Ces types sont valides tant que le type est défini
      default:
        return true; // Pour les types personnalisés
    }
  }

  /// Fusionne des propriétés par défaut avec des propriétés personnalisées
  static Map<String, dynamic> mergeProps(
    Map<String, dynamic> defaultProps,
    Map<String, dynamic> customProps,
  ) {
    final result = Map<String, dynamic>.from(defaultProps);
    result.addAll(customProps);
    return result;
  }

  /// Résout les références dans les propriétés
  static Map<String, dynamic> resolveReferences(
    Map<String, dynamic> props,
    Map<String, dynamic> context,
  ) {
    final resolved = Map<String, dynamic>.from(props);

    // Résoudre les références simples ${key}
    resolved.forEach((key, value) {
      if (value is String && value.contains('\${')) {
        resolved[key] = _resolveStringReferences(value, context);
      }
    });

    return resolved;
  }

  static String _resolveStringReferences(
      String value, Map<String, dynamic> context) {
    return value.replaceAllMapped(
      RegExp(r'\$\{([^}]+)\}'),
      (match) {
        final key = match.group(1)!;
        return context[key]?.toString() ?? '';
      },
    );
  }

  /// Crée une liste de specs enfants depuis une liste JSON
  static List<ComponentSpec> buildChildren(List<dynamic>? childrenJson) {
    if (childrenJson == null) return [];

    return childrenJson
        .map((childJson) =>
            _buildComponentSpec(childJson as Map<String, dynamic>))
        .where((spec) => spec != null)
        .cast<ComponentSpec>()
        .toList();
  }
}
