import '../../models/event_model.dart';

/// Interface for event handlers
abstract class EventHandler {
  String get eventType;
  void handle(Event event);
}
