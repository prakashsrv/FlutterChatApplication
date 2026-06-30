import 'package:uuid/uuid.dart';

import '../model/message.dart';
import '../model/message_status.dart';
import '../repository/chat_repository.dart';

class SendMessageUseCase {
  SendMessageUseCase(this._repository);

  final ChatRepository _repository;
  final _uuid = const Uuid();

  /// Optimistic send:
  /// 1. Build a pending Message with a client UUID.
  /// 2. Insert it into the local DB immediately so the UI reflects it.
  /// 3. Attempt network delivery.
  /// 4. Update the row to sent (with serverId) or failed.
  Future<void> call({
    required String content,
    required String senderId,
  }) async {
    final message = Message(
      id: _uuid.v4(),
      content: content,
      senderId: senderId,
      clientTimestamp: DateTime.now().millisecondsSinceEpoch,
      status: MessageStatus.pending,
      isOwn: true,
    );

    await _repository.insertPendingMessage(message);

    try {
      final serverId = await _repository.sendMessageToServer(message);
      await _repository.updateMessage(
        message.copyWith(
          serverId: serverId,
          status: MessageStatus.sent,
          serverTimestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (_) {
      await _repository.updateMessage(
        message.copyWith(status: MessageStatus.failed),
      );
    }
  }
}
