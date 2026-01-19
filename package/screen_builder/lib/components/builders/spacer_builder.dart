import 'package:flutter/material.dart';
import '../../core/interfaces.dart';
import '../props/component_specs.dart';

/// Builder for Spacer components
/// Returns a ComponentSpecData instead of directly building a Widget
class SpacerBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> props) {
    final height = props['height'];
    final width = props['width'] as double?;
    final flex = props['flex'] as int?;

    // Handle different height formats
    double? actualHeight;
    if (height != null) {
      if (height is double) {
        actualHeight = height;
      } else if (height is int) {
        actualHeight = height.toDouble();
      } else if (height is String) {
        // Handle predefined sizes
        switch (height) {
          case 'xs':
            actualHeight = 4.0;
            break;
          case 's':
            actualHeight = 8.0;
            break;
          case 'm':
            actualHeight = 16.0;
            break;
          case 'l':
            actualHeight = 24.0;
            break;
          case 'xl':
            actualHeight = 32.0;
            break;
          default:
            actualHeight = double.tryParse(height);
        }
      }
    }

    return ComponentSpecData(
      type: 'spacer',
      props: {
        'height': actualHeight,
        'width': width,
        'flex': flex,
        ...props,
      },
    );
  }
}
