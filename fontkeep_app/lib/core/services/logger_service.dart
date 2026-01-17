import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'crash_reporting_service.dart';

final loggerProvider = Provider(
  (ref) => LoggerService(CrashReportingService()),
);

final userNotificationProvider = StreamProvider<UserMessage>((ref) {
  return ref.watch(loggerProvider).messageStream;
});

class UserMessage {
  final String message;
  final MessageType type;

  UserMessage(this.message, this.type);
}

enum MessageType { error, success, info }

class LoggerService {
  final CrashReportingService _crashReporter;
  final _messageController = StreamController<UserMessage>.broadcast();

  LoggerService(this._crashReporter);

  Stream<UserMessage> get messageStream => _messageController.stream;

  void info(String message) {
    if (kDebugMode) {
      print("ℹ️ [INFO] $message");
    }
  }

  void error(
    dynamic exception, {
    StackTrace? stack,
    String category = 'general',
    String? userFriendlyMessage,
  }) {
    if (kDebugMode) {
      print("🔴 [ERROR] $exception");
      if (stack != null) print(stack);
    }

    _crashReporter.reportError(exception, stack, category: category);

    if (userFriendlyMessage != null) {
      _messageController.add(
        UserMessage(userFriendlyMessage, MessageType.error),
      );
    }
  }

  void userSuccess(String message) {
    _messageController.add(UserMessage(message, MessageType.success));
  }
}
