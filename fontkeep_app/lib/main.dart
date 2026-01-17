import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/crash_reporting_service.dart';
import 'package:fontkeep_app/features/settings/domain/providers/settings_providers.dart';

import 'presentation/router/app_router.dart';

void main() {
  final crashReporter = CrashReportingService();
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        crashReporter.reportError(
          details.exception,
          details.stack,
          category: 'ui_render',
        );
      };
      runApp(const ProviderScope(child: FontKeepApp()));
    },
    (error, stack) {
      crashReporter.reportError(error, stack, category: 'uncaught_async');
    },
  );
}

class FontKeepApp extends ConsumerWidget {
  const FontKeepApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);

    return MaterialApp.router(
      title: 'FontKeep',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accentColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
      ),
      routerConfig: router,
    );
  }
}
