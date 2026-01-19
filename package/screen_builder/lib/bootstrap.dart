// import 'registry/component_registry.dart';
import 'registry/default_components.dart';
import 'handle/action_handle.dart';
import 'handle/event_handle.dart';
import 'services/api/api_service.dart';
import 'core/interfaces.dart';
import 'core/interfaces/simple_resolver.dart';
import 'config/screen_config.dart';
import 'di/container.dart';
import 'composers/page_composer.dart';
import 'registry/component_registry.dart';

/// Global instance of ScreenConfig
ScreenConfig? _globalConfig;

/// Get the global config
ScreenConfig? get screenBuilderConfig => _globalConfig;

/// Initializes the Screen Builder system with configuration.
///
/// [config] - Configuration including env, jsonPath, apiAdapter, eventHandlers.
Future<void> initScreenBuilder({ScreenConfig? config}) async {
  final cfg = config ??
      ScreenConfig(
          homePage: 'home', navigationFile: 'assets/pages/navigation.json');

  // Store config globally
  _globalConfig = cfg;

  // Set environment
  // TODO: Use cfg.env for conditional logic, e.g., logging

  // Store jsonPath globally (perhaps in a service)
  // For now, assume host handles loading

  // 1. Initialize DI Container
  final container = DIContainer();

  // Register services
  container.register<ApiService>(cfg.apiAdapter ?? ApiService());
  container.register<EventHandle>(EventHandle());
  container.register<ActionHandle>(ActionHandle());

  // 2. Initialize TokenResolver with default tokens
  // For now, empty tokens, can be loaded later
  final tokens = <String, dynamic>{};

  // Note: Old resolvers replaced by ResolverUtil in centralized architecture
  // ResolverManager().register(ColorResolver(tokens));
  // ResolverManager().register(SpacingResolver(tokens));
  // ResolverManager().register(RadiusResolver(tokens));
  // ResolverManager().register(TextStyleResolver(tokens));

  // 3. Initialize ComponentRegistry
  // ComponentRegistry is a singleton, no need to create instance

  // 4. Register default components
  registerDefaultComponents();

  // 5. Initialize ActionHandle
  final actionHandle = container.get<ActionHandle>();
  actionHandle.registerDefaults();

  // 6. Initialize EventHandle and register default handlers
  final eventHandle = container.get<EventHandle>();
  // Note: Default event handlers are now integrated in EventHandle

  // 7. Register PageComposer
  final registry = ComponentRegistry(); // Assume singleton
  final resolver = SimpleResolver(tokens);
  container.register<PageComposer>(PageComposer(registry, resolver));
}

/// Sets up the popup component with the provided BuildContext.
