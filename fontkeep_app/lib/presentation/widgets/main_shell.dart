import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/settings/data/repositories/update_repository.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
    });
  }

  Future<void> _checkForUpdates() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final logger = ref.read(loggerProvider);

    try {
      final repo = ref.read(updateRepositoryProvider);
      final update = await repo.checkForUpdate(logger);

      if (update != null && mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.new_releases, color: Colors.indigo),
                const SizedBox(width: 10),
                const Text("Update Available"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Version ${update.latestVersion} is available.",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("Release Notes:"),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: SingleChildScrollView(
                    child: Text(
                      update.releaseNotes,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Skip"),
              ),
              FilledButton.icon(
                icon: const Icon(Icons.download, size: 16),
                label: const Text("Download"),
                onPressed: () {
                  launchUrl(
                    Uri.parse(update.downloadUrl),
                    mode: LaunchMode.externalApplication,
                  );
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      }
    } catch (e) {
      logger.error(e);
    }
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
