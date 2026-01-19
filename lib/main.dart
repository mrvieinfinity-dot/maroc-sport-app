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
    config: ScreenConfig(
      env: 'local', // 'local', 'staging', 'prod'
      essentialBuilder: {
      jsonPath: 'assets/pages/',
       homePage: 'home',
      navigationFile: 'assets/pages/navigation.json',
      }
      handleManage: {
      eventHandlers: [/* custom event handlers */],
        
      }
      
      // apiAdapter: MyApiService(), // Optional custom API service
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
