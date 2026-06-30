import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../feature/chat/data/local/chat_dao.dart';
import '../../feature/chat/data/local/messages_table.dart';
part 'app_database.g.dart';

/// Drift database — the single SQLite source of truth.
/// Mirrors the Android Room AppDatabase with the same schema.
@DriftDatabase(tables: [MessagesTable], daos: [ChatDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'chat.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
