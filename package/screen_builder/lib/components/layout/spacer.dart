import 'package:flutter/material.dart';

/// Builds a Spacer component from props
Widget buildSpacer(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildSpacer: props=$props');
  final height = props['height'];
  final width = props['width'];

  if (height != null) {
    return SizedBox(height: _parseSize(height));
  } else if (width != null) {
    return SizedBox(width: _parseSize(width));
  } else {
    return const SizedBox.shrink();
  }
}

double _parseSize(dynamic size) {
  if (size is double) return size;
  if (size is int) return size.toDouble();
  if (size is String) {
    switch (size) {
      case 'xs':
        return 4.0;
      case 's':
        return 8.0;
      case 'm':
        return 16.0;
      case 'l':
        return 24.0;
      case 'xl':
        return 32.0;
      default:
        return double.tryParse(size) ?? 16.0;
    }
  }
  return 16.0;
}
