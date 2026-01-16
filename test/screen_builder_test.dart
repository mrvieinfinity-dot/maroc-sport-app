// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import '../packages/screen_builder/components/components_props.dart';
// import '../package/screen_builder/components/components_builder.dart';
// import '../packages/screen_builder/navigation/navigation_handler.dart';
// import 'package:maroc_sport/constants/colors_design.dart';
// import 'package:maroc_sport/constants/spacing_design.dart';

// void main() {
//   group('Screen Builder Tests', () {
//     group('ComponentBuilder', () {
//       test('buildColumn creates Column with correct properties', () {
//         final props = ColumnProps(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center);

//         final widget = ComponentBuilder.buildColumn(props, []);

//         expect(widget, isA<Column>());
//         final column = widget as Column;
//         expect(column.mainAxisAlignment, MainAxisAlignment.center);
//         expect(column.crossAxisAlignment, CrossAxisAlignment.center);
//       });

//       test('buildRow creates Row with correct properties', () {
//         final props = RowProps(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start);

//         final widget = ComponentBuilder.buildRow(props, []);

//         expect(widget, isA<Row>());
//         final row = widget as Row;
//         expect(row.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
//         expect(row.crossAxisAlignment, CrossAxisAlignment.start);
//       });

//       test('buildSpacer creates SizedBox with height', () {
//         final props = SpacerProps(height: 20.0);
//         final widget = ComponentBuilder.buildSpacer(props);

//         expect(widget, isA<SizedBox>());
//         final sizedBox = widget as SizedBox;
//         expect(sizedBox.height, 20.0);
//       });

//       test('buildText creates Text with correct style', () {
//         final props = TextProps(text: 'Hello', style: 'heading1', color: 'darkCharcoal');

//         final widget = ComponentBuilder.buildText(props);

//         expect(widget, isA<Text>());
//       });

//       test('buildImage creates Image from asset', () {
//         final props = ImageProps(source: 'assets/logo.png', isAsset: true, width: 100, height: 100);

//         final widget = ComponentBuilder.buildImage(props);
//         expect(widget, isA<Image>());
//       });

//       test('buildPreloadedButton creates _PreloadedButtonBuilder', () {
//         final props = PreloadedButtonProps(label: 'Test Button', height: 80, onTapActionId: 'navigate_home');

//         final widget = ComponentBuilder.buildPreloadedButton(props);
//         expect(widget, isA<StatelessWidget>());
//       });
//     });

//     group('ComponentProps fromJson/toJson', () {
//       test('ColumnProps fromJson works correctly', () {
//         final json = {'mainAxisAlignment': 'center', 'crossAxisAlignment': 'center'};

//         final props = ColumnProps.fromJson(json);

//         expect(props.mainAxisAlignment, MainAxisAlignment.center);
//         expect(props.crossAxisAlignment, CrossAxisAlignment.center);
//       });

//       test('TextProps fromJson works correctly', () {
//         final json = {'text': 'Hello World', 'style': 'heading1', 'color': 'darkCharcoal'};

//         final props = TextProps.fromJson(json);

//         expect(props.text, 'Hello World');
//         expect(props.style, 'heading1');
//         expect(props.color, 'darkCharcoal');
//       });

//       test('PreloadedButtonProps fromJson works correctly', () {
//         final json = {'label': 'Click me', 'height': 80, 'onTapActionId': 'navigate_clubs_page'};

//         final props = PreloadedButtonProps.fromJson(json);

//         expect(props.label, 'Click me');
//         expect(props.height, 80);
//         expect(props.onTapActionId, 'navigate_clubs_page');
//       });

//       test('BrandHeaderProps fromJson works correctly', () {
//         final json = {'title': 'Maroc Sport', 'logoSize': 60, 'spacing': 18};

//         final props = BrandHeaderProps.fromJson(json);

//         expect(props.title, 'Maroc Sport');
//         expect(props.logoSize, 60);
//         expect(props.spacing, 18);
//       });
//     });

//     group('Design System', () {
//       test('AppColors has required color keys', () {
//         expect(AppColors.getColor('white'), Colors.white);
//         expect(AppColors.getColor('darkCharcoal'), const Color.fromARGB(255, 8, 8, 9));
//         expect(AppColors.getColor('purplePrimary'), const Color(0xFF6A6EEE));
//       });

//       test('AppColors returns fallback for unknown key', () {
//         final color = AppColors.getColor('unknown_color', fallback: Colors.grey);
//         expect(color, Colors.grey);
//       });

//       test('AppSpacing has required spacing values', () {
//         expect(AppSpacing.getSpacing('sm'), 8.0);
//         expect(AppSpacing.getSpacing('md'), 12.0);
//         expect(AppSpacing.getSpacing('lg'), 20.0);
//       });

//       test('AppSpacing returns fallback for unknown key', () {
//         expect(AppSpacing.getSpacing('unknown', fallback: 16.0), 16.0);
//       });
//     });

//     group('NavigationHandler', () {
//       testWidgets('NavigationHandler can be created from context', (WidgetTester tester) async {
//         await tester.pumpWidget(
//           MaterialApp(
//             home: Builder(
//               builder: (context) {
//                 final handler = NavigationHandler(context);
//                 expect(handler, isA<NavigationHandler>());
//                 expect(handler.context, context);
//                 return const Scaffold(body: SizedBox());
//               },
//             ),
//           ),
//         );
//       });

//       testWidgets('NavigationContext extension provides navigator', (WidgetTester tester) async {
//         await tester.pumpWidget(
//           MaterialApp(
//             home: Builder(
//               builder: (context) {
//                 final navigator = context.navigator;
//                 expect(navigator, isA<NavigationHandler>());
//                 return const Scaffold(body: SizedBox());
//               },
//             ),
//           ),
//         );
//       });
//     });

//     group('Widget Integration', () {
//       testWidgets('PreloadedButton with color renders correctly', (WidgetTester tester) async {
//         final props = PreloadedButtonProps(label: 'Test', bgColorKey: 'purplePrimary', height: 80);

//         await tester.pumpWidget(MaterialApp(home: Scaffold(body: ComponentBuilder.buildPreloadedButton(props))));

//         expect(find.byType(InkWell), findsOneWidget);
//         expect(find.byType(Container), findsOneWidget);
//         expect(find.byType(Text), findsOneWidget);
//       });

//       testWidgets('AppLogo renders with correct size', (WidgetTester tester) async {
//         final props = AppLogoProps(size: 100);

//         await tester.pumpWidget(MaterialApp(home: Scaffold(body: ComponentBuilder.buildAppLogo(props))));

//         expect(find.byType(Image), findsOneWidget);
//         expect(find.byType(ClipRRect), findsOneWidget);
//       });

//       testWidgets('BrandHeader renders with title and logo', (WidgetTester tester) async {
//         final props = BrandHeaderProps(title: 'Maroc Sport', logoSize: 60, spacing: 18);

//         await tester.pumpWidget(MaterialApp(home: Scaffold(body: ComponentBuilder.buildBrandHeader(props))));

//         expect(find.byType(Row), findsOneWidget);
//         expect(find.byType(Text), findsOneWidget);
//         expect(find.byType(Image), findsOneWidget);
//       });
//     });
//   });
// }
