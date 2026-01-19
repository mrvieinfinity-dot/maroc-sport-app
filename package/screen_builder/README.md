# Screen Builder v4.0

A modular, dynamic screen builder for Flutter with a centralized handle-based architecture.

## 🆕 Architecture Centralisée v4.0

Screen Builder v4.0 introduces a revolutionary centralized architecture with the **Handle System**:

- **🟢 Handle System**: Unified hub for all interactions (Actions, Events, Navigation)
- **🟡 Centralized Utils**: Shared utilities (API, Builder, Resolver, Validator)
- **🟠 SpecsRenderer**: Single point for Flutter widget rendering
- **🔵 Bootstrap**: Centralized initialization

### Key Components

- `Handle`: Abstract interface for all interaction types
- `ActionHandle`: Centralized user actions (navigate, api_get, api_post, custom)
- `EventHandle`: Integrated event bus with publish/subscribe
- `NavigationHandle`: Flexible navigation with interchangeable strategies
- `ApiUtil`, `BuilderUtil`, `ResolverUtil`, `ValidatorUtil`: Shared utilities
- `ComponentSpec`: Data-only UI descriptions
- `SpecsRenderer`: Single point for Flutter widget creation

## Quick Start

### 1. Initialize the System

```dart
import 'package:screen_builder/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize centralized system
  await Bootstrap.initialize();

  runApp(MyApp());
}
```

### 2. Use in Your App

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenBuilderPage(
      config: ScreenBuilderConfig(
        jsonPath: 'assets/pages/',
        homePage: 'home',
        navigationFile: 'assets/navigation.json',
      ),
    );
  }
}
```

### 3. JSON Page Example

```json
{
  "component": "screen",
  "props": {"title": "Home"},
  "children": [
    {
      "component": "text",
      "props": {"text": "Welcome to Maroc Sport!"}
    },
    {
      "component": "button",
      "props": {
        "text": "Get Started",
        "action": {
          "type": "navigate",
          "action": "navigate",
          "params": {"route": "profile"}
        }
      }
    }
  ]
}
```

## 🆕 Handle System Usage

### Actions via ActionHandle

```json
{
  "component": "button",
  "props": {
    "text": "Login",
    "action": {
      "type": "action",
      "action": "api_post",
      "params": {
        "endpoint": "/auth/login",
        "data": {"email": "user@example.com", "password": "123456"}
      }
    }
  }
}
```

### Events via EventHandle

```dart
// Subscribe to events
EventHandle().subscribe('api_success', (data) {
  print('API Success: $data');
});

// Publish events
EventHandle().publish('user_action', {'action': 'button_click'});
```

### Navigation via NavigationHandle

```dart
// Change navigation strategy
final navHandle = DIContainer().get<NavigationHandle>('navigation');
navHandle.setStrategy(GoRouterStrategy());

// Navigate
await navHandle.navigateTo('profile', {'userId': 123});
```

## 🆕 Extending the System

### Add a Custom Handle

```dart
class AnalyticsHandle extends Handle {
  @override
  Future<dynamic> execute(String action, Map<String, dynamic> params) async {
    switch (action) {
      case 'track_event':
        return _trackEvent(params['event'], params['data']);
      default:
        throw UnsupportedError('Unknown action: $action');
    }
  }

  Future<void> _trackEvent(String event, Map<String, dynamic> data) async {
    // Analytics logic
    print('Tracking: $event with data: $data');
  }
}

// Register in bootstrap
await DIContainer().register<Handle>('analytics', AnalyticsHandle());
```

### Add a Custom Component

```dart
class CardBuilder implements ComponentBuilder {
  @override
  ComponentSpec buildSpec(Map<String, dynamic> json) {
    return ContainerSpec(
      type: 'card',
      props: ContainerProps.fromJson(json),
      children: _buildChildren(json['children']),
    );
  }
}

// Register
ComponentRegistry().register('card', CardBuilder());
```

## Architecture Benefits

- ✅ **Centralized Logic**: All business logic in handles
- ✅ **Testable**: Handles testable independently
- ✅ **Observable**: Unified tracing and debugging
- ✅ **Interchangeable**: Strategies changeable at runtime
- ✅ **Maintainable**: Clear separation of concerns
- ✅ **Extensible**: Easy to add new handles and components

## Migration from v3.x

Version 4.0 centralizes the architecture:

- Actions now go through `ActionHandle` instead of separate engines
- Events use `EventHandle` instead of EventBus
- Navigation uses `NavigationHandle` with strategies
- Utilities are centralized in `engine/utils/`
- Bootstrap initializes everything centrally

JSON compatibility is maintained.

## Documentation

- [Guide Complet](./docs/maroc_sport_complete_guide.md) - Complete user guide
- [Guide Détaillé](./docs/screen_builder_detailed_guide.md) - Technical documentation
- [Architecture](./ARCHITECTURE.md) - Architecture overview

## Testing

```bash
flutter test
```

All tests pass with the centralized architecture.

## Contributing

1. Follow the handle-based architecture
2. Add tests for new handles
3. Update documentation
4. Maintain backward compatibility</content>
<parameter name="filePath">c:\Users\pc\Downloads\maroc_sport_copie-main\package\screen_builder\README.md
