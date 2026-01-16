// import 'package:flutter_test/flutter_test.dart';
// import '../packages/screen_builder/components/components_props.dart';

// void main() {
//   group('ComponentProps Unit Tests - No Flutter Widgets', () {
//     group('ColumnProps', () {
//       test('fromJson creates ColumnProps with default values', () {
//         final json = {};
//         final props = ColumnProps.fromJson(json);

//         expect(props.mainAxisAlignment.toString(), 'MainAxisAlignment.start');
//         expect(props.crossAxisAlignment.toString(), 'CrossAxisAlignment.center');
//       });

//       test('fromJson creates ColumnProps with custom values', () {
//         final json = {'mainAxisAlignment': 'spaceAround', 'crossAxisAlignment': 'start'};
//         final props = ColumnProps.fromJson(json);

//         expect(props.mainAxisAlignment.toString().contains('spaceAround'), true);
//       });

//       test('toJson converts ColumnProps correctly', () {
//         final props = ColumnProps(mainAxisAlignment: MainAxisAlignment.center);
//         final json = props.toJson();

//         expect(json['mainAxisAlignment'], isNotNull);
//         expect(json['crossAxisAlignment'], isNotNull);
//       });
//     });

//     group('TextProps', () {
//       test('fromJson creates TextProps with all fields', () {
//         final json = {'text': 'Hello', 'style': 'heading1', 'color': 'darkCharcoal', 'fontSize': 24.0, 'fontWeight': 'bold'};

//         final props = TextProps.fromJson(json);

//         expect(props.text, 'Hello');
//         expect(props.style, 'heading1');
//         expect(props.color, 'darkCharcoal');
//         expect(props.fontSize, 24.0);
//         expect(props.fontWeight, 'bold');
//       });

//       test('fromJson handles missing optional fields', () {
//         final json = {'text': 'World'};
//         final props = TextProps.fromJson(json);

//         expect(props.text, 'World');
//         expect(props.style, isNull);
//         expect(props.color, isNull);
//       });

//       test('toJson preserves all TextProps data', () {
//         final original = TextProps(text: 'Test', style: 'body', color: 'white', fontSize: 16.0);

//         final json = original.toJson();
//         final restored = TextProps.fromJson(json);

//         expect(restored.text, original.text);
//         expect(restored.style, original.style);
//         expect(restored.color, original.color);
//         expect(restored.fontSize, original.fontSize);
//       });
//     });

//     group('PreloadedButtonProps', () {
//       test('fromJson creates complete PreloadedButtonProps', () {
//         final json = {
//           'label': 'Click Me',
//           'bgImagePath': 'assets/image.jpg',
//           'bgColorKey': 'purplePrimary',
//           'height': 100.0,
//           'onTapActionId': 'navigate_home',
//         };

//         final props = PreloadedButtonProps.fromJson(json);

//         expect(props.label, 'Click Me');
//         expect(props.bgImagePath, 'assets/image.jpg');
//         expect(props.bgColorKey, 'purplePrimary');
//         expect(props.height, 100.0);
//         expect(props.onTapActionId, 'navigate_home');
//       });

//       test('fromJson handles missing optional fields', () {
//         final json = {'label': 'Button'};
//         final props = PreloadedButtonProps.fromJson(json);

//         expect(props.label, 'Button');
//         expect(props.bgImagePath, isNull);
//         expect(props.bgColorKey, isNull);
//         expect(props.height, 80); // default
//       });

//       test('toJson and fromJson roundtrip works', () {
//         final original = PreloadedButtonProps(label: 'Test Button', bgColorKey: 'blue', height: 90, onTapActionId: 'action_test');

//         final json = original.toJson();
//         final restored = PreloadedButtonProps.fromJson(json);

//         expect(restored.label, original.label);
//         expect(restored.bgColorKey, original.bgColorKey);
//         expect(restored.height, original.height);
//         expect(restored.onTapActionId, original.onTapActionId);
//       });
//     });

//     group('BrandHeaderProps', () {
//       test('fromJson creates BrandHeaderProps with defaults', () {
//         final json = {'title': 'Maroc Sport'};
//         final props = BrandHeaderProps.fromJson(json);

