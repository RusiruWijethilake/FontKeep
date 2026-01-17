import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/data/local/database.dart';
import 'package:fontkeep_app/features/library/data/repositories/font_repository.dart';

final selectedFontProvider = StateProvider<Font?>((ref) => null);
final Set<String> globallyLoadedFonts = {};
final searchQueryProvider = StateProvider<String>((ref) => '');
final sortOptionProvider = StateProvider<SortOption>(
  (ref) => SortOption.nameAsc,
);
final filterOptionProvider = StateProvider<FilterOption>(
  (ref) => FilterOption.all,
);

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final fontRepositoryProvider = Provider<FontRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final logger = ref.watch(loggerProvider);
  return FontRepository(db, logger);
});

final fontListProvider = StreamProvider<List<Font>>((ref) {
  final repository = ref.watch(fontRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final sort = ref.watch(sortOptionProvider);
  final filter = ref.watch(filterOptionProvider);

  return repository.watchFonts(query: query, sort: sort, filter: filter);
});

final libraryControllerProvider =
    StateNotifierProvider<LibraryController, AsyncValue<void>>((ref) {
      return LibraryController(ref);
    });

class LibraryController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  LibraryController(this.ref) : super(const AsyncData(null));

  Future<void> pickAndImportFonts() async {
    state = const AsyncLoading();

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf'],
      );

      if (result != null && result.paths.isNotEmpty) {
        final repo = ref.read(fontRepositoryProvider);

        await Future.wait(
          result.files.map((file) {
            if (file.path == null) return Future.value();

            return repo.importFontFile(
              ImportableFile(path: file.path, name: file.name),
            );
          }),
        );
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> scanSystemFonts() async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(fontRepositoryProvider);
      await repo.scanAndImportSystemFonts();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteFont(Font font) async {
    await ref.read(fontRepositoryProvider).deleteFont(font);
  }
}

Future<void> loadFontIntoFlutter(Font font, LoggerService logger) async {
  if (globallyLoadedFonts.contains(font.id)) return;

  try {
    final file = File(font.filePath);
    if (!await file.exists()) return;

    final bytes = await file.readAsBytes();
    final fontLoader = FontLoader(font.id);
    fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
    await fontLoader.load();

    globallyLoadedFonts.add(font.id);
  } catch (e) {
    logger.error(e);
  }
}

enum FilterOption { all, localOnly, installedOnly, osOnly }
