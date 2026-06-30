// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_dao.dart';

// ignore_for_file: type=lint
mixin _$ChatDaoMixin on DatabaseAccessor<AppDatabase> {
  $MessagesTableTable get messagesTable => attachedDatabase.messagesTable;
  ChatDaoManager get managers => ChatDaoManager(this);
}

class ChatDaoManager {
  final _$ChatDaoMixin _db;
  ChatDaoManager(this._db);
  $$MessagesTableTableTableManager get messagesTable =>
      $$MessagesTableTableTableManager(_db.attachedDatabase, _db.messagesTable);
}
