import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/model/message.dart';
import '../../domain/model/message_status.dart';
import '../../domain/repository/chat_repository.dart';
import '../../domain/stream/chat_message_stream.dart';
import '../local/chat_dao.dart';
import '../mapper/message_mapper.dart';
import '../stream/fake_network_config.dart';

/// Concrete implementation of [ChatRepository].
///
/// Inbound messages always flow:
///   FakeChatStream → Drift (insertOrUpdateInbound) → watchMessages() → UI
///
/// Nothing reaches the Bloc directly from the stream — Drift is the single funnel.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required AppDatabase database,
    required ChatMessageStream messageStream,
    required FakeNetworkConfig networkConfig,
  })  : _dao = database.chatDao,
        _networkConfig = networkConfig {
    // Pipe every inbound message through Drift so the UI stream reflects it.
    _inboundSub = messageStream.messages.listen((message) async {
      await insertOrUpdateInbound(message);
    });
  }

  final ChatDao _dao;
  final FakeNetworkConfig _networkConfig;
  late final StreamSubscription<Message> _inboundSub;

  final _uuid = const Uuid();

  // ---------------------------------------------------------------------------
  // ChatRepository
  // ---------------------------------------------------------------------------

  @override
  Future<void> insertPendingMessage(Message message) =>
      _dao.insertPending(message.toCompanion());

  @override
  Future<String> sendMessageToServer(Message message) async {
    // Simulate a short network round-trip.
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (_networkConfig.consumeFailureFlag()) {
      throw Exception('Simulated network failure');
    }

    // Return a fake server-assigned id.
    return 'srv-${_uuid.v4()}';
  }

  @override
  Future<void> updateMessage(Message message) =>
      _dao.updateMessage(message.toCompanion());

  @override
  Future<void> insertOrUpdateInbound(Message message) =>
      _dao.insertOrUpdateInbound(message.toCompanion());

  @override
  Stream<List<Message>> observeMessages() {
    return _dao
        .watchMessages()
        .map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  Future<void> dispose() => _inboundSub.cancel();
}
