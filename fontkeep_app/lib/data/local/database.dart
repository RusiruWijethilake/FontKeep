import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Fonts extends Table {
  TextColumn get id => text()();
  TextColumn get familyName => text()();
  TextColumn get subFamily => text()();
  TextColumn get filePath => text()();
  TextColumn get fileHash => text()();
  IntColumn get fileSize => integer()();
  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();

  // Sync Status
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get remoteId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Collections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer().nullable()();
}

class FontCollections extends Table {
  TextColumn get fontId => text().references(Fonts, #id, onDelete: KeyAction.cascade)();
  IntColumn get collectionId => integer().references(Collections, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {fontId, collectionId};
}

class SyncLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
  TextColumn get deviceName => text()();
  TextColumn get action => text()();
  TextColumn get details => text().nullable()();
}

@DriftDatabase(tables: [Fonts, Collections, FontCollections, SyncLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'FontKeep', 'fontkeep.sqlite'));

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    return NativeDatabase.createInBackground(file);
  });
}