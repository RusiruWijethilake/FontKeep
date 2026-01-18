import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/core/services/update_service.dart';
import 'package:go_router/go_router.dart';

class MainShell extends ConsumerStatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  @override
  void initState() {
    super.initState();
    UpdateService().check(context, silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;
    if (location.startsWith('/sync')) currentIndex = 1;
    if (location.startsWith('/settings')) currentIndex = 2;

    ref.listen<AsyncValue<UserMessage>>(userNotificationProvider, (
      previous,
      next,
    ) {
      next.whenData((msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg.message),
            backgroundColor: msg.type == MessageType.error
                ? Colors.redAccent
                : (msg.type == MessageType.success
                      ? Colors.green
                      : Colors.blue),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    });

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/library');
                  break;
                case 1:
                  context.go('/sync');
                  break;
                case 2:
                  context.go('/settings');
                  break;
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.font_download_outlined),
                selectedIcon: Icon(Icons.font_download),
                label: Text('Library'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sync_outlined),
                selectedIcon: Icon(Icons.sync),
                label: Text('Sync'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
