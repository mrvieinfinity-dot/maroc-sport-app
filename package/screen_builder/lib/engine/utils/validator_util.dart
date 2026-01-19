// lib/engine/utils/validator_util.dart
import '../../components/props/component_specs.dart';

/// Utilitaires de validation générique
/// Fournit des fonctions de validation réutilisables
class ValidatorUtil {
  /// Valide une spécification de composant
  static ValidationResult validateComponentSpec(ComponentSpec spec) {
    final errors = <String>[];

    // Validation de base
    if (spec.type.isEmpty) {
      errors.add('Component type cannot be empty');
    }

    // Validation spécifique selon le type
    switch (spec.type) {
      case 'text':
        _validateTextSpec(spec, errors);
        break;
      case 'button':
        _validateButtonSpec(spec, errors);
        break;
      case 'container':
        _validateContainerSpec(spec, errors);
        break;
      case 'column':
        _validateColumnSpec(spec, errors);
        break;
      case 'row':
        _validateRowSpec(spec, errors);
        break;
      case 'screen':
        _validateScreenSpec(spec, errors);
        break;
      default:
        // Pour les composants personnalisés, validation minimale
        break;
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Valide un modèle de page
  static ValidationResult validatePageModel(Map<String, dynamic> pageJson) {
    final errors = <String>[];

    if (!pageJson.containsKey('component')) {
      errors.add('Page must have a root component');
    }

    final component = pageJson['component'];
    if (component is! String || component.isEmpty) {
      errors.add('Component type must be a non-empty string');
    }

    if (!pageJson.containsKey('props')) {
      errors.add('Page must have props');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Valide des propriétés JSON
  static ValidationResult validateProps(
      Map<String, dynamic> props, List<String> requiredFields) {
    final errors = <String>[];

    for (final field in requiredFields) {
      if (!props.containsKey(field) || props[field] == null) {
        errors.add('Required field "$field" is missing or null');
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Valide une action
  static ValidationResult validateAction(Map<String, dynamic> action) {
    final errors = <String>[];

    if (!action.containsKey('action')) {
      errors.add('Action must have an "action" field');
    } else {
      final actionType = action['action'];
      if (actionType is! String || actionType.isEmpty) {
        errors.add('Action type must be a non-empty string');
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Valide un événement
  static ValidationResult validateEvent(Map<String, dynamic> event) {
    final errors = <String>[];

    if (!event.containsKey('eventType')) {
      errors.add('Event must have an "eventType" field');
    } else {
      final eventType = event['eventType'];
      if (eventType is! String || eventType.isEmpty) {
        errors.add('Event type must be a non-empty string');
      }
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  // Validations spécifiques par type de composant

  static void _validateTextSpec(ComponentSpec spec, List<String> errors) {
    final content = spec.props['content'] as String?;
    if (content == null || content.isEmpty) {
      errors.add('Text component must have non-empty content');
    }
  }

  static void _validateButtonSpec(ComponentSpec spec, List<String> errors) {
    final text = spec.props['text'] as String?;
    if (text == null || text.isEmpty) {
      errors.add('Button component must have non-empty text');
    }
  }

  static void _validateContainerSpec(ComponentSpec spec, List<String> errors) {
    // Container peut être vide, pas de validation spécifique
  }

  static void _validateColumnSpec(ComponentSpec spec, List<String> errors) {
    // Column peut être vide, pas de validation spécifique
  }

  static void _validateRowSpec(ComponentSpec spec, List<String> errors) {
    // Row peut être vide, pas de validation spécifique
  }

  static void _validateScreenSpec(ComponentSpec spec, List<String> errors) {
    final appBar = spec.props['appBar'] as ComponentSpec?;
    final title = appBar?.props['title'] as String?;
    if (title == null || title.isEmpty) {
      errors.add('Screen component should have an appBar with title');
    }
  }
}

/// Résultat de validation
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({
    required this.isValid,
    required this.errors,
  });

  @override
  String toString() {
    if (isValid) return 'Valid';
    return 'Invalid: ${errors.join(', ')}';
  }
}
