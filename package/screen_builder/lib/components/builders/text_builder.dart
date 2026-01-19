import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../props/component_specs.dart';

/// Builder for Text components
/// Returns a ComponentSpecData instead of directly building a Widget
class TextBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    final content = props['text'] ?? props['content'] ?? '';
    final styleKey = props['style'] as String?;
    final textAlign = _parseTextAlign(props['textAlign']);

    return ComponentSpecData(
      type: 'text',
      props: {
        'content': content,
        'styleKey': styleKey,
        'textAlign': textAlign,
        ...props,
      },
    );
  }

  TextAlign? _parseTextAlign(dynamic align) {
    if (align == null) return null;
    switch (align.toString().toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'right':
        return TextAlign.right;
      case 'center':
        return TextAlign.center;
      case 'justify':
        return TextAlign.justify;
      case 'start':
        return TextAlign.start;
      case 'end':
        return TextAlign.end;
      default:
        return null;
    }
  }
}
