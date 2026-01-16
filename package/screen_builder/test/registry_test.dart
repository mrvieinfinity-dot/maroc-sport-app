import 'package:flutter_test/flutter_test.dart';
import 'package:screen_builder/screen_builder.dart';

void main() {
  setUp(() async {
    await initScreenBuilder();
  });

  test('registry registers and retrieves components', () {
    final registry = ComponentRegistry();
    expect(registry.get('text'), isNotNull);
    expect(registry.get('nonexistent'), isNull);
  });

  test('default components are registered', () {
    expect(ComponentRegistry().get('button'), isNotNull);
    expect(ComponentRegistry().get('column'), isNotNull);
  });
}
