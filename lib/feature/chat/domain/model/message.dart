import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_status.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  // Private constructor must come before the factory.
  // It tells the IDE the class body is intentional and prevents
  // "implement abstract members" quick-fix stubs from being injected.
  const Message._();

  const factory Message({
    required String id,
    String? serverId,
    required String content,
    required String senderId,
    required int clientTimestamp,
    int? serverTimestamp,
    required MessageStatus status,
    required bool isOwn,
  }) = _Message;
}
