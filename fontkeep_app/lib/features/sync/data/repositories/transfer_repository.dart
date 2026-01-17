import 'dart:convert';
import 'dart:io' as io;

import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:fontkeep_app/core/utils/server_middleware.dart';
import 'package:fontkeep_app/features/library/data/repositories/font_repository.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../../../../data/local/database.dart';

class TransferRepository {
  final AppDatabase _db;
  final FontRepository _fontRepo;
  final LoggerService _logger;
  io.HttpServer? _server;
  final int _port = 53317;

  TransferRepository(this._db, this._fontRepo, this._logger);

  Future<void> startServer() async {
    if (_server != null) return;
    final router = Router();

    try {
      final handler = const Pipeline()
          .addMiddleware(loggingMiddleware(_logger))
          .addMiddleware(errorHandlingMiddleware(_logger))
          .addHandler(router.call);

      _server = await shelf_io.serve(
        handler,
        io.InternetAddress.anyIPv4,
        _port,
      );
    } catch (e) {
      _logger.error(e);
    }

    router.get('/ping', (Request request) => Response.ok('pong'));

    router.get('/manifest', (Request request) async {
      final shareableFonts = await (_db.select(
        _db.fonts,
      )..where((t) => t.isBuiltIn.equals(false))).get();

      final List<Map<String, dynamic>> manifest = shareableFonts
          .map(
            (f) => {
              'hash': f.fileHash,
              'name': f.familyName,
              'ext': p.extension(f.filePath),
              'type': f.isSystem ? 'installed' : 'local',
            },
          )
          .toList();

      return Response.ok(
        jsonEncode(manifest),
        headers: {'Content-Type': 'application/json'},
      );
    });

    router.get('/font/<hash>', (Request request, String hash) async {
      final font = await (_db.select(
        _db.fonts,
      )..where((t) => t.fileHash.equals(hash))).getSingleOrNull();
      if (font == null) return Response.notFound('Not Found');

      final file = io.File(font.filePath);
      if (!await file.exists()) return Response.notFound('File missing');

      return Response.ok(
        file.openRead(),
        headers: {
          'Content-Type': 'font/ttf',
          'Content-Disposition':
              'attachment; filename="${p.basename(font.filePath)}"',
          'Content-Length': (await file.length()).toString(),
        },
      );
    });

    try {
      final handler = Pipeline().addHandler(router.call);
      _server = await shelf_io.serve(
        handler,
        io.InternetAddress.anyIPv4,
        _port,
      );
    } catch (e) {
      _logger.error(e);
    }

    router.post('/upload', (Request request) async {
      try {
        final fileName = request.headers['X-File-Name'];
        if (fileName == null) {
          return Response.badRequest(body: 'Missing X-File-Name header');
        }

        final tempDir = await io.Directory.systemTemp.createTemp();
        final savePath = p.join(tempDir.path, fileName);
        final file = io.File(savePath);

        final sink = file.openWrite();
        await request.read().pipe(sink);
        await sink.close();
        await _fontRepo.importFontFile(
          ImportableFile(path: savePath, name: fileName),
        );
        return Response.ok('Imported $fileName');
      } catch (e) {
        _logger.error(e);
        return Response.internalServerError(body: e.toString());
      }
    });

    try {
      final handler = Pipeline().addHandler(router.call);
      _server = await shelf_io.serve(
        handler,
        io.InternetAddress.anyIPv4,
        _port,
      );
    } catch (e) {
      _logger.error(e);
    }
  }

  Future<void> stopServer() async {
    await _server?.close(force: true);
    _server = null;
  }

  Stream<double> syncWithDevice(String ip) async* {
    yield 0.0;

    try {
      final url = Uri.parse('http://$ip:$_port/manifest');
      final response = await http.get(url);

      if (response.statusCode != 200) throw Exception("Failed to get manifest");

      final List<dynamic> remoteList = jsonDecode(response.body);

      int successCount = 0;
      int totalToSync = 0;

      final missingFonts = <Map<String, dynamic>>[];
      for (final item in remoteList) {
        final hash = item['hash'];
        final exists = await (_db.select(
          _db.fonts,
        )..where((t) => t.fileHash.equals(hash))).getSingleOrNull();
        if (exists == null) {
          missingFonts.add(item as Map<String, dynamic>);
        }
      }

      totalToSync = missingFonts.length;
      if (totalToSync == 0) {
        yield 1.0;
        return;
      }

      for (final item in missingFonts) {
        final hash = item['hash'];
        final name = item['name'];
        final ext = item['ext'] ?? '.ttf';

        final dlUrl = Uri.parse('http://$ip:$_port/font/$hash');
        final dlResponse = await http.get(dlUrl);

        if (dlResponse.statusCode == 200) {
          final tempDir = await io.Directory.systemTemp.createTemp();
          final tempFile = io.File(p.join(tempDir.path, '$name$ext'));
          await tempFile.writeAsBytes(dlResponse.bodyBytes);
          await _fontRepo.importFontFile(
            ImportableFile(path: tempFile.path, name: '$name$ext'),
          );
        }

        successCount++;
        yield successCount / totalToSync;
      }
    } catch (e) {
      _logger.error(e);
    }
  }

  Future<String?> downloadFontFromDevice(
    String ip,
    String fileHash,
    String fileName,
  ) async {
    final url = Uri.parse('http://$ip:$_port/font/$fileHash');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return "SUCCESS";
      } else {
        _logger.error(
          "Download failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      _logger.error(e);
    }
    return null;
  }

  Future<void> sendFontToDevice(String ip, Font font) async {
    final file = io.File(font.filePath);
    if (!await file.exists()) throw Exception("Font file missing on disk");

    final url = Uri.parse('http://$ip:$_port/upload');
    final request = http.StreamedRequest('POST', url);

    request.headers['X-File-Name'] = p.basename(font.filePath);

    final length = await file.length();
    request.contentLength = length;

    file.openRead().listen(
      (chunk) => request.sink.add(chunk),
      onDone: () => request.sink.close(),
      onError: (e) {
        request.sink.addError(e);
        request.sink.close();
      },
    );

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode != 200) {
      throw Exception(
        "Transfer failed: ${response.statusCode} - ${response.body}",
      );
    }
  }
}
