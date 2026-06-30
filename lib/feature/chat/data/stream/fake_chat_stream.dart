import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/model/message.dart';
import '../../domain/model/message_status.dart';
import '../../domain/stream/chat_message_stream.dart';

/// Simulated inbound message source — mirrors the Android FakeChatStream.
/// Uses broadcast StreamControllers so multiple listeners each receive every event.
class FakeChatStream implements ChatMessageStream {
  FakeChatStream() {
    _messagesController = StreamController<Message>.broadcast();
    _typingController = StreamController<bool>.broadcast();
  }

  late final StreamController<Message> _messagesController;
  late final StreamController<bool> _typingController;

  final _uuid = const Uuid();

  static const _botSenderId = 'bot-001';

  // ---------------------------------------------------------------------------
  // ChatMessageStream interface
  // ---------------------------------------------------------------------------

  @override
  Stream<Message> get messages => _messagesController.stream;

  @override
  Stream<bool> get isTyping => _typingController.stream;

  // ---------------------------------------------------------------------------
  // Test / debug helpers
  // ---------------------------------------------------------------------------

  /// Emit a single inbound message.
  void emit(String content) {
    _messagesController.add(
      Message(
        id: _uuid.v4(),
        content: content,
        senderId: _botSenderId,
        clientTimestamp: DateTime.now().millisecondsSinceEpoch,
        status: MessageStatus.sent,
        isOwn: false,
      ),
    );
  }

  /// Emit [count] messages in rapid succession — stress-tests ordering.
  Future<void> emitBurst(int count) async {
    for (var i = 0; i < count; i++) {
      emit('Burst message ${i + 1}');
      // Tiny delay so timestamps are distinct; still "rapid" at UI scale.
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
  }

  /// Toggle the typing indicator.
  void setTyping({required bool isTyping}) =>
      _typingController.add(isTyping);

  Future<void> dispose() async {
    await _messagesController.close();
    await _typingController.close();
  }
}
