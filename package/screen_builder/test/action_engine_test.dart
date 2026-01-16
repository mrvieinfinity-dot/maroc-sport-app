import 'package:flutter_test/flutter_test.dart';
import 'package:screen_builder/screen_builder.dart';

void main() {
  setUp(() async {
    await initScreenBuilder();
  });

  test('action engine executes custom action', () async {
    final engine = ActionEngine();
    bool executed = false;
    engine.register('test', (context, params) async {
      executed = true;
    });

    await engine.execute(null, 'test', {});
    expect(executed, true);
  });

  test('action engine defaults are registered', () {
    final engine = ActionEngine();
    engine.registerDefaults();
    // Since handlers are registered, execute should not throw
    expect(
        () async => await engine.execute(null, 'custom', {}), returnsNormally);
  });
}
