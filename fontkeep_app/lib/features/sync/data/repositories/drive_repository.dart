import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:fontkeep_app/features/library/data/repositories/font_repository.dart';
import 'package:fontkeep_app/features/settings/data/repositories/auth_repository.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../data/local/database.dart';

class DriveRepository {
  final AuthRepository _authRepo;
  final AppDatabase _db;
  final FontRepository _fontRepo;

  DriveRepository(this._authRepo, this._db, this._fontRepo);

  static const String _backupFileName = 'fontkeep_backup.zip';

  Stream<String> backupLibrary() async* {
    yield "Authenticating...";
    final client = await _authRepo.getAuthenticatedClient();
    if (client == null) throw Exception("Not logged in");

    final driveApi = drive.DriveApi(client);

    yield "Preparing files...";
    final fontsToBackup =
        await (_db.select(_db.fonts)..where(
              (t) => t.isBuiltIn.equals(false),
            ) // Backup Local AND User-System
            )
            .get();
    if (fontsToBackup.isEmpty) {
      yield "No user fonts to backup.";
      return;
    }

    yield "Zipping ${fontsToBackup.length} fonts...";
    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(tempDir.path, _backupFileName);
    final encoder = ZipFileEncoder();
    encoder.create(zipPath);

    for (final font in fontsToBackup) {
      final file = File(font.filePath);
      if (await file.exists()) {
        encoder.addFile(file);
      }
    }
    encoder.close();

    yield "Uploading to Google Drive...";
    final uploadFile = File(zipPath);
    final media = drive.Media(uploadFile.openRead(), uploadFile.lengthSync());

    final q = "name = '$_backupFileName' and trashed = false";
    final fileList = await driveApi.files.list(q: q, spaces: 'drive');
    final existingId = fileList.files?.firstOrNull?.id;

    if (existingId != null) {
      await driveApi.files.update(drive.File(), existingId, uploadMedia: media);
    } else {
      await driveApi.files.create(
        drive.File(name: _backupFileName),
        uploadMedia: media,
      );
    }

    yield "Success! Backup Complete.";
  }

  Stream<String> restoreLibrary() async* {
    yield "Authenticating...";
    final client = await _authRepo.getAuthenticatedClient();
    if (client == null) throw Exception("Not logged in");

    final driveApi = drive.DriveApi(client);

    yield "Looking for backup...";
    final q = "name = '$_backupFileName' and trashed = false";
    final fileList = await driveApi.files.list(q: q, spaces: 'drive');
    final fileId = fileList.files?.firstOrNull?.id;

    if (fileId == null) {
      throw Exception("No backup found named '$_backupFileName'");
    }

    yield "Downloading backup...";
    final drive.Media file =
        await driveApi.files.get(
              fileId,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(tempDir.path, 'restore_temp.zip');
    final saveFile = File(zipPath);

    final stream = file.stream;
    final sink = saveFile.openWrite();
    await stream.pipe(sink);
    await sink.flush();
    await sink.close();

    yield "Unzipping...";
    final bytes = await saveFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    final appDocDir = await getApplicationDocumentsDirectory();
    final restoreDir = Directory(p.join(appDocDir.path, 'FontKeep_Restored'));
    if (!await restoreDir.exists()) await restoreDir.create();

    yield "Importing fonts...";
    int count = 0;
    for (final file in archive) {
      if (file.isFile) {
        final data = file.content as List<int>;
        final path = p.join(restoreDir.path, file.name);
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);

        await _fontRepo.importFontFile(
          ImportableFile(path: path, name: file.name),
        );
        count++;
      }
    }

    yield "Restored $count fonts successfully!";
  }
}
