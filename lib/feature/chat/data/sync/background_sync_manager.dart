import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../../core/lifecycle/app_lifecycle_observer.dart';
import '../../domain/sync/sync_status.dart';
import '../stream/fake_chat_stream.dart';

/// Bridges the Flutter app-lifecycle with the chat stream.
///
/// Lifecycle → stream behaviour:
///   paused / hidden / detached  →  [FakeChatStream.pause]  (buffer messages)
///   resumed                     →  [FakeChatStream.resume] (flush buffer)
///
/// Exposes [syncStatus] as a broadcast stream so [ChatBloc] can reflect the
/// current state in [ChatState.syncStatus] → sync banner in the UI.
class BackgroundSyncManager {
  BackgroundSyncManager({
    required AppLifecycleObserver lifecycleObserver,
    required FakeChatStream chatStream,
  })  : _stream = chatStream {
    _syncController = StreamController<SyncStatus>.broadcast();
    _lifecycleSub = lifecycleObserver.stream.listen(_onLifecycleChange);
  }

  final FakeChatStream _stream;
  late final StreamController<SyncStatus> _syncController;
  late final StreamSubscription<AppLifecycleState> _lifecycleSub;

  SyncStatus _current = SyncStatus.connected;

  /// Broadcast stream of [SyncStatus] transitions.
  Stream<SyncStatus> get syncStatus => _syncController.stream;

  SyncStatus get currentStatus => _current;

  // ---------------------------------------------------------------------------
  // Lifecycle handling
  // ---------------------------------------------------------------------------

  Future<void> _onLifecycleChange(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        await _goBackground();
      case AppLifecycleState.resumed:
        await _goForeground();
      case AppLifecycleState.inactive:
        // Transient state (e.g. phone call overlay) — no action.
        break;
    }
  }

  Future<void> _goBackground() async {
    if (_current == SyncStatus.background) return;
    _stream.pause();
    _emit(SyncStatus.background);
  }

  Future<void> _goForeground() async {
    if (_current == SyncStatus.connected) return;

    final hadBuffered = _stream.bufferedCount > 0;

    if (hadBuffered) {
      // Signal "syncing" while we flush the buffer.
      _emit(SyncStatus.syncing);
      await _stream.resume();
      // Small grace period so the UI can show the syncing banner briefly
      // even if the buffer flush was near-instant.
      await Future<void>.delayed(const Duration(milliseconds: 600));
    } else {
      await _stream.resume();
    }

    _emit(SyncStatus.connected);
  }

  void _emit(SyncStatus status) {
    _current = status;
    _syncController.add(status);
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  Future<void> dispose() async {
    await _lifecycleSub.cancel();
    await _syncController.close();
  }
}
