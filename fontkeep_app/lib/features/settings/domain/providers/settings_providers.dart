import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/features/library/domain/providers/library_providers.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode');
    if (saved == 'light') state = ThemeMode.light;
    if (saved == 'dark') state = ThemeMode.dark;
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }
}

final accentColorProvider = StateNotifierProvider<ColorNotifier, Color>((ref) {
  return ColorNotifier();
});

class ColorNotifier extends StateNotifier<Color> {
  ColorNotifier() : super(Colors.teal) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final int? colorValue = prefs.getInt('accent_color');
    if (colorValue != null) state = Color(colorValue);
  }

  Future<void> set(Color color) async {
    state = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accent_color', color.toARGB32());
  }
}

final settingsControllerProvider = Provider((ref) => SettingsController(ref));

class SettingsController {
  final Ref ref;

  SettingsController(this.ref);

  Future<void> exportFontsAsZip() async {
    final db = ref.read(appDatabaseProvider);

    final fonts = await (db.select(
      db.fonts,
    )..where((t) => t.isSystem.equals(false))).get();

    if (fonts.isEmpty) throw Exception("No user fonts to export.");

    final encoder = ZipFileEncoder();
    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(tempDir.path, 'FontKeep_Export.zip');

    encoder.create(zipPath);

    for (final font in fonts) {
      final file = File(font.filePath);
      if (await file.exists()) {
        encoder.addFile(file);
      }
    }
    encoder.close();

    final file = File(zipPath);
    if (await file.exists()) {
      await SharePlus.instance.share(
        ShareParams(text: 'My FontKeep Collection', files: [XFile(zipPath)]),
      );
    }
  }

  Future<void> deleteDatabase() async {
    final db = ref.read(appDatabaseProvider);
    final logger = ref.read(loggerProvider);

    try {
      await db.close();
    } catch (e) {
      logger.error(e);
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'FontKeep', 'fontkeep.sqlite'));

    try {
      if (await file.exists()) {
        await file.delete();
      }

      final walFile = File('${file.path}-wal');
      final shmFile = File('${file.path}-shm');
      if (await walFile.exists()) await walFile.delete();
      if (await shmFile.exists()) await shmFile.delete();
    } catch (e) {
      logger.error(e);
    }

    exit(0);
  }
}
