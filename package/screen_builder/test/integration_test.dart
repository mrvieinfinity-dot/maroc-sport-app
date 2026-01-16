// import 'package:flutter_test/flutter_test.dart';
// import 'package:screen_builder/screen_builder.dart';
// import 'dart:convert';

// void main() {
//   test('integration test: JSON to Widget', () async {
//     // Initialize
//     await initScreenBuilder();

//     // Load sample JSON
//     const jsonString = '''
//     {
//       "component": "column",
//       "children": [
//         {"component": "text", "props": {"text": "Hello World"}},
//         {"component": "button", "props": {"text": "Click me", "onTap": "custom"}}
//       ]
//     }
//     ''';
//     final json = jsonDecode(jsonString) as Map<String, dynamic>;
//     final components = [json];

//     // Create PageModel
//     final page = PageModel(id: 'test', components: components);

//     // Build page
//     final pageEngine = PageEngine();
//     final widget = pageEngine.buildPage(page);

//     // Assert it's a Column
//     expect(widget, isA<Column>());
//     final column = widget as Column;
//     expect(column.children.length, 2);
//   });
// }
