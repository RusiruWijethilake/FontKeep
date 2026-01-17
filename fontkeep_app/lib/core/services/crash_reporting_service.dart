import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class CrashReportingService {
  static const String _licenseKey = String.fromEnvironment('NEW_RELIC_KEY');
  static const String _endpoint = 'https://log-api.eu.newrelic.com/log/v1';

  Future<void> reportError(
    dynamic exception,
    StackTrace? stack, {
    String category = 'general',
  }) async {
    if (_licenseKey.isEmpty || kDebugMode) return;
    if (kDebugMode) return;

    try {
      final payload = await _buildPayload(exception, stack, category);

      await http.post(
        Uri.parse(_endpoint),
        headers: {'Content-Type': 'application/json', 'Api-Key': _licenseKey},
        body: jsonEncode(payload),
      );
    } catch (e) {
      stderr.writeln("Failed to send error to New Relic: $e");
    }
  }

  Future<Map<String, dynamic>> _buildPayload(
    dynamic exception,
    StackTrace? stack,
    String category,
  ) async {
    String os = Platform.operatingSystem;
    String osVersion = Platform.operatingSystemVersion;
    final pkg = await PackageInfo.fromPlatform();

    String message = exception.toString();
    if (message.contains(Platform.pathSeparator)) {
      message = _sanitizePaths(message);
    }

    return {
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "message": message,
      "logtype": "exception",
      "service": "fontkeep_desktop",
      "attributes": {
        "category": category,
        "os": os,
        "os_version": osVersion,
        "app_version": pkg.version,
        "build_number": pkg.buildNumber,
        "stack_trace": stack.toString(),
      },
    };
  }

  String _sanitizePaths(String input) {
    final windowsPath = RegExp(r'[a-zA-Z]:\\[\\\S|*\S]?.*');
    final unixPath = RegExp(r'/home/[^/]+');

    var output = input.replaceAll(windowsPath, '[PATH_REDACTED]');
    output = output.replaceAll(unixPath, '[PATH_REDACTED]');
    return output;
  }
}
