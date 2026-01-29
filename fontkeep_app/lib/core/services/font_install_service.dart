import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:win32/win32.dart';

class FontInstallService {
  Future<bool> install(LoggerService logger, String sourcePath) async {
    if (Platform.isWindows) {
      return _installWindows(logger, sourcePath);
    } else if (Platform.isMacOS) {
      return _installMacOS(sourcePath);
    } else if (Platform.isLinux) {
      return _installLinux(sourcePath);
    }
    return false;
  }

  Future<void> openNativeViewer(LoggerService logger, String filePath) async {
    final result = await OpenFilex.open(filePath);
    if (result.type != ResultType.done) {
      logger.error("Could not open file: ${result.message}");
    }
  }

  Future<bool> _installWindows(LoggerService logger, String sourcePath) async {
    try {
      final fileName = p.basename(sourcePath);

      final localAppData = Platform.environment['LOCALAPPDATA'];
      if (localAppData == null) throw Exception("LOCALAPPDATA not found");

      final destDir = Directory(
        p.join(localAppData, 'Microsoft', 'Windows', 'Fonts'),
      );
      if (!await destDir.exists()) {
        await destDir.create(recursive: true);
      }
      final destPath = p.join(destDir.path, fileName);

      final destFile = File(destPath);
      if (await destFile.exists()) {
        try {
          await destFile.delete();
        } catch (e) {
          logger.error("Could not delete existing font file: $e");
        }
      }
      await File(sourcePath).copy(destPath);

      String fontName = p.basenameWithoutExtension(fileName);

      try {
        final tempDir = await getTemporaryDirectory();
        final scriptPath = p.join(tempDir.path, 'get_font_name.ps1');
        final scriptFile = File(scriptPath);

        const psScript = r'''
param([string]$path)
try {
  Add-Type -AssemblyName System.Drawing
  $fonts = New-Object System.Drawing.Text.PrivateFontCollection
  $fonts.AddFontFile($path)
  if ($fonts.Families.Count -gt 0) {
    Write-Output $fonts.Families[0].Name
  }
} catch {
  # If this fails, we output nothing and Dart uses fallback
}
''';
        await scriptFile.writeAsString(psScript);

        final nameResult = await Process.run('powershell', [
          '-NoProfile',
          '-ExecutionPolicy',
          'Bypass',
          '-File',
          scriptPath,
          '-path',
          destPath,
        ]);

        if (nameResult.exitCode == 0) {
          final output = nameResult.stdout.toString().trim();
          if (output.isNotEmpty) {
            fontName = output;
          }
        }

        await scriptFile.delete();
      } catch (e) {
        logger.error(
          "PowerShell font name extraction failed, using filename: $e",
        );
      }

      try {
        final tempDir = await getTemporaryDirectory();
        final regScriptPath = p.join(tempDir.path, 'register_font.ps1');
        final regScriptFile = File(regScriptPath);

        final regContent = '''
param([string]\$fPath, [string]\$fName)
\$regValue = "\$fName (TrueType)"
\$regPath = "HKCU:\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Fonts"
Set-ItemProperty -Path \$regPath -Name \$regValue -Value \$fPath
''';
        await regScriptFile.writeAsString(regContent);

        await Process.run('powershell', [
          '-NoProfile',
          '-ExecutionPolicy',
          'Bypass',
          '-File',
          regScriptPath,
          '-fPath',
          destPath,
          '-fName',
          fontName,
        ]);

        await regScriptFile.delete();
      } catch (e) {
        logger.error("Registry update failed: $e");
      }

      final pathPtr = destPath.toNativeUtf16();
      final added = AddFontResource(pathPtr);

      if (added > 0) {
        PostMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
      }

      calloc.free(pathPtr);

      return added > 0;
    } catch (e) {
      logger.error("Windows Install Error: $e");
      return false;
    }
  }

  Future<bool> _installMacOS(String sourcePath) async {
    try {
      final home = Platform.environment['HOME'];
      if (home == null) throw Exception("Could not find HOME directory");

      final fontDir = Directory(p.join(home, 'Library', 'Fonts'));
      if (!await fontDir.exists()) {
        await fontDir.create(recursive: true);
      }

      final fileName = p.basename(sourcePath);
      final destPath = p.join(fontDir.path, fileName);

      await File(sourcePath).copy(destPath);
      return true;
    } catch (e) {
      debugPrint("macOS Install Error: $e");
      return false;
    }
  }

  Future<bool> _installLinux(String sourcePath) async {
    try {
      final home = Platform.environment['HOME'];
      if (home == null) throw Exception("Could not find HOME directory");

      final fontDir = Directory(p.join(home, '.local', 'share', 'fonts'));
      if (!await fontDir.exists()) {
        await fontDir.create(recursive: true);
      }

      final fileName = p.basename(sourcePath);
      final destPath = p.join(fontDir.path, fileName);

      await File(sourcePath).copy(destPath);

      final result = await Process.run('fc-cache', ['-f']);
      if (result.exitCode != 0) {
        debugPrint("fc-cache failed: ${result.stderr}");
      }
      return true;
    } catch (e) {
      debugPrint("Linux Install Error: $e");
      return false;
    }
  }
}
