/// Validator for props
class PropsValidator {
  /// Validates component props
  static bool validate(Map<String, dynamic> props) {
    final type = props['type'] as String? ?? props['component'] as String?;
    if (type == null) return false;

    // Basic validation: ensure required props are present
    switch (type) {
      case 'text':
        return props.containsKey('text');
      case 'button':
        return props.containsKey('text'); // onTap is optional
      case 'image':
        return props.containsKey('src');
      case 'column':
      case 'row':
        return props.containsKey('children') && props['children'] is List;
      case 'container':
        // child is optional
        return true;
      default:
        return true; // For custom components, assume valid
    }
  }
}
