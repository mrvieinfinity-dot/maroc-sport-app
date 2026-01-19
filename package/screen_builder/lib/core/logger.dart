import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Centralized lightweight logger for the screen_builder package
class SBLogger {
  static void info(String msg) {
    debugPrint('[screen_builder][INFO] $msg');
  }

  static void warn(String msg) {
    debugPrint('[screen_builder][WARN] $msg');
  }

  static void error(String msg, [dynamic error, StackTrace? stack]) {
    debugPrint('[screen_builder][ERROR] $msg');
    if (error != null) debugPrint('[screen_builder][ERROR_DETAIL] $error');
    if (stack != null) debugPrint(stack.toString());
    // Report to Flutter error handlers so devs see it in error consoles
    FlutterError.reportError(FlutterErrorDetails(
      exception: Exception(msg),
      stack: stack,
      library: 'screen_builder',
      context: ErrorDescription(msg),
    ));
  }

  static Never throwError(String msg, [dynamic error, StackTrace? stack]) {
    error(msg, error, stack);
    throw FlutterError(msg);
  }
}
