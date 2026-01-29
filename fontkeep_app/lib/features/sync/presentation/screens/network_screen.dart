import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/features/settings/domain/providers/auth_provider.dart';
import 'package:fontkeep_app/features/sync/domain/providers/drive_providers.dart';
import 'package:fontkeep_app/features/sync/domain/providers/sync_providers.dart';
import 'package:fontkeep_app/features/sync/presentation/widgets/cloud_setup_help_dialog.dart';

class NetworkScreen extends ConsumerWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sync Center'),
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.wifi), text: "Local Network"),
              Tab(icon: Icon(Icons.cloud_upload), text: "Google Drive"),
            ],
          ),
        ),
        body: const TabBarView(children: [_LocalSyncTab(), _CloudSyncTab()]),
      ),
    );
  }
}

class _LocalSyncTab extends ConsumerWidget {
  const _LocalSyncTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScanning = ref.watch(syncControllerProvider);
    final devicesAsync = ref.watch(nearbyDevicesProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  isScanning ? Icons.radar : Icons.radar_outlined,
                  size: 40,
                  color: isScanning ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isScanning ? "Broadcasting..." : "Discovery Idle",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Text("Sync directly with devices on your Wi-Fi."),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () =>
                      ref.read(syncControllerProvider.notifier).toggleScan(),
                  child: Text(isScanning ? "Stop" : "Start"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: devicesAsync.when(
              loading: () =>
                  const Center(child: Text("Waiting for scanner...")),
              error: (err, st) => Center(child: Text("Error: $err")),
              data: (devices) {
                if (!isScanning) {
                  return const Center(
                    child: Text("Start discovery to see devices."),
                  );
                }
                if (devices.isEmpty) {
                  return const Center(child: Text("No devices found nearby."));
                }
                return ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return ListTile(
                      leading: Icon(_getIconForOS(device.os), size: 32),
                      title: Text(device.name),
                      subtitle: Text(
                        "${device.ip} • ${device.os.toUpperCase()}",
                      ),
                      trailing: FilledButton.icon(
                        onPressed: () {
                          _startSync(context, ref, device.ip, device.name);
                        },
                        icon: const Icon(Icons.sync),
                        label: const Text("Sync"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _startSync(
    BuildContext context,
    WidgetRef ref,
    String ip,
    String deviceName,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Syncing with $deviceName"),
          content: StreamBuilder<double>(
            stream: ref.read(transferRepositoryProvider).syncWithDevice(ip),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 40),
                    const SizedBox(height: 10),
                    Text("Error: ${snapshot.error}"),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Close"),
                    ),
                  ],
                );
              }

              final progress = snapshot.data ?? 0.0;

              if (progress >= 1.0) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (ctx.mounted) Navigator.pop(ctx);
                });
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    SizedBox(height: 16),
                    Text("Sync Complete!"),
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 16),
                  Text("${(progress * 100).toInt()}% complete"),
                ],
              );
            },
          ),
        );
      },
    );
  }

  IconData _getIconForOS(String os) {
    if (os.contains('win')) return Icons.window;
    if (os.contains('mac')) return Icons.laptop_mac;
    if (os.contains('linux')) return Icons.terminal;
    return Icons.computer;
  }
}

class _CloudSyncTab extends ConsumerStatefulWidget {
  const _CloudSyncTab();

  @override
  ConsumerState<_CloudSyncTab> createState() => _CloudSyncTabState();
}

class _CloudSyncTabState extends ConsumerState<_CloudSyncTab> {
  final _idController = TextEditingController();
  final _secretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final config = ref.read(syncConfigProvider);
    _idController.text = config.clientId ?? '';
    _secretController.text = config.clientSecret ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(syncConfigProvider);

    if (!config.isEnabled) {
      return ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Center(child: Text("Not Connected to Google Drive")),
          const SizedBox(height: 32),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "1. Configuration (BYOK)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.help_outline, size: 16),
                        label: const Text("How do I get these?"),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const CloudSetupHelpDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Enter your Google Cloud credentials to enable sync.",
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: "Client ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _secretController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Client Secret",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () {
                      ref
                          .read(syncConfigProvider.notifier)
                          .saveKeys(
                            _idController.text.trim(),
                            _secretController.text.trim(),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Keys Saved!")),
                      );
                    },
                    child: const Text("Save Keys"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.login),
            label: const Text("2. Sign In with Google"),
            onPressed: () async {
              try {
                await ref.read(syncConfigProvider.notifier).signIn();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Error: $e")));
                }
              }
            },
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.cloud_done, color: Colors.blue, size: 40),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cloud Sync Active",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Ready to backup or restore."),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: "Sign Out",
                  onPressed: () =>
                      ref.read(syncConfigProvider.notifier).signOut(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SyncActionButton(
                icon: Icons.backup,
                label: "Backup Library",
                color: Colors.indigo,
                onPressed: () => _runDriveTask(context, ref, "backup"),
              ),
              _SyncActionButton(
                icon: Icons.download,
                label: "Restore Backup",
                color: Colors.teal,
                onPressed: () => _runDriveTask(context, ref, "restore"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _runDriveTask(BuildContext context, WidgetRef ref, String task) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          content: StreamBuilder<String>(
            stream: task == "backup"
                ? ref.read(driveRepositoryProvider).backupLibrary()
                : ref.read(driveRepositoryProvider).restoreLibrary(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 40),
                    Text("Error: ${snapshot.error}"),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Close"),
                    ),
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Future.delayed(
                  const Duration(seconds: 1),
                  () => Navigator.pop(ctx),
                );
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 40),
                    Text("Done!"),
                  ],
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(snapshot.data ?? "Starting..."),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _SyncActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _SyncActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
