import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/font_install_service.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';
import 'package:fontkeep_app/features/sync/domain/models/nearby_device.dart';
import 'package:fontkeep_app/features/sync/domain/providers/sync_providers.dart';
import 'package:loader_overlay/loader_overlay.dart';

class FontInspector extends ConsumerStatefulWidget {
  const FontInspector({super.key});

  @override
  ConsumerState<FontInspector> createState() => _FontInspectorState();
}

class _FontInspectorState extends ConsumerState<FontInspector> {
  @override
  Widget build(BuildContext context) {
    final logger = ref.watch(loggerProvider);
    final selectedFont = ref.watch(selectedFontProvider);
    final installService = FontInstallService();
    bool isInstalling = false;

    if (selectedFont == null) {
      return Container(
        width: 300,
        color: Theme.of(context).colorScheme.surface,
        child: const Center(child: Text("Select a font to view details")),
      );
    }

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedFont.familyName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  selectedFont.subFamily,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 2,
            child: FutureBuilder(
              future: loadFontIntoFlutter(selectedFont, logger),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Preview unavailable\n${snapshot.error}"),
                  );
                }
                return Container(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Aa",
                          style: TextStyle(
                            fontFamily: selectedFont.id,
                            fontSize: 80,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "The quick brown fox jumps over the lazy dog.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: selectedFont.id,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            flex: 3,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMetaItem(
                  context,
                  "File Size",
                  "${(selectedFont.fileSize / 1024).toStringAsFixed(1)} KB",
                ),
                _buildMetaItem(
                  context,
                  "Format",
                  selectedFont.filePath.split('.').last.toUpperCase(),
                ),
                _buildMetaItem(context, "Path", selectedFont.filePath),
                _buildMetaItem(
                  context,
                  "Sync Status",
                  selectedFont.isSynced ? "Synced via Drive" : "Local Only",
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () async {
                    try {
                      await ref
                          .read(fontRepositoryProvider)
                          .shareFont(selectedFont);
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Share File"),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () =>
                      _showDevicePicker(context, ref, selectedFont),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.send_to_mobile),
                  label: const Text("Send to Device"),
                ),
                const SizedBox(height: 10),
                if (!selectedFont.isSystem)
                  FilledButton.icon(
                    onPressed: () async {
                      context.loaderOverlay.show();
                      try {
                        setState(() => isInstalling = true);

                        bool success = await installService.install(
                          logger,
                          selectedFont.filePath,
                        );

                        if (mounted) {
                          setState(() => isInstalling = false);

                          if (success) {
                            final updatedFont = selectedFont.copyWith(
                              isSystem: true,
                            );
                            await ref
                                .read(libraryControllerProvider.notifier)
                                .updateFontStatus(logger, updatedFont);
                            ref.read(selectedFontProvider.notifier).state =
                                updatedFont;
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "✅ Font installed successfully!",
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "⚠️ Silent install failed. Opening system installer...",
                                  ),
                                ),
                              );
                            }
                            installService.openNativeViewer(
                              logger,
                              selectedFont.filePath,
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      }
                      if (context.mounted) {
                        context.loaderOverlay.hide();
                      }
                    },
                    style: FilledButton.styleFrom(backgroundColor: Colors.teal),
                    icon: const Icon(Icons.system_update),
                    label: const Text("Install to System"),
                  ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () =>
                      _showDeleteDialog(context, ref, selectedFont),
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.errorContainer,
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Font font) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Font"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to remove '${font.familyName}'?"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: font.isSystem
                    ? Colors.amber.withOpacity(0.2)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: font.isSystem ? Colors.amber : Colors.red,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    font.isSystem ? Icons.info : Icons.warning,
                    color: font.isSystem ? Colors.amber[800] : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      font.isSystem
                          ? "This is a System Font. It will be removed from your FontKeep library, but the actual file in Windows/Fonts will NOT be deleted."
                          : "This is a User Font. The file will be PERMANENTLY DELETED from your disk.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(libraryControllerProvider.notifier).deleteFont(font);
              ref.read(selectedFontProvider.notifier).state = null;
              Navigator.pop(ctx);
            },
            child: const Text("Confirm Delete"),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  void _showDevicePicker(BuildContext context, WidgetRef ref, Font font) {
    showDialog(
      context: context,
      builder: (ctx) => DevicePickerDialog(font: font),
    );
  }
}

class DevicePickerDialog extends ConsumerStatefulWidget {
  final Font font;

  const DevicePickerDialog({super.key, required this.font});

  @override
  ConsumerState<DevicePickerDialog> createState() => _DevicePickerDialogState();
}

class _DevicePickerDialogState extends ConsumerState<DevicePickerDialog> {
  bool _didAutoStart = false;
  late final SyncController _syncController;

  @override
  void initState() {
    super.initState();
    _syncController = ref.read(syncControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isScanning = ref.read(syncControllerProvider);
      if (!isScanning) {
        _syncController.toggleScan();
        _didAutoStart = true;
      }
    });
  }

  @override
  void dispose() {
    if (_didAutoStart) {
      _syncController.stopDiscovery();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(nearbyDevicesProvider);

    return AlertDialog(
      title: const Text("Select Device"),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: devicesAsync.when(
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Scanning for devices..."),
              ],
            ),
          ),
          error: (err, _) => Center(child: Text("Error: $err")),
          data: (devices) {
            if (devices.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.radar, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("Looking for devices nearby..."),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: devices.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final device = devices[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.computer)),
                  title: Text(device.name),
                  subtitle: Text(device.ip),
                  trailing: const Icon(Icons.send, color: Colors.indigo),
                  onTap: () {
                    Navigator.pop(context);
                    _sendFile(context, ref, device, widget.font);
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
      ],
    );
  }

  Future<void> _sendFile(
    BuildContext context,
    WidgetRef ref,
    NearbyDevice device,
    Font font,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Text("Sending '${font.familyName}' to ${device.name}..."),
          ],
        ),
        duration: const Duration(minutes: 1),
      ),
    );

    try {
      await ref
          .read(transferRepositoryProvider)
          .sendFontToDevice(device.ip, font);
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Sent to ${device.name}"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }
}
