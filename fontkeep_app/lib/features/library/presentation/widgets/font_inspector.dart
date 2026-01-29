import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/font_install_service.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/smart_delete_dialog.dart';
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
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SmartDeleteDialog(
                        fonts: [selectedFont],
                        onConfirm: () {
                          ref
                              .read(libraryControllerProvider.notifier)
                              .deleteFont(selectedFont);
                          ref.read(selectedFontProvider.notifier).state = null;
                        },
                      ),
                    );
                  },
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
      builder: (ctx) => DevicePickerDialog(fonts: [font]),
    );
  }
}

class DevicePickerDialog extends ConsumerStatefulWidget {
  final List<Font> fonts; // CHANGED: Now accepts a list

  const DevicePickerDialog({super.key, required this.fonts});

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
      title: Text(
        "Send ${widget.fonts.length} Font${widget.fonts.length > 1 ? 's' : ''}",
      ),
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
                    _sendFiles(context, ref, device, widget.fonts);
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

  Future<void> _sendFiles(
    BuildContext context,
    WidgetRef ref,
    NearbyDevice device,
    List<Font> fonts,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                fonts.length == 1
                    ? "Sending '${fonts.first.familyName}' to ${device.name}..."
                    : "Sending ${fonts.length} fonts to ${device.name}...",
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(minutes: 5),
      ),
    );

    int success = 0;
    int fail = 0;
    final repo = ref.read(transferRepositoryProvider);

    for (final font in fonts) {
      try {
        await repo.sendFontToDevice(device.ip, font);
        success++;
      } catch (e) {
        fail++;
      }
    }

    if (context.mounted) {
      messenger.hideCurrentSnackBar();

      if (fail == 0) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              "✅ Successfully sent ${fonts.length} font(s) to ${device.name}",
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              success == 0
                  ? "❌ Failed to send files to ${device.name}"
                  : "⚠️ Sent $success files, failed to send $fail files.",
            ),
            backgroundColor: success == 0 ? Colors.red : Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
