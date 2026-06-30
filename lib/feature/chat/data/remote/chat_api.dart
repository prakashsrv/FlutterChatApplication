/// Placeholder for the future WebSocket / HTTP chat API.
/// Replace this stub with a real [web_socket_channel] implementation when ready.
abstract interface class ChatApi {
  /// Send a message to the server; returns the server-assigned id on success.
  Future<String> sendMessage({
    required String clientId,
    required String content,
    required String senderId,
  });
}
