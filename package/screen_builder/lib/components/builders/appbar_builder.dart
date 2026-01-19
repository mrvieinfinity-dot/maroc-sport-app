import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../props/component_specs.dart';

/// Builder for AppBar components
/// Returns a ComponentSpecData instead of directly building a Widget
class AppBarBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    final title = props['title'];
    final leading = props['leading'];
    final actions = props['actions'] as List<dynamic>?;
    final backgroundColor = props['backgroundColor'] as String?;
    final elevation = props['elevation'] as double?;
    final centerTitle = props['centerTitle'] as bool?;
    final automaticallyImplyLeading =
        props['automaticallyImplyLeading'] as bool? ?? true;

    return ComponentSpecData(
      type: 'appbar',
      props: {
        'title': title,
        'leading': leading,
        'actions': actions,
        'backgroundColor': backgroundColor,
        'elevation': elevation,
        'centerTitle': centerTitle,
        'automaticallyImplyLeading': automaticallyImplyLeading,
        ...props,
      },
    );
  }
}
