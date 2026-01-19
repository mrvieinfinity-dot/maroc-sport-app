import 'dart:convert';

/// Test script to verify auto-detection logic
void main() {
  // Test case 1: Simple structure with title and children
  final simpleComponent = {
    "title": "Test Page",
    "children": [
      {
        "component": "text",
        "props": {"text": "Hello"},
      },
    ],
  };

  final result1 = autoDetectScreenStructure(simpleComponent);
  print('Test 1 - Simple structure:');
  print('Input: $simpleComponent');
  print('Output: ${jsonEncode(result1)}');
  print('');

  // Test case 2: Structure with explicit appBar
  final appBarComponent = {
    "appBar": {
      "component": "appbar",
      "props": {"title": "Custom Title"},
    },
    "children": [
      {
        "component": "text",
        "props": {"text": "Content"},
      },
    ],
  };

  final result2 = autoDetectScreenStructure(appBarComponent);
  print('Test 2 - With appBar:');
  print('Input: $appBarComponent');
  print('Output: ${jsonEncode(result2)}');
  print('');
}

Map<String, dynamic>? autoDetectScreenStructure(
  Map<String, dynamic> component,
) {
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
  final hasFloatingActionButton = component.containsKey('floatingActionButton');
  final hasBottomNavigationBar = component.containsKey('bottomNavigationBar');

  // If it has screen properties, create a screen structure
  if (hasAppBar ||
      hasBody ||
      hasDrawer ||
      hasFloatingActionButton ||
      hasBottomNavigationBar) {
    print('[DEBUG] PageEngine: Auto-detected screen structure');

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
  final hasChildren =
      component.containsKey('children') &&
      (component['children'] as List?)?.isNotEmpty == true;
  final hasTitle = component.containsKey('title');

  if (hasChildren && !hasAppBar && !hasBody) {
    print('[DEBUG] PageEngine: Auto-wrapping content in screen');

    // Create a copy of the component without screen properties
    final componentCopy = Map<String, dynamic>.from(component);
    componentCopy.remove('title');

    return {
      'component': 'screen',
      'props': {
        if (hasTitle)
          'appBar': {
            'component': 'appbar',
            'props': {'title': component['title']},
          },
      },
      'children': componentCopy.isNotEmpty ? [componentCopy] : [],
    };
  }

  return null; // No auto-detection needed
}
