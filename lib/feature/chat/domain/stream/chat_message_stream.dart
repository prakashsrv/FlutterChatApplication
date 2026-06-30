import '../model/message.dart';

/// Contract for the inbound message stream (fake or real WebSocket).
/// The data layer provides a concrete implementation via DI.
abstract interface class ChatMessageStream {
  /// Hot broadcast stream of inbound messages from the server.
  Stream<Message> get messages;

  /// Hot broadcast stream of the remote peer's typing state.
  Stream<bool> get isTyping;
}
