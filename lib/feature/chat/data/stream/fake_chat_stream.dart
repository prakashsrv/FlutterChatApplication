import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/model/message.dart';
import '../../domain/model/message_status.dart';
import '../../domain/stream/chat_message_stream.dart';

/// Simulated inbound message source — mirrors the Android FakeChatStream.
///
/// Background sync behaviour:
/// - [pause] stops delivering to the stream and buffers incoming messages.
/// - [resume] flushes the buffer in-order, then resumes live delivery.
///
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

  bool _isPaused = false;
  final _buffer = <Message>[];

  // ---------------------------------------------------------------------------
  // ChatMessageStream interface
  // ---------------------------------------------------------------------------

  @override
  Stream<Message> get messages => _messagesController.stream;

  @override
  Stream<bool> get isTyping => _typingController.stream;

  // ---------------------------------------------------------------------------
  // Background sync control
  // ---------------------------------------------------------------------------

  bool get isPaused => _isPaused;

  /// Pause delivery. Messages emitted while paused are buffered.
  void pause() => _isPaused = true;

  /// Resume delivery. Flushes buffered messages in arrival order first.
  Future<void> resume() async {
    if (!_isPaused) return;
    _isPaused = false;

    // Flush buffer with tiny inter-message delay so Drift can process each
    // insert and the UI scrolls smoothly rather than batching all at once.
    final pending = List<Message>.from(_buffer);
    _buffer.clear();

    for (final message in pending) {
      _messagesController.add(message);
      await Future<void>.delayed(const Duration(milliseconds: 8));
    }
  }

  // ---------------------------------------------------------------------------
  // Test / debug helpers
  // ---------------------------------------------------------------------------

  /// Emit a single inbound message (buffered if paused).
  void emit(String content) {
    final message = Message(
      id: _uuid.v4(),
      content: content,
      senderId: _botSenderId,
      clientTimestamp: DateTime.now().millisecondsSinceEpoch,
      status: MessageStatus.sent,
      isOwn: false,
    );

    if (_isPaused) {
      _buffer.add(message);
    } else {
      _messagesController.add(message);
    }
  }

  /// Emit [count] messages in rapid succession.
  Future<void> emitBurst(int count) async {
    for (var i = 0; i < count; i++) {
      emit('Burst message ${i + 1}');
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
  }

  void setTyping({required bool isTyping}) =>
      _typingController.add(isTyping);

  int get bufferedCount => _buffer.length;

  Future<void> dispose() async {
    await _messagesController.close();
    await _typingController.close();
  }
}
