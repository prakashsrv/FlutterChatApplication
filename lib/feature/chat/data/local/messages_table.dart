import 'package:drift/drift.dart';

/// Drift table definition — mirrors the Android Room `MessageEntity` columns.
class MessagesTable extends Table {
  @override
  String get tableName => 'messages';

  /// Client-generated UUID — the stable primary key for optimistic sends.
  TextColumn get id => text()();

  /// Server-assigned id; null until the server acknowledges the message.
  /// Unique index below prevents duplicate inbound echoes.
  TextColumn get serverId => text().nullable()();

  TextColumn get content => text()();
  TextColumn get senderId => text()();

  /// UTC millis set by the client at send time — used for ordering.
  IntColumn get clientTimestamp => integer()();

  /// UTC millis from the server; null until the echo arrives.
  IntColumn get serverTimestamp => integer().nullable()();

  /// Stored as string ("pending" | "sent" | "failed").
  TextColumn get status => text()();

  BoolColumn get isOwn => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'UNIQUE (server_id) ON CONFLICT REPLACE',
      ];
}
