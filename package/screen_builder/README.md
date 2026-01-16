# Screen Builder

A modular, dynamic, secure screen builder for Flutter. Build complete CMS-like applications from JSON configurations.

## Features

- **CMS Model**: Everything defined in JSON - pages, navigation, reusable components
- **JSON Pages**: Each screen described in JSON with reusable components via `component` and `props`
- **JSON Navigation**: Navigation bar defined in JSON, pages auto-loaded
- **ScreenBuilderConfig**: Centralizes all settings as a CMS panel
- **ScreenBuilderPage**: Single widget that loads home page and applies navigation
- Extensible component registry
- Action engine for handling user interactions
- Event bus for reactive programming
- Token-based design system
- Navigation adapter for routing

## Getting Started

Add to your pubspec.yaml:

```yaml
dependencies:
  screen_builder: ^1.0.0
```

Initialize the screen builder with configuration:

```dart
import 'package:screen_builder/screen_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initScreenBuilder(
    config: ScreenBuilderConfig(
      env: 'prod',
      jsonPath: 'assets/pages/',
      homePage: 'home',
      navigationFile: 'assets/pages/navigation.json',
    ),
  );

  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScreenBuilderPage(),
    );
  }
}
```

## JSON Structure

### Pages (e.g., home.json)
```json
{
  "component": "screen",
  "children": [
    {"component": "appbar", "props": {"title": "Welcome"}},
    {
      "component": "column",
      "children": [
        {"component": "text", "props": {"text": "Hello World"}},
        {"component": "spacer", "props": {"height": "m"}},
        {"component": "button", "props": {"text": "Go to Profile", "action": "navigate:profile"}}
      ]
    }
  ]
}
```

### Navigation (navigation.json)
```json
{
  "items": [
    {"label": "Home", "icon": "home", "page": "home"},
    {"label": "Profile", "icon": "person", "page": "profile"}
  ]
}
```

## Usage

See the example in the `example/` directory.