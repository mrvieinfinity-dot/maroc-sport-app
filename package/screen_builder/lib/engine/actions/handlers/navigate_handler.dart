import 'package:flutter/material.dart';
import '../../../navigation/navigation_adapter.dart';
import '../../../engine/events/event_bus.dart';
import '../../../models/event_model.dart';

/// Handler for navigate actions
Future<void> navigateHandler(
    BuildContext? context, Map<String, dynamic> params) async {
  final route = params['route'] ?? params['slug'] ?? params['payload'];
  if (route != null) {
    try {
      NavigationAdapter.instance?.navigate(route);
      EventBus().publish(Event('navigate_success', payload: {'route': route}));
    } catch (e) {
      EventBus().publish(
          Event('navigate_error', payload: {'route': route, 'error': e}));
    }
  }
}
