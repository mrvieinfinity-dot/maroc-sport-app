// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:screen_builder/components/props/component_specs.dart';
// import 'package:screen_builder/engine/specs_renderer.dart';

// void main() {
//   group('SpecsRenderer', () {
//     late SpecsRenderer renderer;

//     setUp(() {
//       renderer = SpecsRenderer();
//     });

//     testWidgets('renders TextSpec correctly', (WidgetTester tester) async {
//       final spec = TextSpec(content: 'Hello World');

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Builder(
//             builder: (context) => renderer.render(context, spec),
//           ),
//         ),
//       );

//       expect(find.text('Hello World'), findsOneWidget);
//     });

//     testWidgets('renders ButtonSpec correctly', (WidgetTester tester) async {
//       final spec = ButtonSpec(text: 'Click Me');

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Builder(
//             builder: (context) => renderer.render(context, spec),
//           ),
//         ),
//       );

//       expect(find.byType(ElevatedButton), findsOneWidget);
//       expect(find.text('Click Me'), findsOneWidget);
//     });

//     testWidgets('renders ContainerSpec with children',
//         (WidgetTester tester) async {
//       final childSpec = TextSpec(content: 'Child');
//       final spec = ContainerSpec(children: [childSpec]);

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Builder(
//             builder: (context) => renderer.render(context, spec),
//           ),
//         ),
//       );

//       expect(find.text('Child'), findsOneWidget);
//     });
//   });
// }
