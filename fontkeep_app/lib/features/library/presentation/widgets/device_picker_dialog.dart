import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/sync/domain/models/nearby_device.dart';
import 'package:fontkeep_app/features/sync/domain/providers/sync_providers.dart';

class DevicePickerDialog extends ConsumerStatefulWidget {
  final List<Font> fonts;

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
