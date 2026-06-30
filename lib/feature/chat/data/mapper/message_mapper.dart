import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/model/message.dart';
import '../../domain/model/message_status.dart';
import '../local/messages_table.dart';

/// Maps between domain [Message] and Drift [MessagesTableData] / [MessagesTableCompanion].
/// Keeps mapping logic out of the DAO and repository.
extension MessageMapper on Message {
  MessagesTableCompanion toCompanion() => MessagesTableCompanion(
        id: Value(id),
        serverId: Value(serverId),
        content: Value(content),
        senderId: Value(senderId),
        clientTimestamp: Value(clientTimestamp),
        serverTimestamp: Value(serverTimestamp),
        status: Value(status.name),
        isOwn: Value(isOwn),
      );
}

extension MessagesTableDataMapper on MessagesTableData {
  Message toDomain() => Message(
        id: id,
        serverId: serverId,
        content: content,
        senderId: senderId,
        clientTimestamp: clientTimestamp,
        serverTimestamp: serverTimestamp,
        status: MessageStatus.values.byName(status),
        isOwn: isOwn,
      );
}
