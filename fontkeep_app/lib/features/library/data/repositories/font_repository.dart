import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/local/database.dart';

class FontRepository {
  final AppDatabase _db;
  final LoggerService _logger;
  final Uuid _uuid = const Uuid();

  FontRepository(this._db, this._logger);

  Stream<List<Font>> watchAllFonts() {
    return _db.select(_db.fonts).watch();
  }

  Stream<List<Font>> watchFonts({
    String query = '',
    SortOption sort = SortOption.nameAsc,
    FilterOption filter = FilterOption.all,
  }) {
    var stmt = _db.select(_db.fonts);

    if (query.isNotEmpty) {
      stmt.where((t) => t.familyName.contains(query.toLowerCase()));
    }

    switch (filter) {
      case FilterOption.all:
        break;
      case FilterOption.localOnly:
        stmt.where((t) => t.isSystem.equals(false));
        break;
      case FilterOption.installedOnly:
        stmt.where((t) => t.isSystem.equals(true) & t.isBuiltIn.equals(false));
        break;
      case FilterOption.osOnly:
        stmt.where((t) => t.isBuiltIn.equals(true));
        break;
    }

    switch (sort) {
      case SortOption.nameAsc:
        stmt.orderBy([
          (t) => OrderingTerm(expression: t.familyName, mode: OrderingMode.asc),
        ]);
        break;
      case SortOption.nameDesc:
        stmt.orderBy([
          (t) =>
              OrderingTerm(expression: t.familyName, mode: OrderingMode.desc),
        ]);
        break;
      case SortOption.sizeDesc:
        stmt.orderBy([
          (t) => OrderingTerm(expression: t.fileSize, mode: OrderingMode.desc),
        ]);
        break;
      case SortOption.dateDesc:
        break;
    }

    return stmt.watch();
  }

  Future<void> importFontFile(ImportableFile pickedFile) async {
    final file = File(pickedFile.path!);
    if (!await file.exists()) return;

    final bytes = await file.readAsBytes();
    final hash = md5.convert(bytes).toString();

    final existing = await (_db.select(
      _db.fonts,
    )..where((tbl) => tbl.fileHash.equals(hash))).getSingleOrNull();
    if (existing != null) {
      _logger.info("Font already exists: ${existing.familyName}");
      return;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final libraryDir = Directory(p.join(appDir.path, 'FontKeep', 'Library'));
    if (!await libraryDir.exists()) {
      await libraryDir.create(recursive: true);
    }

    final ext = p.extension(pickedFile.name);
    final uniqueName =
        '${p.basenameWithoutExtension(pickedFile.name)}_$hash$ext';
    final savedPath = p.join(libraryDir.path, uniqueName);

    await file.copy(savedPath);

    final fontName = p.basenameWithoutExtension(pickedFile.name);

    await _db
        .into(_db.fonts)
        .insert(
          FontsCompanion(
            id: Value(_uuid.v4()),
            familyName: Value(fontName),
            subFamily: const Value("Regular"),
            filePath: Value(savedPath),
            fileHash: Value(hash),
            fileSize: Value(bytes.length),
            isSynced: const Value(false),
            isSystem: const Value(false),
          ),
        );
  }

  Future<int> scanAndImportSystemFonts() async {
    int importCount = 0;

    final Map<String, bool> systemPaths = {};

    if (Platform.isWindows) {
      final windir = Platform.environment['WINDIR'] ?? 'C:\\Windows';
      final localAppData = Platform.environment['LOCALAPPDATA'];
      systemPaths[p.join(windir, 'Fonts')] = true;
      if (localAppData != null) {
        systemPaths[p.join(localAppData, 'Microsoft', 'Windows', 'Fonts')] =
            false;
      }
    } else if (Platform.isMacOS) {
      systemPaths['/System/Library/Fonts'] = true;
      systemPaths['/Library/Fonts'] = true;
      final home = Platform.environment['HOME'] ?? '';
      systemPaths[p.join(home, 'Library', 'Fonts')] = false;
    } else if (Platform.isLinux) {
      systemPaths['/usr/share/fonts'] = true;
      systemPaths['/usr/local/share/fonts'] = true;
      final home = Platform.environment['HOME'] ?? '';
      systemPaths[p.join(home, 'Library', 'fonts')] = false;
      systemPaths[p.join(home, 'Library', '.local', 'share', 'fonts')] = false;
    }

    for (final entry in systemPaths.entries) {
      final path = entry.key;
      final isBuiltIn = entry.value;

      final directory = Directory(path);
      if (!await directory.exists()) continue;

      try {
        final List<FileSystemEntity> entities = await directory
            .list(recursive: true, followLinks: false)
            .toList();

        for (final entity in entities) {
          if (entity is File) {
            final ext = p.extension(entity.path).toLowerCase();
            if (ext == '.ttf' || ext == '.otf') {
              final success = await _registerSystemFont(
                entity,
                isBuiltIn: isBuiltIn,
              );
              if (success) importCount++;
            }
          }
        }
      } catch (e) {
        _logger.error(e);
      }
    }
    return importCount;
  }

  Future<bool> _registerSystemFont(File file, {required bool isBuiltIn}) async {
    try {
      final pathExists = await (_db.select(
        _db.fonts,
      )..where((t) => t.filePath.equals(file.path))).getSingleOrNull();
      if (pathExists != null) return false;

      final bytes = await file.readAsBytes();
      final hash = md5.convert(bytes).toString();

      final hashExists = await (_db.select(
        _db.fonts,
      )..where((t) => t.fileHash.equals(hash))).getSingleOrNull();

      if (hashExists != null) {
        if (!hashExists.isSystem) {
          await (_db.update(_db.fonts)
                ..where((t) => t.id.equals(hashExists.id)))
              .write(const FontsCompanion(isSystem: Value(true)));
        }
        return false;
      }

      final fontName = p.basenameWithoutExtension(file.path);

      await _db
          .into(_db.fonts)
          .insert(
            FontsCompanion(
              id: Value(_uuid.v4()),
              familyName: Value(fontName),
              subFamily: const Value("Regular"),
              filePath: Value(file.path),
              fileHash: Value(hash),
              fileSize: Value(bytes.length),
              isSynced: const Value(false),
              isSystem: const Value(true),
              isBuiltIn: Value(isBuiltIn),
            ),
          );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteFont(Font font) async {
    await (_db.delete(_db.fonts)..where((t) => t.id.equals(font.id))).go();
    if (font.filePath.contains("FontKeep")) {
      final file = File(font.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<void> shareFont(Font font) async {
    final file = File(font.filePath);
    if (await file.exists()) {
      await SharePlus.instance.share(
        ShareParams(
          text: 'Check out this font: ${font.familyName}',
          files: [XFile(font.filePath)],
        ),
      );
    } else {
      throw Exception("Font file not found on disk.");
    }
  }

  Future<void> openSystemInstaller(Font font) async {
    final file = File(font.filePath);
    if (!await file.exists()) {
      throw Exception("File not found: ${font.filePath}");
    }

    if (Platform.isWindows) {
      await Process.run('explorer', [font.filePath]);
    } else if (Platform.isMacOS) {
      await Process.run('open', [font.filePath]);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [font.filePath]);
    } else {
      final result = await OpenFile.open(font.filePath);
      if (result.type != ResultType.done) {
        throw Exception("Could not open font file: ${result.message}");
      }
    }
  }
}

class ImportableFile {
  final String? path;
  final String name;

  ImportableFile({required this.path, required this.name});
}

enum SortOption { nameAsc, nameDesc, sizeDesc, dateDesc }
