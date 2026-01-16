import 'package:flutter/material.dart';
import '../../../services/api/api_service.dart';
import '../../../models/api_response.dart';
import '../../../engine/events/event_bus.dart';
import '../../../models/event_model.dart';

/// Handler for HTTP actions
Future<void> httpHandler(
    BuildContext? context, Map<String, dynamic> params) async {
  final method = params['method'] ?? 'GET';
  final url = params['url'];
  if (url != null && ApiService.instance != null) {
    try {
      ApiResponse response;
      switch (method.toUpperCase()) {
        case 'GET':
          response =
              await ApiService.instance!.get(url, headers: params['headers']);
          break;
        case 'POST':
          response = await ApiService.instance!
              .post(url, headers: params['headers'], body: params['body']);
          break;
        // Add PUT, DELETE similarly
        default:
          throw UnsupportedError('Method $method not supported');
      }
      EventBus().publish(Event('api_success',
          payload: {'response': response, 'params': params}));
    } catch (e) {
      EventBus()
          .publish(Event('api_error', payload: {'error': e, 'params': params}));
    }
  }
}
