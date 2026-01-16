import 'event_bus.dart';
import '../../models/event_model.dart';

/// Registers default event handlers
void registerDefaultEventHandlers() {
  // Log API successes
  EventBus().subscribe('api_success', (Event event) {
    print('API Success: ${event.payload}');
  });

  // Log API errors
  EventBus().subscribe('api_error', (Event event) {
    print('API Error: ${event.payload}');
  });

  // Log navigation successes
  EventBus().subscribe('navigate_success', (Event event) {
    print('Navigation Success: ${event.payload}');
  });

  // Log navigation errors
  EventBus().subscribe('navigate_error', (Event event) {
    print('Navigation Error: ${event.payload}');
  });

  // Log custom actions
  EventBus().subscribe('custom_action', (Event event) {
    print('Custom Action: ${event.payload}');
  });
}
