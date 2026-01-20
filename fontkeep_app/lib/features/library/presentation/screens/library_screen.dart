import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fontkeep_app/core/services/bulk_action_service.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/data/repositories/font_repository.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/font_inspector.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/smart_delete_dialog.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../domain/providers/library_providers.dart';

final multiSelectionProvider = StateProvider<Set<Font>>((ref) => {});
final isSelectionModeProvider = StateProvider<bool>((ref) => false);

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontsAsync = ref.watch(fontListProvider);
    final multiSelection = ref.watch(multiSelectionProvider);
    final isSelectionMode = ref.watch(isSelectionModeProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final currentFilter = ref.watch(filterOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(context, ref, searchQuery),
        titleSpacing: 16,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton.icon(
            label: Text(
              isSelectionMode ? "Exit Selection Mode" : "Select Multiple",
            ),
            icon: Icon(
              isSelectionMode ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelectionMode
                  ? Theme.of(context).colorScheme.primary
                  : null,
            ),
            onPressed: () {
              final newState = !isSelectionMode;
              ref.read(isSelectionModeProvider.notifier).state = newState;
              if (!newState) {
                ref.read(multiSelectionProvider.notifier).state = {};
              }
            },
          ),
          PopupMenuButton<FilterOption>(
            icon: Icon(
              currentFilter == FilterOption.all
                  ? Icons.filter_alt_off
                  : Icons.filter_alt,
              color: currentFilter == FilterOption.all
                  ? null
                  : Theme.of(context).colorScheme.primary,
            ),
            tooltip: "Filter Fonts",
            onSelected: (option) =>
                ref.read(filterOptionProvider.notifier).state = option,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text("Show All"),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: FilterOption.localOnly,
                child: Row(
                  children: [
                    Icon(Icons.folder, color: Colors.green[700], size: 20),
                    const SizedBox(width: 12),
                    const Text("Local Only"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterOption.installedOnly,
                child: Row(
                  children: [
                    Icon(
                      Icons.download_done,
                      color: Colors.purple[700],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text("Installed (User)"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterOption.osOnly,
                child: Row(
                  children: [
                    Icon(
                      Icons.desktop_windows,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text("OS Defaults"),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: "Sort Fonts",
            onSelected: (option) =>
                ref.read(sortOptionProvider.notifier).state = option,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.nameAsc,
                child: Text("Name (A-Z)"),
              ),
              const PopupMenuItem(
                value: SortOption.nameDesc,
                child: Text("Name (Z-A)"),
              ),
              const PopupMenuItem(
                value: SortOption.sizeDesc,
                child: Text("Size (Largest)"),
              ),
            ],
          ),
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            tooltip: "More Options",
            onSelected: (value) async {
              if (value == 0) {
                context.loaderOverlay.show();
                try {
                  await ref
                      .read(libraryControllerProvider.notifier)
                      .scanSystemFonts();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('System scan completed.')),
                    );
                  }
                } finally {
                  if (context.mounted) context.loaderOverlay.hide();
                }
              } else if (value == 1) {
                context.loaderOverlay.show();
                try {
                  await ref
                      .read(libraryControllerProvider.notifier)
                      .pickAndImportFonts();
                } finally {
                  if (context.mounted) context.loaderOverlay.hide();
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0,
                child: Row(
                  children: [
                    Icon(Icons.travel_explore),
                    SizedBox(width: 12),
                    Text("Scan System Fonts"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 1,
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 12),
                    Text("Import Font Files"),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: fontsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (fonts) => Stack(
                children: [
                  Positioned.fill(child: _FontGrid(fonts: fonts)),
                  if (isSelectionMode && multiSelection.isNotEmpty)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 0,
                      child: BulkActionsBar(
                        selectedFonts: multiSelection.toList(),
                        onClearSelection: () {
                          ref.read(multiSelectionProvider.notifier).state = {};
                          ref.read(isSelectionModeProvider.notifier).state =
                              false;
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!isSelectionMode) const FontInspector(),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    WidgetRef ref,
    String currentQuery,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: "Search fonts...",
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: currentQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    ref.read(searchQueryProvider.notifier).state = '';
                  },
                )
              : null,
        ),
      ),
    );
  }
}

class _FontGrid extends ConsumerWidget {
  final List<Font> fonts;

  const _FontGrid({required this.fonts});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (fonts.isEmpty) return const Center(child: Text("No fonts found."));

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: fonts.length,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        return _FontGridItem(font: fonts[index]);
      },
    );
  }
}

class _FontGridItem extends ConsumerWidget {
  final Font font;

  const _FontGridItem({required this.font});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedFontProvider)?.id == font.id;
    final isSelectionMode = ref.watch(isSelectionModeProvider);
    final isMultiSelected =
        isSelectionMode &&
        ref.watch(
          multiSelectionProvider.select((s) => s.any((f) => f.id == font.id)),
        );
    final logger = ref.read(loggerProvider);

    Color cardColor;
    if (isMultiSelected) {
      cardColor = Theme.of(context).colorScheme.primaryContainer;
    } else if (isSelected && !isSelectionMode) {
      cardColor = Theme.of(context).colorScheme.surfaceContainerHighest;
    } else {
      cardColor = Theme.of(context).colorScheme.surfaceContainer;
    }

    return Card(
      elevation: isMultiSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isMultiSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      color: cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isSelectionMode) {
            _toggleSelection(ref, font);
          } else {
            ref.read(selectedFontProvider.notifier).state = font;
          }
        },
        onLongPress: () {
          ref.read(isSelectionModeProvider.notifier).state = true;
          _toggleSelection(ref, font);
          ref.read(selectedFontProvider.notifier).state = font;
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: globallyLoadedFonts.contains(font.id)
                          ? Text(
                              "Aa",
                              style: TextStyle(
                                fontFamily: font.id,
                                fontSize: 48,
                                color: isMultiSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                          : FutureBuilder(
                              future: loadFontIntoFlutter(font, logger),
                              builder: (context, snapshot) {
                                final isLoaded =
                                    snapshot.connectionState ==
                                    ConnectionState.done;
                                return Text(
                                  "Aa",
                                  style: TextStyle(
                                    fontFamily: isLoaded ? font.id : null,
                                    fontSize: 48,
                                    color: isMultiSelected
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onPrimaryContainer
                                        : Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    font.familyName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Positioned(top: 8, right: 8, child: _buildStatusBadge(font)),
            if (isMultiSelected)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _toggleSelection(WidgetRef ref, Font font) {
    final currentSet = ref.read(multiSelectionProvider);
    final newSet = {...currentSet};
    if (newSet.any((f) => f.id == font.id)) {
      newSet.removeWhere((f) => f.id == font.id);
    } else {
      newSet.add(font);
    }
    ref.read(multiSelectionProvider.notifier).state = newSet;
  }

  Widget _buildStatusBadge(Font font) {
    Color color;
    String text;

    if (!font.isSystem) {
      color = Colors.green;
      text = "LOCAL";
    } else if (font.isBuiltIn) {
      color = Colors.blueGrey;
      text = "OS";
    } else {
      color = Colors.purple;
      text = "INSTALLED";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class BulkActionsBar extends ConsumerWidget {
  final List<Font> selectedFonts;
  final VoidCallback onClearSelection;

  const BulkActionsBar({
    super.key,
    required this.selectedFonts,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bulkService = ref.read(bulkActionServiceProvider);
    final installable = bulkService.filterInstallable(selectedFonts);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              tooltip: installable.isEmpty
                  ? "No installable fonts selected"
                  : "Install ${installable.length} fonts",
              icon: const Icon(Icons.system_update),
              onPressed: installable.isEmpty
                  ? null
                  : () async {
                      context.loaderOverlay.show();
                      try {
                        final messenger = ScaffoldMessenger.of(context);
                        if (selectedFonts.length > installable.length) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                "Installing ${installable.length} fonts. (${selectedFonts.length - installable.length} skipped)",
                              ),
                            ),
                          );
                        }
                        final result = await bulkService.installFonts(
                          installable,
                        );
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Installed: ${result['success']} | Failed: ${result['fail']}",
                            ),
                            backgroundColor: result['fail']! > 0
                                ? Colors.orange
                                : Colors.green,
                          ),
                        );
                        onClearSelection();
                      } finally {
                        if (context.mounted) context.loaderOverlay.hide();
                      }
                    },
            ),
            IconButton(
              tooltip: "Send to Device",
              icon: const Icon(Icons.send_to_mobile),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => DevicePickerDialog(fonts: selectedFonts),
                );
              },
            ),
            IconButton(
              tooltip: "Export to Zip",
              icon: const Icon(Icons.archive),
              onPressed: () async {
                context.loaderOverlay.show();
                try {
                  await bulkService.exportToZip(selectedFonts);
                  onClearSelection();
                } finally {
                  if (context.mounted) context.loaderOverlay.hide();
                }
              },
            ),

            IconButton(
              tooltip: "Delete",
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => SmartDeleteDialog(
                    fonts: selectedFonts,
                    onConfirm: () async {
                      context.loaderOverlay.show();
                      try {
                        await bulkService.deleteFonts(selectedFonts);
                        onClearSelection();
                      } finally {
                        if (context.mounted) context.loaderOverlay.hide();
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
