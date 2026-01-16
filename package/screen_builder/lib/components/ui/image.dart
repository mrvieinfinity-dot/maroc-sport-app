import 'package:flutter/material.dart';

/// Builds an Image component from props
Widget buildImage(BuildContext context, Map<String, dynamic> props) {
  debugPrint('buildImage: props=$props');
  return Image.network(
    props['src'] ?? '',
    width: props['width']?.toDouble(),
    height: props['height']?.toDouble(),
  );
}
