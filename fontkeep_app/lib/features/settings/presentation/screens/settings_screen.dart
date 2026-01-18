import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/providers/app_info_provider.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/core/services/update_service.dart';
import 'package:fontkeep_app/features/settings/domain/providers/settings_providers.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final accentColor = ref.watch(accentColorProvider);
    final controller = ref.read(settingsControllerProvider);
    final logger = ref.watch(loggerProvider);

    final List<Color> colors = [
      Colors.teal,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.green,
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text("Settings", style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 24),

          _SectionHeader(title: "Application"),

          ListTile(
            title: const Text("Check for Updates"),
            subtitle: const Text("Check GitHub for the latest release"),
            leading: const Icon(Icons.update),
            onTap: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Checking for updates...")),
              );

              await UpdateService().check(context, silent: false);
            },
          ),

          const Divider(height: 40),

          _SectionHeader(title: "Appearance"),

          ListTile(
            title: const Text("Theme Mode"),
            subtitle: Text(themeMode.name.toUpperCase()),
            leading: Icon(_getThemeIcon(themeMode)),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto),
                  label: Text("Auto"),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode),
                  label: Text("Light"),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode),
                  label: Text("Dark"),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                ref.read(themeModeProvider.notifier).set(newSelection.first);
              },
            ),
          ),

          const SizedBox(height: 16),

          ListTile(
            title: const Text("Accent Color"),
            leading: const Icon(Icons.color_lens),
            subtitle: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  final color = colors[index];
                  final isSelected = accentColor.value == color.value;
                  return GestureDetector(
                    onTap: () =>
                        ref.read(accentColorProvider.notifier).set(color),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8, top: 8),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),

          const Divider(height: 40),

          _SectionHeader(title: "Data & Storage"),

          ListTile(
            title: const Text("Export Fonts"),
            subtitle: const Text(
              "Create a ZIP archive of all your non-system fonts.",
            ),
            leading: const Icon(Icons.archive),
            onTap: () async {
              context.loaderOverlay.show();
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Zipping fonts... please wait."),
                  ),
                );
                await controller.exportFontsAsZip();
              } catch (e) {
                context.loaderOverlay.hide();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Export failed: $e")));
              }
              context.loaderOverlay.hide();
            },
          ),

          ListTile(
            title: const Text("Cloud Settings"),
            subtitle: const Text("Manage Google Drive Backup"),
            leading: const Icon(Icons.cloud_circle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/cloud'),
          ),

          const Divider(height: 40),

          _SectionHeader(title: "Danger Zone", color: Colors.red),

          ListTile(
            title: const Text(
              "Reset Library",
              style: TextStyle(color: Colors.red),
            ),
            subtitle: const Text(
              "Deletes the database and resets the app. This cannot be undone.",
            ),
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Reset App?"),
                  content: const Text(
                    "This will delete your font library database. Your font files on disk will NOT be deleted, but FontKeep will lose track of them.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Cancel"),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => controller.deleteDatabase(),
                      child: const Text("Delete & Restart"),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 40),

          Center(
            child: Consumer(
              builder: (context, ref, _) {
                final versionAsync = ref.watch(appVersionProvider);

                return versionAsync.when(
                  data: (version) => Text(
                    "FontKeep v$version\nDesign and Developed by Community. Powered by Flutter.",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (error, stackTrace) => const Text("FontKeep"),
                );
              },
            ),
          ),

          Center(
            child: TextButton(
              onPressed: () {
                final versionAsync = ref.watch(appVersionProvider);

                versionAsync.when(
                  data: (data) {
                    context.loaderOverlay.hide();
                    showAboutDialog(
                      context: context,
                      applicationName: "FontKeep",
                      applicationVersion: data,
                      applicationIcon: Image.asset(
                        "assets/icon/app_icon_256x256.png",
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    showAboutDialog(
                      context: context,
                      applicationName: "FontKeep",
                      applicationIcon: Image.asset(
                        "assets/icon/app_icon_256x256.png",
                      ),
                    );
                  },
                  loading: () {
                    context.loaderOverlay.show();
                  },
                );
              },
              child: Text("About FontKeep"),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const _SectionHeader({required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color ?? Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
