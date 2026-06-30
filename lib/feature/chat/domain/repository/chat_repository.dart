import '../model/message.dart';

/// Contract for the chat data layer.
/// The data layer implements this; the domain/presentation layers depend on it.
abstract interface class ChatRepository {
  /// Persist a locally-created pending message before attempting network send.
  Future<void> insertPendingMessage(Message message);

  /// Attempt to deliver the message to the server.
  /// Throws on failure — caller is responsible for catching and updating status.
  Future<String> sendMessageToServer(Message message);

  /// Update an existing row (e.g. pending → sent/failed, attach serverId).
  Future<void> updateMessage(Message message);

  /// Insert an inbound server message, or replace if serverId already exists (dedup).
  Future<void> insertOrUpdateInbound(Message message);

  /// Reactive stream of all messages ordered by clientTimestamp ascending.
  /// Re-emits on every DB change — the single source of truth for the UI.
  Stream<List<Message>> observeMessages();
}
