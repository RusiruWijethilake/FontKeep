import 'package:flutter/material.dart';
import 'package:fontkeep_app/features/library/presentation/screens/library_screen.dart';
import 'package:fontkeep_app/features/settings/presentation/screens/cloud_settings_screen.dart';
import 'package:fontkeep_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:fontkeep_app/features/sync/presentation/screens/network_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../widgets/main_shell.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/library',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(child: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sync',
                builder: (context, state) => const NetworkScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings/cloud',
                builder: (context, state) => const CloudSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
