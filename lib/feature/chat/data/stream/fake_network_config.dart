/// Controls the simulated network behavior of [FakeChatStream].
/// Mirrors the Android `FakeNetworkConfig`.
class FakeNetworkConfig {
  bool _failNext = false;

  /// Set to make the next [ChatRepository.sendMessageToServer] throw.
  void setFailNext() => _failNext = true;

  /// Called by [ChatRepositoryImpl.sendMessageToServer]; resets after consumption.
  bool consumeFailureFlag() {
    final value = _failNext;
    _failNext = false;
    return value;
  }
}
