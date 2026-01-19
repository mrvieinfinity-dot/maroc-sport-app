import '../../core/interfaces.dart';
import '../props/component_specs.dart';

/// Builder for Screen/Scaffold components
/// Returns a ComponentSpecData instead of directly building a Widget
class ScreenBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    // AppBar
    ComponentSpecData? appBar;
    if (props['appBar'] != null) {
      final appBarProps = props['appBar'] as Map<String, dynamic>;
      appBar = ComponentSpecData(
        type: 'appbar',
        props: {
          'title': appBarProps['title'] ?? 'Screen',
          'actions': _parseActions(appBarProps['actions']),
        },
      );
    }

    // Drawer
    ComponentSpecData? drawer;
    if (props['drawer'] != null) {
      final drawerProps = props['drawer'] as Map<String, dynamic>;
      drawer = ComponentSpecData(
        type: 'drawer',
        props: {
          'items': _parseDrawerItems(drawerProps['items']),
        },
      );
    }

    // Extract children from props
    final children = props['children'] as List<ComponentSpec>?;

    return ComponentSpecData(
      type: 'screen',
      props: {
        ...props,
        'appBar': appBar,
        'drawer': drawer,
      },
      children: children,
    );
  }

  List<ComponentSpecData>? _parseActions(dynamic actions) {
    if (actions == null) return null;
    if (actions is List) {
      return actions.map((action) {
        if (action is Map<String, dynamic>) {
          return ComponentSpecData(
            type: 'button',
            props: {
              'text': action['text'] ?? '',
              'action': action['action'],
            },
          );
        }
        return ComponentSpecData(
          type: 'button',
          props: {'text': action.toString()},
        );
      }).toList();
    }
    return null;
  }

  List<ComponentSpecData>? _parseDrawerItems(dynamic items) {
    if (items == null) return null;
    if (items is List) {
      return items.map((item) {
        if (item is Map<String, dynamic>) {
          // For now, assume drawer items are buttons or text
          final type = item['type'] ?? 'text';
          switch (type) {
            case 'button':
              return ComponentSpecData(
                type: 'button',
                props: {
                  'text': item['text'] ?? '',
                  'action': item['action'],
                },
              );
            default:
              return ComponentSpecData(
                type: 'text',
                props: {'content': item['text'] ?? ''},
              );
          }
        }
        return ComponentSpecData(
          type: 'text',
          props: {'content': item.toString()},
        );
      }).toList();
    }
    return null;
  }
}
