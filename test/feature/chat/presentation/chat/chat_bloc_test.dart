import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_chat_app/feature/chat/data/stream/fake_network_config.dart';
import 'package:flutter_chat_app/feature/chat/domain/model/message.dart';
import 'package:flutter_chat_app/feature/chat/domain/model/message_status.dart';
import 'package:flutter_chat_app/feature/chat/domain/stream/chat_message_stream.dart';
import 'package:flutter_chat_app/feature/chat/domain/usecase/observe_messages_usecase.dart';
import 'package:flutter_chat_app/feature/chat/domain/usecase/retry_message_usecase.dart';
import 'package:flutter_chat_app/feature/chat/domain/usecase/send_message_usecase.dart';
import 'package:flutter_chat_app/feature/chat/presentation/chat/chat_bloc.dart';
import 'package:flutter_chat_app/feature/chat/presentation/chat/chat_effect.dart';
import 'package:flutter_chat_app/feature/chat/presentation/chat/chat_event.dart';
import 'package:flutter_chat_app/feature/chat/presentation/chat/chat_state.dart';

// --- Mocks -------------------------------------------------------------------

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}
class MockObserveMessagesUseCase extends Mock implements ObserveMessagesUseCase {}
class MockRetryMessageUseCase extends Mock implements RetryMessageUseCase {}
class MockChatMessageStream extends Mock implements ChatMessageStream {}

// --- Helpers -----------------------------------------------------------------

Message _msg(String id) => Message(
      id: id,
      content: 'msg $id',
      senderId: 'bot',
      clientTimestamp: 1000,
      status: MessageStatus.sent,
      isOwn: false,
    );

ChatBloc _makeBloc({
  MockSendMessageUseCase? send,
  MockObserveMessagesUseCase? observe,
  MockRetryMessageUseCase? retry,
}) {
  final s = send ?? MockSendMessageUseCase();
  final o = observe ?? MockObserveMessagesUseCase();
  final r = retry ?? MockRetryMessageUseCase();
  final ms = MockChatMessageStream();

  when(() => o()).thenAnswer((_) => const Stream.empty());
  when(() => ms.isTyping).thenAnswer((_) => const Stream.empty());

  return ChatBloc(
    sendMessageUseCase: s,
    observeMessagesUseCase: o,
    retryMessageUseCase: r,
    chatMessageStream: ms,
    networkConfig: FakeNetworkConfig(),
  );
}

// Collect all states emitted while [act] runs, then close the bloc.
Future<List<ChatState>> collectStates(
  ChatBloc bloc,
  Future<void> Function(ChatBloc) act,
) async {
  final states = <ChatState>[];
  final sub = bloc.stream.listen(states.add);
  await act(bloc);
  await Future<void>.delayed(const Duration(milliseconds: 50));
  await sub.cancel();
  return states;
}

// --- Tests -------------------------------------------------------------------

void main() {
  setUpAll(() {
    registerFallbackValue(_msg('fallback'));
  });

  group('ChatBloc — InputChanged', () {
    test('updates inputText', () async {
      final bloc = _makeBloc();
      final states = await collectStates(
        bloc,
        (b) async => b.add(const ChatEvent.inputChanged('hello')),
      );
      expect(states.last.inputText, 'hello');
      await bloc.close();
    });

    test('clears inputText on empty string', () async {
      final bloc = _makeBloc();
      bloc.add(const ChatEvent.inputChanged('draft'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final states = await collectStates(
        bloc,
        (b) async => b.add(const ChatEvent.inputChanged('')),
      );
      expect(states.last.inputText, '');
      await bloc.close();
    });
  });

  group('ChatBloc — SendMessage', () {
    test('clears inputText after send', () async {
      final send = MockSendMessageUseCase();
      when(() => send(
            content: any(named: 'content'),
            senderId: any(named: 'senderId'),
          )).thenAnswer((_) async {});

      final bloc = _makeBloc(send: send);
      bloc.add(const ChatEvent.inputChanged('Hello'));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final states = await collectStates(
        bloc,
        (b) async => b.add(const ChatEvent.sendMessage()),
      );
      expect(states.last.inputText, '');
      await bloc.close();
    });

    test('blank input does NOT call SendMessageUseCase', () async {
      final send = MockSendMessageUseCase();
      final bloc = _makeBloc(send: send);

      // inputText is '' by default
      bloc.add(const ChatEvent.sendMessage());
      await Future<void>.delayed(const Duration(milliseconds: 30));

      verifyNever(() => send(
            content: any(named: 'content'),
            senderId: any(named: 'senderId'),
          ));
      await bloc.close();
    });
  });

  group('ChatBloc — TypingChanged', () {
    test('sets isTypingIndicatorVisible to true', () async {
      final bloc = _makeBloc();
      final states = await collectStates(
        bloc,
        (b) async => b.add(const ChatEvent.typingChanged(true)),
      );
      expect(states.last.isTypingIndicatorVisible, isTrue);
      await bloc.close();
    });

    test('clears typing indicator', () async {
      final bloc = _makeBloc();
      bloc.add(const ChatEvent.typingChanged(true));
      await Future<void>.delayed(const Duration(milliseconds: 10));

      final states = await collectStates(
        bloc,
        (b) async => b.add(const ChatEvent.typingChanged(false)),
      );
      expect(states.last.isTypingIndicatorVisible, isFalse);
      await bloc.close();
    });
  });

  group('ChatBloc — MessagesUpdated', () {
    test('updates message list', () async {
      final bloc = _makeBloc();
      final msgs = [_msg('1'), _msg('2')];
      final states = await collectStates(
        bloc,
        (b) async => b.add(ChatEvent.messagesUpdated(msgs)),
      );
      expect(states.last.messages, msgs);
      await bloc.close();
    });
  });

  group('ChatBloc — RetryMessage', () {
    test('calls RetryMessageUseCase with the failed message', () async {
      final retry = MockRetryMessageUseCase();
      final failedMsg = _msg('failed').copyWith(status: MessageStatus.failed);
      when(() => retry(failedMsg)).thenAnswer((_) async {});

      final bloc = _makeBloc(retry: retry);
      bloc.add(ChatEvent.retryMessage(failedMsg));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await bloc.close();

      verify(() => retry(failedMsg)).called(1);
    });
  });

  group('ChatBloc — Effects', () {
    test('ScrollToBottom emitted when SendMessage dispatched with non-empty input',
        () async {
      final send = MockSendMessageUseCase();
      when(() => send(
            content: any(named: 'content'),
            senderId: any(named: 'senderId'),
          )).thenAnswer((_) async {});

      final bloc = _makeBloc(send: send);
      final effects = <ChatEffect>[];
      final sub = bloc.effects.listen(effects.add);

      bloc.add(const ChatEvent.inputChanged('Hi'));
      bloc.add(const ChatEvent.sendMessage());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      await sub.cancel();
      await bloc.close();

      expect(effects, contains(isA<ScrollToBottom>()));
    });

    test('ScrollToBottom emitted when new messages arrive', () async {
      final bloc = _makeBloc();
      final effects = <ChatEffect>[];
      final sub = bloc.effects.listen(effects.add);

      bloc.add(ChatEvent.messagesUpdated([_msg('1')]));
      bloc.add(ChatEvent.messagesUpdated([_msg('1'), _msg('2')]));
      await Future<void>.delayed(const Duration(milliseconds: 30));

      await sub.cancel();
      await bloc.close();

      expect(effects.whereType<ScrollToBottom>(), isNotEmpty);
    });
  });
}
