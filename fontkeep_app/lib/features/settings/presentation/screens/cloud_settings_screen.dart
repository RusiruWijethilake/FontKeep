import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/features/settings/domain/providers/auth_provider.dart';
import 'package:fontkeep_app/features/sync/presentation/widgets/cloud_setup_help_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CloudSettingsScreen extends ConsumerStatefulWidget {
  const CloudSettingsScreen({super.key});

  @override
  ConsumerState<CloudSettingsScreen> createState() =>
      _CloudSettingsScreenState();
}

class _CloudSettingsScreenState extends ConsumerState<CloudSettingsScreen> {
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

    return Scaffold(
      appBar: AppBar(title: const Text("Cloud Sync (Google Drive)")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 1. INTRO CARD
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.cloud_sync,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        "Backup to Google Drive",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Sync your fonts to a private folder in your Google Drive. \n"
                    "Authentication is optional and uses your own credentials.",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          ListTile(
            title: const Text("Sync Status"),
            subtitle: Text(
              config.isEnabled ? "Active" : "Disabled (Offline Mode)",
            ),
            trailing: Switch(
              value: config.isEnabled,
              onChanged: (val) async {
                context.loaderOverlay.show();
                if (val) {
                  try {
                    await ref.read(syncConfigProvider.notifier).signIn();
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Login Failed: $e")),
                      );
                    }
                  }
                } else {
                  await ref.read(syncConfigProvider.notifier).signOut();
                }
                if (context.mounted) context.loaderOverlay.hide();
              },
            ),
          ),
          const Divider(),

          ExpansionTile(
            title: const Text("API Configuration"),
            subtitle: const Text("Use your own Google Cloud Client ID"),
            initiallyExpanded: !config.isEnabled,
            children: [
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: "Client ID",
                        hintText: "12345...apps.googleusercontent.com",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _secretController,
                      decoration: const InputDecoration(
                        labelText: "Client Secret",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.tonal(
                        onPressed: () {
                          ref
                              .read(syncConfigProvider.notifier)
                              .saveKeys(
                                _idController.text.trim(),
                                _secretController.text.trim(),
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Credentials Saved")),
                          );
                        },
                        child: const Text("Save Keys"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Note: You need to create a project in Google Cloud Console, enable Drive API, and create 'Desktop' credentials.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
