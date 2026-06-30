import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import 'messages_table.dart';

part 'chat_dao.g.dart';

/// Drift DAO — the reactive query layer replacing Room DAO + Flow queries.
@DriftAccessor(tables: [MessagesTable])
class ChatDao extends DatabaseAccessor<AppDatabase> with _$ChatDaoMixin {
  ChatDao(super.attachedDatabase);

  // ---------------------------------------------------------------------------
  // Reactive read (= Room's @Query returning Flow)
  // ---------------------------------------------------------------------------

  /// Emits the full ordered list on every DB change.
  Stream<List<MessagesTableData>> watchMessages() {
    return (select(messagesTable)
          ..orderBy([(t) => OrderingTerm.asc(t.clientTimestamp)]))
        .watch();
  }

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  Future<void> insertPending(MessagesTableCompanion entry) =>
      into(messagesTable).insert(entry);

  Future<void> updateMessage(MessagesTableCompanion entry) =>
      (update(messagesTable)..where((t) => t.id.equals(entry.id.value)))
          .write(entry);

  /// INSERT OR REPLACE keyed on serverId (unique constraint handles dedup).
  Future<void> insertOrUpdateInbound(MessagesTableCompanion entry) =>
      into(messagesTable).insertOnConflictUpdate(entry);
}
