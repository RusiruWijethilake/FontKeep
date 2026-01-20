import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontkeep_app/core/services/font_install_service.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/local/database.dart';

final bulkActionServiceProvider = Provider((ref) => BulkActionService(ref));

class BulkActionService {
  final Ref _ref;

  BulkActionService(this._ref);

  List<Font> filterInstallable(List<Font> fonts) {
    return fonts.where((f) => !f.isSystem).toList();
  }

  Future<Map<String, int>> installFonts(List<Font> fonts) async {
    final installService = FontInstallService();
    final logger = _ref.read(loggerProvider);
    final controller = _ref.read(libraryControllerProvider.notifier);

    int success = 0;
    int fail = 0;

    for (final font in fonts) {
      if (font.isSystem) continue;

      try {
        final result = await installService.install(logger, font.filePath);
        if (result) {
          success++;
          await controller.updateFontStatus(
            logger,
            font.copyWith(isSystem: true),
          );
        } else {
          fail++;
        }
      } catch (e) {
        fail++;
        logger.error("Failed to bulk install ${font.familyName}: $e");
      }
    }
    return {'success': success, 'fail': fail};
  }

  Future<void> deleteFonts(List<Font> fonts) async {
    final repo = _ref.read(fontRepositoryProvider);
    for (final font in fonts) {
      if (font.isBuiltIn) continue;
      await repo.deleteFont(font);
    }
  }

  Future<void> exportToZip(List<Font> fonts) async {
    if (fonts.isEmpty) return;

    final encoder = ZipFileEncoder();
    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(
      tempDir.path,
      'font_export_${DateTime.now().millisecondsSinceEpoch}.zip',
    );

    encoder.create(zipPath);

    for (final font in fonts) {
      final file = File(font.filePath);
      if (await file.exists()) {
        encoder.addFile(file);
      }
    }

    encoder.close();

    final zipFile = File(zipPath);
    if (await zipFile.exists()) {
      await SharePlus.instance.share(
        ShareParams(text: "Exported Fonts", files: [XFile(zipPath)]),
      );
    }
  }
}
