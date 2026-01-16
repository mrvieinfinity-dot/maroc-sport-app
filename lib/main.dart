import 'package:flutter/material.dart';
import 'package:screen_builder/screen_builder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure error logging
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FlutterError: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Initialize with tokens
  await initScreenBuilder(
    config: ScreenBuilderConfig(
      env: 'prod', // 'local', 'staging', 'prod'
      jsonPath: 'assets/pages/',
      homePage: 'home',
      navigationFile: 'assets/pages/navigation.json',
      // apiAdapter: MyApiService(), // Optional custom API service
      eventHandlers: [/* custom event handlers */],
    ),
  );
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ScreenBuilderPage());
  }
}
