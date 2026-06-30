import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/message.dart';
import '../../domain/sync/sync_status.dart';

part 'chat_state.freezed.dart';

@freezed
class ChatState with _$ChatState {
  const ChatState._();

  const factory ChatState({
    @Default([]) List<Message> messages,
    @Default('') String inputText,
    @Default(false) bool isTypingIndicatorVisible,
    @Default(SyncStatus.connected) SyncStatus syncStatus,
  }) = _ChatState;
}
