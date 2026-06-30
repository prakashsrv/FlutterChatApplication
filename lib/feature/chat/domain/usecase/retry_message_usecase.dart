import '../model/message.dart';
import '../model/message_status.dart';
import '../repository/chat_repository.dart';

class RetryMessageUseCase {
  RetryMessageUseCase(this._repository);

  final ChatRepository _repository;

  /// Takes a previously-failed Message, resets it to pending, and re-runs the send path.
  Future<void> call(Message failedMessage) async {
    final pending = failedMessage.copyWith(status: MessageStatus.pending);
    await _repository.updateMessage(pending);

    try {
      final serverId = await _repository.sendMessageToServer(pending);
      await _repository.updateMessage(
        pending.copyWith(
          serverId: serverId,
          status: MessageStatus.sent,
          serverTimestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (_) {
      await _repository.updateMessage(
        pending.copyWith(status: MessageStatus.failed),
      );
    }
  }
}
