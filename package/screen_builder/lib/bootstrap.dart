import 'package:flutter/material.dart';
// import 'registry/component_registry.dart';
import 'registry/default_components.dart';
import 'engine/actions/action_engine.dart';
import 'engine/events/event_bus.dart';
import 'engine/events/default_event_handlers.dart';
import 'engine/events/event_handler.dart';
import 'services/api/api_service.dart';
import 'components/ui/popup.dart';

/// Configuration for Screen Builder
class ScreenBuilderConfig {
  final String env; // 'prod', 'local', 'staging'
  final String jsonPath; // Path to JSON files, e.g., 'assets/pages/'
  final String homePage; // Default home page name
  final String navigationFile; // Navigation JSON file path
  final ApiService? apiAdapter;
  final List<EventHandler>? eventHandlers;

  ScreenBuilderConfig({
    this.env = 'local',
    this.jsonPath = 'assets/pages/',
    required this.homePage,
    required this.navigationFile,
    this.apiAdapter,
    this.eventHandlers,
  });
}

/// Global instance of ScreenBuilderConfig
ScreenBuilderConfig? _globalConfig;

/// Get the global config
ScreenBuilderConfig? get screenBuilderConfig => _globalConfig;

/// Initializes the Screen Builder system with configuration.
///
/// [config] - Configuration including env, jsonPath, apiAdapter, eventHandlers.
Future<void> initScreenBuilder({ScreenBuilderConfig? config}) async {
  final cfg = config ??
      ScreenBuilderConfig(
          homePage: 'home', navigationFile: 'assets/pages/navigation.json');

  // Store config globally
  _globalConfig = cfg;

  // Set environment
  // TODO: Use cfg.env for conditional logic, e.g., logging

  // Store jsonPath globally (perhaps in a service)
  // For now, assume host handles loading

  // 1. Initialize TokenResolver with default tokens
  // Tokens can be loaded from JSON or provided

  // 2. Initialize ComponentRegistry
  // ComponentRegistry is a singleton, no need to create instance

  // 3. Register default components
  registerDefaultComponents();

  // 4. Register host components if any (via config? but for now none)

  // 5. Initialize ActionEngine
  final actionEngine = ActionEngine();
  actionEngine.registerDefaults();

  // 6. Initialize EventBus and register default handlers
  final eventBus = EventBus();
  registerDefaultEventHandlers();
  if (cfg.eventHandlers != null) {
    for (final handler in cfg.eventHandlers!) {
      eventBus.subscribe(handler.eventType, handler.handle);
    }
  }

  // 7. Set up ApiService if provided
  if (cfg.apiAdapter != null) {
    ApiService.setInstance(cfg.apiAdapter!);
  }

  // TODO: Store config globally
}

/// Sets up the popup component with the provided BuildContext.
/// Call this after initScreenBuilder and when you have a BuildContext.
void setupPopupWithContext(BuildContext context) {
  setupPopup(context);
}
