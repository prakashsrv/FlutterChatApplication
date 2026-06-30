import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/stream/fake_network_config.dart';
import '../../data/sync/background_sync_manager.dart';
import '../../domain/stream/chat_message_stream.dart';
import '../../domain/usecase/observe_messages_usecase.dart';
import '../../domain/usecase/retry_message_usecase.dart';
import '../../domain/usecase/send_message_usecase.dart';
import 'chat_effect.dart';
import 'chat_event.dart';
import 'chat_state.dart';

/// The Bloc that drives the chat screen — mirrors Android's ChatViewModel.
///
/// Events  = ChatAction
/// State   = ChatUiState
/// Effects = SharedFlow<ChatEffect>  → exposed as a broadcast [Stream<ChatEffect>].
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({
    required SendMessageUseCase sendMessageUseCase,
    required ObserveMessagesUseCase observeMessagesUseCase,
    required RetryMessageUseCase retryMessageUseCase,
    required ChatMessageStream chatMessageStream,
    required FakeNetworkConfig networkConfig,
    required BackgroundSyncManager syncManager,
  })  : _sendMessage = sendMessageUseCase,
        _retryMessage = retryMessageUseCase,
        _networkConfig = networkConfig,
        super(const ChatState()) {
    on<InputChanged>(_onInputChanged);
    on<SendMessage>(_onSendMessage);
    on<RetryMessage>(_onRetryMessage);
    on<SimulateNextFailure>(_onSimulateNextFailure);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<TypingChanged>(_onTypingChanged);
    on<SyncStatusChanged>(_onSyncStatusChanged);

    // Subscribe to the reactive DB stream.
    _messagesSub = observeMessagesUseCase().listen(
      (messages) => add(ChatEvent.messagesUpdated(messages)),
    );

    // Subscribe to the peer's typing indicator.
    _typingSub = chatMessageStream.isTyping.listen(
      (isTyping) => add(ChatEvent.typingChanged(isTyping)),
    );

    // Subscribe to background-sync status transitions.
    _syncSub = syncManager.syncStatus.listen(
      (status) => add(ChatEvent.syncStatusChanged(status)),
    );
  }

  final SendMessageUseCase _sendMessage;
  final RetryMessageUseCase _retryMessage;
  final FakeNetworkConfig _networkConfig;

  late final StreamSubscription<void> _messagesSub;
  late final StreamSubscription<void> _typingSub;
  late final StreamSubscription<void> _syncSub;

  // One-shot effect channel — semantically identical to Android's SharedFlow.
  final _effectController = StreamController<ChatEffect>.broadcast();
  Stream<ChatEffect> get effects => _effectController.stream;

  // ---------------------------------------------------------------------------
  // Handlers
  // ---------------------------------------------------------------------------

  void _onInputChanged(InputChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(inputText: event.text));
  }

  Future<void> _onSendMessage(
      SendMessage event, Emitter<ChatState> emit) async {
    final text = state.inputText.trim();
    if (text.isEmpty) return;

    emit(state.copyWith(inputText: ''));
    _effectController.add(const ChatEffect.scrollToBottom());

    await _sendMessage(content: text, senderId: 'me');
  }

  Future<void> _onRetryMessage(
      RetryMessage event, Emitter<ChatState> emit) async {
    await _retryMessage(event.message);
  }

  void _onSimulateNextFailure(
      SimulateNextFailure event, Emitter<ChatState> emit) {
    _networkConfig.setFailNext();
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    final previous = state.messages;
    emit(state.copyWith(messages: event.messages));

    if (event.messages.length > previous.length) {
      _effectController.add(const ChatEffect.scrollToBottom());
    }
  }

  void _onTypingChanged(TypingChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(isTypingIndicatorVisible: event.isTyping));
  }

  void _onSyncStatusChanged(
      SyncStatusChanged event, Emitter<ChatState> emit) {
    emit(state.copyWith(syncStatus: event.status));
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() async {
    await _messagesSub.cancel();
    await _typingSub.cancel();
    await _syncSub.cancel();
    await _effectController.close();
    return super.close();
  }
}
