import 'package:flutter/material.dart';
import '../../engine/events/event_bus.dart';
import '../../models/event_model.dart';

/// Builds a Popup component that listens to api_success and api_error events
Widget buildPopup(BuildContext context, Map<String, dynamic> props) {
  // This component subscribes to events and shows SnackBar
  // Since it's a widget, we use a StatefulWidget or StreamBuilder, but for simplicity, assume it's handled globally

  // For now, return an empty container; the popup is handled by event listeners in the app
  return Container();
}

// Global popup handler
void setupPopup(BuildContext context) {
  EventBus().subscribe('api_success', (Event event) {
    final message = event.payload?['message'] ?? 'Success';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  });

  EventBus().subscribe('api_error', (Event event) {
    final message = event.payload?['message'] ?? 'Error';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  });
}
