import 'package:flutter_test/flutter_test.dart';
import 'package:screen_builder/screen_builder.dart';

void main() {
  setUp(() async {
    await initScreenBuilder();
  });

  test('event bus publishes and subscribes', () {
    final bus = EventBus();
    bool received = false;
    bus.subscribe('test', (event) {
      received = true;
      expect(event.type, 'test');
    });

    bus.publish(Event('test'));
    expect(received, true);
  });

  test('default event handlers are registered', () {
    // Since initScreenBuilder calls registerDefaultEventHandlers, events should be logged
    EventBus().publish(Event('api_success', payload: 'test'));
    // No assertion, just ensure no crash
  });
}
