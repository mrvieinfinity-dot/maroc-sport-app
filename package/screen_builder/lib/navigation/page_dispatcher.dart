import 'package:flutter/material.dart';
import '../engine/events/event_bus.dart';
import '../models/event_model.dart';

/// Dispatcher for page routing
class PageDispatcher {
  static final Map<String, WidgetBuilder> _routes = {};

  /// Registers a route
  static void register(String slug, WidgetBuilder builder) {
    _routes[slug] = builder;
  }

  /// Dispatches a route to a widget
  static Widget? dispatch(String slug) {
    final builder = _routes[slug];
    if (builder != null) {
      return Builder(builder: builder);
    } else {
      // Fallback: publish error event
      EventBus().publish(Event('navigate_error',
          payload: {'slug': slug, 'reason': 'Route not found'}));
      return null;
    }
  }

  /// Checks if a route is registered
  static bool hasRoute(String slug) {
    return _routes.containsKey(slug);
  }
}
