import 'package:flutter/material.dart';
import '../../../engine/events/event_bus.dart';
import '../../../models/event_model.dart';

/// Handler for custom actions
Future<void> customHandler(
    BuildContext? context, Map<String, dynamic> params) async {
  // Placeholder: publish a custom event
  EventBus().publish(Event('custom_action', payload: params));
}
