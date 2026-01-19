import 'package:flutter/material.dart';
import '../registry/component_registry.dart';
import '../models/page_model.dart';
import 'utils/resolver_util.dart';
import '../core/logger.dart';
import 'specs_renderer.dart';
import '../components/props/component_specs.dart';

/// Engine for building pages from PageModel
/// Now works with ComponentSpecs instead of directly building Widgets
class PageEngine {
  final SpecsRenderer _renderer = SpecsRenderer();

  /// Builds a widget tree from a PageModel
  Widget buildPage(BuildContext context, PageModel page) {
    debugPrint('buildPage: page.components=${page.components}');
    // For now, assume the first component is the root
    if (page.components.isEmpty) return Container();

    final rootComponent = page.components.first;

    // Auto-detect screen structure
    final autoDetectedScreen = _autoDetectScreenStructure(rootComponent);
    final componentToBuild = autoDetectedScreen ?? rootComponent;

    final rootSpec = buildComponentSpec(componentToBuild);
    final rootWidget = _renderer.render(context, rootSpec);

    if (rootWidget is Scaffold) {
      debugPrint(
          '[DEBUG] PageEngine: RootWidget is Scaffold, returning new Scaffold');
      // If it's a Scaffold, extract appBar and body
      return Scaffold(
        appBar: rootWidget.appBar,
        body: rootWidget.body,
        drawer: rootWidget.drawer,
      );
    } else {
      return rootWidget;
    }
  }

  /// Automatically detects and creates screen structure from root component
  Map<String, dynamic>? _autoDetectScreenStructure(
      Map<String, dynamic> component) {
    // Check if it's already a screen component
    final type =
        component['type'] as String? ?? component['component'] as String?;
    if (type == 'screen') {
      return null; // Already a screen, no need to auto-detect
    }

    // Check for screen-like properties
    final hasAppBar = component.containsKey('appBar');
    final hasBody = component.containsKey('body');
    final hasDrawer = component.containsKey('drawer');
    final hasFloatingActionButton =
        component.containsKey('floatingActionButton');
    final hasBottomNavigationBar = component.containsKey('bottomNavigationBar');

    // If it has screen properties, create a screen structure
    if (hasAppBar ||
        hasBody ||
        hasDrawer ||
        hasFloatingActionButton ||
        hasBottomNavigationBar) {
      debugPrint('[DEBUG] PageEngine: Auto-detected screen structure');

      // Create a copy of the component without screen properties
      final componentCopy = Map<String, dynamic>.from(component);
      componentCopy.remove('appBar');
      componentCopy.remove('body');
      componentCopy.remove('drawer');
      componentCopy.remove('floatingActionButton');
      componentCopy.remove('bottomNavigationBar');

      return {
        'component': 'screen',
        'props': {
          if (hasAppBar) 'appBar': component['appBar'],
          if (hasDrawer) 'drawer': component['drawer'],
          if (hasFloatingActionButton)
            'floatingActionButton': component['floatingActionButton'],
          if (hasBottomNavigationBar)
            'bottomNavigationBar': component['bottomNavigationBar'],
        },
        'children': hasBody
            ? [component['body']]
            : (componentCopy.isNotEmpty ? [componentCopy] : []),
      };
    }

    // Check for simple content that should be wrapped in a screen
    final hasChildren = component.containsKey('children') &&
        (component['children'] as List?)?.isNotEmpty == true;
    final hasTitle = component.containsKey('title');

    if (hasChildren && !hasAppBar && !hasBody) {
      debugPrint('[DEBUG] PageEngine: Auto-wrapping content in screen');

      return {
        'component': 'screen',
        'props': {
          if (hasTitle)
            'appBar': {
              'component': 'appbar',
              'props': {'title': component['title']}
            },
        },
        'children': component['children'], // Use children directly
      };
    }

    return null; // No auto-detection needed
  }

  /// Builds a ComponentSpec from component props
  ComponentSpec buildComponentSpec(Map<String, dynamic> component) {
    debugPrint('buildComponentSpec: component=$component');
    final type =
        component['type'] as String? ?? component['component'] as String?;
    if (type == null) {
      throw FlutterError('Component missing type: $component');
    }

    // Resolve props
    final props = component['props'] as Map<String, dynamic>? ?? {};
    final resolvedProps = ResolverUtil.resolveComponentProps(props);

    final builder = ComponentRegistry().get(type);
    if (builder == null) {
      SBLogger.error(
          'No builder registered for component type: $type. Component: $component');
      // Throw to make the failure explicit instead of silently returning an empty container
      throw FlutterError('No builder registered for component type: $type');
    }

    // Handle children
    final children = component['children'] as List<dynamic>? ?? [];
    final builtChildren = children.isNotEmpty
        ? children
            .map((child) => buildComponentSpec(child as Map<String, dynamic>))
            .toList()
        : null;

    if (builtChildren != null) {
      resolvedProps['children'] = builtChildren;
    }

    // Build the spec using the builder
    final spec = builder.buildSpec(resolvedProps);

    return spec;
  }
}
