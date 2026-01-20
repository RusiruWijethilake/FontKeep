import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/data/repositories/font_repository.dart';
import 'package:fontkeep_app/features/library/presentation/widgets/font_inspector.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../domain/providers/library_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontsAsync = ref.watch(fontListProvider);
    final selectedFont = ref.watch(selectedFontProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final currentFilter = ref.watch(filterOptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(context, ref, searchQuery),
        backgroundColor: Colors.transparent,
        actions: [
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
              const PopupMenuDivider(),
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
          const SizedBox(width: 8),
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
          const SizedBox(width: 8),
          IconButton(
            tooltip: "Scan System Fonts",
            icon: const Icon(Icons.travel_explore),
            onPressed: () async {
              context.loaderOverlay.show();
              await ref
                  .read(libraryControllerProvider.notifier)
                  .scanSystemFonts();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('System scan completed. Check the grid!'),
                  ),
                );
              }
              if (context.mounted) context.loaderOverlay.hide();
            },
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {
              ref.read(libraryControllerProvider.notifier).pickAndImportFonts();
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Fonts'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: fontsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (fonts) => _buildGrid(context, ref, fonts, selectedFont),
            ),
          ),
          const FontInspector(),
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
      constraints: const BoxConstraints(maxWidth: 400),
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

  Widget _buildGrid(
    BuildContext context,
    WidgetRef ref,
    List<Font> fonts,
    Font? selectedFont,
  ) {
    if (fonts.isEmpty) return const Center(child: Text("No fonts found."));

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: fonts.length,
      itemBuilder: (context, index) {
        final logger = ref.watch(loggerProvider);
        final font = fonts[index];
        final isSelected = selectedFont?.id == font.id;

        return Card(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: InkWell(
            onTap: () => ref.read(selectedFontProvider.notifier).state = font,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: FutureBuilder(
                            future: loadFontIntoFlutter(font, logger),
                            builder: (context, snapshot) {
                              final isLoaded =
                                  snapshot.connectionState ==
                                      ConnectionState.done ||
                                  globallyLoadedFonts.contains(font.id);

                              return Text(
                                "Aa",
                                style: TextStyle(
                                  fontFamily: isLoaded ? font.id : null,
                                  fontSize: 48,
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.primary,
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: !font.isSystem
                          ? Colors.green
                          : (font.isBuiltIn ? Colors.blueGrey : Colors.purple),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      !font.isSystem
                          ? "LOCAL"
                          : (font.isBuiltIn ? "OS" : "INSTALLED"),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
