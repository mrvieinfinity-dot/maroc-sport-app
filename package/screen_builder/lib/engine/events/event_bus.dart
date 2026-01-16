import '../../models/event_model.dart';

/// Event bus for publish/subscribe pattern
class EventBus {
  static final EventBus _instance = EventBus._internal();

  factory EventBus() => _instance;

  EventBus._internal();

  final Map<String, List<Function(Event)>> _subscribers = {};

  /// Publishes an event to all subscribers
  void publish(Event event) {
    final subscribers = _subscribers[event.type];
    if (subscribers != null) {
      for (final subscriber in subscribers) {
        subscriber(event);
      }
    }
  }

  /// Subscribes to an event type
  void subscribe(String type, Function(Event) handler) {
    _subscribers.putIfAbsent(type, () => []).add(handler);
  }

  /// Unsubscribes from an event type
  void unsubscribe(String type, Function(Event) handler) {
    final subscribers = _subscribers[type];
    if (subscribers != null) {
      subscribers.remove(handler);
    }
  }
}
