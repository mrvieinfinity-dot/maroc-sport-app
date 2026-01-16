import 'package:flutter/material.dart';
import '../registry/component_registry.dart';
import '../models/page_model.dart';
import 'resolvers/data_resolver.dart';
import 'validators/props_validator.dart';

/// Engine for building pages from PageModel
class PageEngine {
  /// Builds a widget tree from a PageModel
  Map<String, Widget?> buildPage(PageModel page) {
    debugPrint('buildPage: page.components=${page.components}');
    // For now, assume the first component is the root
    if (page.components.isEmpty) return {'body': Container()};
    final rootComponent = buildComponent(page.components.first);
    if (rootComponent is Scaffold) {
      // If it's a Scaffold, extract appBar and body
      final scaffold = rootComponent as Scaffold;
      return {'appBar': scaffold.appBar, 'body': scaffold.body};
    } else {
      return {'body': rootComponent};
    }
  }

  /// Builds a single component from its props
  Widget buildComponent(Map<String, dynamic> component) {
    debugPrint('buildComponent: component=$component');
    final type =
        component['type'] as String? ?? component['component'] as String?;
    if (type == null) return Container();

    // Validate props
    if (!PropsValidator.validate(component)) {
      return Container(); // Or error widget
    }

    // Resolve props
    final resolvedProps = DataResolver.resolveProps(component);

    final builder = ComponentRegistry().get(type);
    if (builder == null) return Container();

    // Handle children
    final children = component['children'] as List<dynamic>? ?? [];
    if (children.isNotEmpty) {
      resolvedProps['children'] = children
          .map((child) => buildComponent(child as Map<String, dynamic>))
          .toList();
    }

    return Builder(
      builder: (context) => builder(context, resolvedProps),
    );
  }
}
