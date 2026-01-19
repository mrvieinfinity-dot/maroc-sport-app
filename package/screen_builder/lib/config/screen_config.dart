import '../services/api/api_service.dart';
import '../handle/event_handle.dart';

/// Centralized configuration for Screen Builder
class ScreenConfig {
  final String env;
  final String jsonPath;
  final String homePage;
  final String navigationFile;
  final ApiService? apiAdapter;
  final List<EventHandler>? eventHandlers;

  ScreenConfig({
    this.env = 'local',
    this.jsonPath = 'assets/pages/',
    required this.homePage,
    required this.navigationFile,
    this.apiAdapter,
    this.eventHandlers,
  });
}
