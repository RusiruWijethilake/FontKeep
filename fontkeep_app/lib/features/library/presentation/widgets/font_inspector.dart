import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/font_install_service.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/device_picker_dialog.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/glyph_inspector_view.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/smart_delete_dialog.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/variable_font_playground.dart';
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

    if (selectedFont == null) {
      return Container(
        width: 320,
        color: Theme.of(context).colorScheme.surface,
        child: const Center(child: Text("Select a font to view details")),
      );
    }

    return Container(
      width: 350,
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
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Preview'),
                      Tab(text: 'Playground'),
                      Tab(text: 'Glyphs'),
                    ],
                    labelStyle: Theme.of(context).textTheme.labelLarge,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildMainPreview(selectedFont, logger),
                        VariableFontPlayground(font: selectedFont),
                        GlyphInspectorView(font: selectedFont),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 200,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMetaItem(
                      context,
                      "Size",
                      "${(selectedFont.fileSize / 1024).toStringAsFixed(1)} KB",
                    ),
                    _buildMetaItem(
                      context,
                      "Format",
                      selectedFont.filePath.split('.').last.toUpperCase(),
                    ),
                    _buildMetaItem(
                      context,
                      "Status",
                      selectedFont.isSynced ? "Synced" : "Local",
                    ),
                  ],
                ),
                _buildMetaItem(context, "Path", selectedFont.filePath),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () async {
                          try {
                            await ref
                                .read(fontRepositoryProvider)
                                .shareFont(selectedFont);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.share, size: 18),
                        label: const Text("Share"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            _showDevicePicker(context, ref, selectedFont),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.send_to_mobile, size: 18),
                        label: const Text("Send"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (!selectedFont.isSystem)
                  FilledButton.icon(
                    onPressed: () async {
                      context.loaderOverlay.show();
                      try {
                        bool success = await installService.install(
                          logger,
                          selectedFont.filePath,
                        );

                        if (mounted) {
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
                const SizedBox(height: 8),
                OutlinedButton.icon(
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

  Widget _buildMainPreview(Font selectedFont, LoggerService logger) {
    return FutureBuilder(
      future: loadFontIntoFlutter(selectedFont, logger),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Preview unavailable\n${snapshot.error}"));
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
                  style: TextStyle(fontFamily: selectedFont.id, fontSize: 24),
                ),
              ],
            ),
          ),
        );
      },
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
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
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
