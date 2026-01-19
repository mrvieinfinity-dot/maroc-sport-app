import 'package:flutter/material.dart';
import '../core/interfaces.dart';
import '../registry/component_registry.dart';
import '../engine/specs_renderer.dart';
import '../engine/utils/resolver_util.dart';
import '../components/props/component_specs.dart';

/// Composer for building components recursively
class ComponentComposer implements Composer<Widget> {
  final ComponentRegistry registry;
  final Resolver resolver;

  ComponentComposer(this.registry, this.resolver);

  @override
  Widget compose(BuildContext context, Map<String, dynamic> config) {
    final spec = _buildComponentSpec(config);
    return SpecsRenderer().render(context, spec);
  }

  /// Builds a ComponentSpec from component props (recursive)
  ComponentSpec _buildComponentSpec(Map<String, dynamic> component) {
    final type = component['type'] as String?;
    if (type == null) {
      throw FlutterError('Component missing type: $component');
    }

    // Resolve props
    final props = component['props'] as Map<String, dynamic>? ?? {};
    final resolvedProps = ResolverUtil.resolveComponentProps(props);

    final builder = registry.get(type);
    if (builder == null) {
      throw FlutterError('No builder registered for component type: $type');
    }

    // Handle children recursively
    final children = component['children'] as List<dynamic>? ?? [];
    final builtChildren = children.isNotEmpty
        ? children
            .map((child) => _buildComponentSpec(child as Map<String, dynamic>))
            .toList()
        : null;

    if (builtChildren != null) {
      resolvedProps['children'] = builtChildren;
    }

    // Build the spec using the builder
    return builder.buildSpec(resolvedProps);
  }
}
