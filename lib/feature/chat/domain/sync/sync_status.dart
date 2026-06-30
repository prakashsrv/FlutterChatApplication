/// Represents the current background-sync state of the chat stream.
/// Exposed in [ChatState] so the UI can show an appropriate banner.
enum SyncStatus {
  /// Stream is active; messages are delivered in real time.
  connected,

  /// App is backgrounded; the stream is paused and messages are buffered.
  background,

  /// App has returned to foreground; buffered messages are being flushed.
  syncing,
}
