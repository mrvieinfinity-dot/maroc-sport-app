import '../../core/interfaces.dart';
import '../props/component_specs.dart';

/// Builder for Button components
/// Returns a ComponentSpecData instead of directly building a Widget
class ButtonBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    final text = props['text'] ?? 'Button';
    final action = props['action'] as String?;
    final colorKey = props['color'] as String?;

    // Note: onPressed callback will be resolved by the action engine
    // during rendering, not during spec building
    return ComponentSpecData(
      type: 'button',
      props: {
        'text': text,
        'action': action,
        'colorKey': colorKey,
        ...props,
      },
    );
  }
}
