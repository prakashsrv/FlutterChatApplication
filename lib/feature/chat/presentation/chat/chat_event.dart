import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/message.dart';
import '../../domain/sync/sync_status.dart';

part 'chat_event.freezed.dart';

/// Sealed union of all user-facing and internal events — mirrors Android's ChatAction.
@freezed
sealed class ChatEvent with _$ChatEvent {
  // User actions
  const factory ChatEvent.inputChanged(String text) = InputChanged;
  const factory ChatEvent.sendMessage() = SendMessage;
  const factory ChatEvent.retryMessage(Message message) = RetryMessage;
  const factory ChatEvent.simulateNextFailure() = SimulateNextFailure;

  // Internal — emitted by stream subscriptions inside the Bloc.
  // Named without leading underscore so they're accessible as type arguments
  // from chat_bloc.dart (private types can't cross library boundaries).
  const factory ChatEvent.messagesUpdated(List<Message> messages) =
      MessagesUpdated;
  const factory ChatEvent.typingChanged(bool isTyping) = TypingChanged;
  const factory ChatEvent.syncStatusChanged(SyncStatus status) =
      SyncStatusChanged;
}