//         expect(props.title, 'Maroc Sport');
//         expect(props.logoSize, 60);
//         expect(props.spacing, 18);
//         expect(props.titleStyleKey, 'heading1');
//       });

//       test('fromJson overrides defaults', () {
//         final json = {'title': 'Custom Title', 'logoSize': 100, 'spacing': 30, 'titleStyleKey': 'heading2'};
//         final props = BrandHeaderProps.fromJson(json);

//         expect(props.title, 'Custom Title');
//         expect(props.logoSize, 100);
//         expect(props.spacing, 30);
//         expect(props.titleStyleKey, 'heading2');
//       });

//       test('toJson preserves BrandHeaderProps', () {
//         final original = BrandHeaderProps(title: 'Test', logoSize: 80, spacing: 20);

//         final json = original.toJson();
//         final restored = BrandHeaderProps.fromJson(json);

//         expect(restored.title, original.title);
//         expect(restored.logoSize, original.logoSize);
//         expect(restored.spacing, original.spacing);
//       });
//     });

//     group('PubliciteBannerProps', () {
//       test('fromJson creates PubliciteBannerProps', () {
//         final json = {'title': 'Promo', 'targetUrl': 'https://example.com', 'height': 150, 'borderRadius': 20};

//         final props = PubliciteBannerProps.fromJson(json);

//         expect(props.title, 'Promo');
//         expect(props.targetUrl, 'https://example.com');
//         expect(props.height, 150);
//         expect(props.borderRadius, 20);
//       });

//       test('fromJson uses default borderRadius', () {
//         final json = {'title': 'Banner', 'targetUrl': 'https://test.com'};

//         final props = PubliciteBannerProps.fromJson(json);
//         expect(props.borderRadius, 15); // default
//       });
//     });

//     group('AppLogoProps', () {
//       test('fromJson creates AppLogoProps with default size', () {
//         final json = {};
//         final props = AppLogoProps.fromJson(json);

//         expect(props.size, 80); // default
//       });

//       test('fromJson overrides default size', () {
//         final json = {'size': 120};
//         final props = AppLogoProps.fromJson(json);

//         expect(props.size, 120);
//       });
//     });

//     group('SpacerProps', () {
//       test('fromJson creates SpacerProps with height', () {
//         final json = {'height': 20.0};
//         final props = SpacerProps.fromJson(json);

//         expect(props.height, 20.0);
//         expect(props.width, isNull);
//       });

//       test('fromJson creates SpacerProps with width', () {
//         final json = {'width': 15.0};
//         final props = SpacerProps.fromJson(json);

//         expect(props.height, isNull);
//         expect(props.width, 15.0);
//       });

//       test('toJson preserves both dimensions', () {
//         final original = SpacerProps(height: 25.0, width: 10.0);
//         final json = original.toJson();
//         final restored = SpacerProps.fromJson(json);

//         expect(restored.height, 25.0);
//         expect(restored.width, 10.0);
//       });
//     });

//     group('ImageProps', () {
//       test('fromJson creates ImageProps for asset', () {
//         final json = {'source': 'assets/logo.png', 'isAsset': true, 'width': 200, 'height': 200, 'fit': 'cover'};

//         final props = ImageProps.fromJson(json);

//         expect(props.source, 'assets/logo.png');
//         expect(props.isAsset, true);
//         expect(props.width, 200);
//         expect(props.height, 200);
//       });

//       test('fromJson creates ImageProps for network', () {
//         final json = {'source': 'https://example.com/image.jpg', 'isAsset': false, 'width': 300, 'height': 300};

//         final props = ImageProps.fromJson(json);

//         expect(props.source, 'https://example.com/image.jpg');
//         expect(props.isAsset, false);
//       });

//       test('toJson preserves all ImageProps', () {
//         final original = ImageProps(source: 'test.png', isAsset: true, width: 100, height: 100);

//         final json = original.toJson();
//         final restored = ImageProps.fromJson(json);

//         expect(restored.source, original.source);
//         expect(restored.isAsset, original.isAsset);
//         expect(restored.width, original.width);
//         expect(restored.height, original.height);
//       });
//     });
//   });
// }
