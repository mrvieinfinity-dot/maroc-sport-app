// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:screen_builder/components/builders/text_builder.dart';
// import 'package:screen_builder/components/props/component_specs.dart';

// void main() {
//   group('TextBuilder', () {
//     test('buildSpec creates TextSpec with correct content', () {
//       final builder = TextBuilder();
//       final props = {'text': 'Hello World'};

//       final spec = builder.buildSpec(props);

//       expect(spec, isA<TextSpec>());
//       expect((spec as TextSpec).content, 'Hello World');
//       expect(spec.props, props);
//     });

//     test('buildSpec handles style key', () {
//       final builder = TextBuilder();
//       final props = {'text': 'Styled Text', 'style': 'headline'};

//       final spec = builder.buildSpec(props);

//       expect(spec, isA<TextSpec>());
//       expect((spec as TextSpec).styleKey, 'headline');
//     });

//     test('buildSpec handles text alignment', () {
//       final builder = TextBuilder();
//       final props = {'text': 'Centered Text', 'textAlign': 'center'};

//       final spec = builder.buildSpec(props);

//       expect(spec, isA<TextSpec>());
//       expect((spec as TextSpec).textAlign, TextAlign.center);
//     });
//   });
// }
