import 'package:flutter/material.dart';
import '../../models/action_model.dart';
import 'handlers/navigate_handler.dart';
import 'handlers/http_handler.dart';
import 'handlers/custom_handler.dart';

/// Engine for handling actions
class ActionEngine {
  static final ActionEngine _instance = ActionEngine._internal();

  factory ActionEngine() => _instance;

  ActionEngine._internal();

  final Map<String, Future<void> Function(BuildContext?, Map<String, dynamic>)>
      _handlers = {};

  /// Registers an action handler
  void register(String type,
      Future<void> Function(BuildContext?, Map<String, dynamic>) handler) {
    _handlers[type] = handler;
  }

  /// Registers default action handlers
  void registerDefaults() {
    register('navigate', navigateHandler);
    register('http', httpHandler);
    register('custom', customHandler);
  }

  /// Executes an action
  Future<void> execute(BuildContext? context, dynamic action,
      Map<String, dynamic>? params) async {
    String type;
    Map<String, dynamic> actionParams = params ?? {};

    if (action is String) {
      if (action.contains(':')) {
        final parts = action.split(':');
        type = parts[0];
        actionParams = {'payload': parts[1]};
      } else {
        type = action;
      }
    } else if (action is ActionModel) {
      type = action.type;
      actionParams = action.params;
    } else if (action is Map<String, dynamic>) {
      type = action['type'];
      actionParams = action;
    } else {
      return;
    }

    final handler = _handlers[type];
    if (handler != null) {
      await handler(context, actionParams);
    }
  }
}
